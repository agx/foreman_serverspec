class ServerspecReportImporter < ReportImporter
  def self.authorized_smart_proxy_features
    @authorized_smart_proxy_features ||= super + ['Puppet']
  end

  def report_name_class
    ServerspecReport
  end

  private

  def create_report_and_logs
    super
    return report unless report.persisted?
    # we update our host record, so we won't need to lookup the report information just to display the host list / info
    #host.update_attribute(:last_report, time) if host.last_report.nil? || host.last_report.utc < time
    import_examples
  end

  def examples
    raw['examples'] || []
  end
  
  def import_examples
    examples.each do |example|
      # Parse the API format
      full_desc = example['full_description']
      status    = example['status']
      file      = example['file_path']
      line      = example['line_number'].to_i

      # Symbols get turned into strings via the JSON API, so convert back here if it matches
      # an expected log level. Log objects can't be created without one, so raise if not
      #raise(::Foreman::Exception.new(N_("Invalid log level: %s", level))) unless Report::LOG_LEVELS.include?(level)

      Example.create(:report => report, :full_description => full_desc, :status => status, :file_path => file, :line_number => line)
    end
  end

  def report_status
    # Calculate the right stuff here
    ServerspecReportStatusCalculator.new(:counters => raw['summary']).calculate
  end
end

