class ServerspecReportsController < ApplicationController
  include Foreman::Controller::AutoCompleteSearch

  before_action :setup_search_options, :only => :index

  def index
    @serverspec_reports = resource_base_search_and_page(:host)
  end

  def show
    # are we searching for the last report?
    if params[:id] == "last"
      conditions = { :host_id => resource_finder(Host.authorized(:view_hosts), params[:host_id]).try(:id) } if params[:host_id].present?
      params[:id] = resource_base.where(conditions).maximum(:id)
    end

    return not_found if params[:id].blank?

    @serverspec_report = resource_base.includes(:logs => [:message, :source]).find(params[:id])
    @offset = @serverspec_report.reported_at - @serverspec_report.created_at
  end

  def destroy
    @serverspec_report = resource_base.find(params[:id])
    if @serverspec_report.destroy
      process_success(:success_msg => _("Successfully deleted Serverspec report."), :success_redirect => serverspec_reports_path)
    else
      process_error
    end
  end

  private

  def resource_base
    super.my_reports
  end
end
