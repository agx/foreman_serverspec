class ServerspecReport < Report
  METRIC = %w[example_count failure_count pending_count]
  BIT_NUM = 10
  MAX = (1 << BIT_NUM) -1 # maximum value per metric

  #has_many :examples
  
  class << self
    delegate :model_name, :to => :superclass
  end

  def self.import(report, proxy_id = nil)
    ServerspecReportImporter.import(report, proxy_id)
  end

  # report status table column name
  def self.report_status_column
    "status"
  end

  # a method that save the report values (e.g. values from METRIC)
  # it is not supported to edit status values after it has been written once.
  def status=(st)
    s = case st
          when Integer, Fixnum
            st
          when Hash
            ServerspecReportStatusCalculator.new(:counters => st).calculate
          else
            raise Foreman::Exception(N_('Unsupported report status format'))
        end
    write_attribute(:status, s)
  end

  def summary_status
    return _("Failed") if error?
    _("Success")
  end

  delegate :error?, :changes?, :pending?, :status, :status_of, :to => :calculator
  delegate(*METRIC, :to => :calculator)

  def calculator
    ServerspecReportStatusCalculator.new(:bit_field => read_attribute(self.class.report_status_column))
  end
end
