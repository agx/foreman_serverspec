#
# Copyright (c) 2016 Red Hat Inc.
#
# This software is licensed to you under the GNU General Public License,
# version 3 (GPLv3). There is NO WARRANTY for this software, express or
# implied, including the implied warranties of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv3
# along with this software; if not, see http://www.gnu.org/licenses/gpl.txt
#

module Api
  module V2
    module Tests
      
      class ServerspecReportsController < V2::BaseController
        include Api::Version2
        include Foreman::Controller::SmartProxyAuth

        before_action :find_resource, :only => %w{show destroy}
        before_action :setup_search_options, :only => [:index, :last]

        add_smart_proxy_filters :create, :features => Proc.new { ServerspecReportImporter.authorized_smart_proxy_features }

        api :GET, "/tests/serverspec_reports/", N_("List all serverspec reports")
        param_group :search_and_pagination, ::Api::V2::BaseController

        def index
          @reports = resource_scope_for_index.my_reports
          @total = resource_class.my_reports.count
        end

        api :GET, "/tests/serverspec_reports/:id/", N_("Show a report")
        param :id, :identifier, :required => true

        def show
        end

        def_param_group :serverspec_report do
          param :serverspec_report, Hash, :required => true, :action_aware => true do
            param :host, String, :required => true, :desc => N_("Hostname or certname")
            param :reported_at, String, :required => true, :desc => N_("UTC time of serverspec report")
            param :examples, Array, :desc => N_("Array of run examples")
            param :summary, Hash, :desc => N_("Test run summary")
          end
        end

        api :POST, "/tests/serverspec_reports/", N_("Create a serverspec report")
        param_group :serverspec_report, :as => :create

        def create
          @serverspec_report = ServerspecReport.import(params[:serverspec_report], detected_proxy.try(:id))
          process_response @serverspec_report.errors.empty?
        rescue ::Foreman::Exception => e
          render_message(e.to_s, :status => :unprocessable_entity) 
       end

        api :DELETE, "/tests/serverspec_reports/:id/", N_("Delete a report")
        param :id, String, :required => true

        def destroy
          process_response @serverspec_report.destroy
        end
      end
    end
  end
end
