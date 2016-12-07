module ForemanServerspec
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      has_one :serverspec_status_object, :class_name => 'HostStatus::ServerspecStatus', :foreign_key => 'host_id'

      scoped_search :in => :serverspec_status_object, :on => :status, :rename => :'serverspec_status',
               :complete_value => { :passed => HostStatus::ServerspecStatus::PASSED,
                                    :failed => HostStatus::ServerspecStatus::FAILED }
    end

    def serverspec_status(options = {})
      @serverspec_status ||= get_status(HostStatus::ServerspecStatus).to_status(options)
    end

    def serverspec_status_label(options = {})
      @serverspec_status_label ||= get_status(HostStatus::ServerspecStatus).to_label(options)
    end
  end
end
