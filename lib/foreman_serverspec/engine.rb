require 'deface'

module ForemanServerspec
  class Engine < ::Rails::Engine
    engine_name 'foreman_serverspec'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    initializer 'foreman_serverspec.load_app_instance_data' do |app|
      ForemanServerspec::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_serverspec.apipie' do
      Apipie.configuration.checksum_path += ['/tests/serverspec_reports/']
    end

    initializer 'foreman_serverspec.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_serverspec do
        requires_foreman '>= 1.4'

        apipie_documented_controllers ["#{ForemanServerspec::Engine.root}/app/controllers/api/v2/tests/serverspec_reports/*.rb"]

        # Add permissions
        #security_block :foreman_serverspec do
        #  permission :view_foreman_serverspec, :'foreman_serverspec/hosts' => [:new_action]
        #end

        role 'ForemanServerspec', [:view_foreman_serverspec]

        menu :top_menu, :serverspec_reports, :caption => N_('Serverspec'), :after => :reports,
             :url_hash => {:controller => :'serverspec_reports', :action => :index },
             :parent   => :monitor_menu

        register_custom_status HostStatus::ServerspecStatus
        widget 'foreman_serverspec_widget', name: N_('Serverspec overview'), sizex: 4, sizey: 1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_serverspec.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_serverspec.configure_assets', group: :assets do
      SETTINGS[:foreman_serverspec] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Report.send(:include, ForemanServerspec::ReportExtensions)
        Host::Managed.send(:include, ForemanServerspec::HostExtensions)
      rescue => e
        Rails.logger.warn "ForemanServerspec: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanServerspec::Engine.load_seed
      end
    end

    initializer 'foreman_serverspec.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_serverspec'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
