class HostStatus::ServerspecStatus < ::HostStatus::Status
  PASSED = 0
  FAILED = 1

  def self.status_name
    N_('Serverspec')
  end

  def self.bit_mask(status)
    "#{ServerspecReport::BIT_NUM * ServerspecReport::METRIC.index(status)} & #{ServerspecReport::MAX}"
  end

  def to_label(options = {})
    case to_status
    when PASSED
      N_('Serverspec passed')
    when FAILED
      N_('Serverspec failed')
    else
      N_('Unknown Serverspec status')
    end
  end

  def to_global(options = {})
    case to_status
    when PASSED
      ::HostStatus::Global::OK
    else
      ::HostStatus::Global::ERROR
    end
  end

  def relevant?(options = {})
    return false
  end

  def to_status(options = {})
    latest_reports = host.last_serverspec_report
    return FAILED if latest_reports.any?(&:failed?)
    PASSED
  end
end

