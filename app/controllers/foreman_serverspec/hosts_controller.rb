module ForemanServerspec
  # Example: Plugin's HostsController inherits from Foreman's HostsController
  class HostsController < ::HostsController
    # change layout if needed
    # layout 'foreman_serverspec/layouts/new_layout'

    def new_action
      # automatically renders view/foreman_serverspec/hosts/new_action
    end
  end
end
