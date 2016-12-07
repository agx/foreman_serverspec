class ServerspecReportStatusCalculator
  # converts a summary hash into a bit field
  def initialize(options = {})
    @counters   = options[:counters]  || {}
    @raw_status = options[:bit_field] || 0
  end

  # calculates the raw_status based on counters
  def calculate
    @raw_status = 0
    counters.each do |type, value|
      
      next if not ServerspecReport::METRIC.include?(type)
      value = value.to_i # JSON does everything as strings
      value = ServerspecReport::MAX if value > ServerspecReport::MAX # we store up to 2^BIT_NUM -1 values as we want to use only BIT_NUM bits.
      @raw_status |= value << (ServerspecReport::BIT_NUM * ServerspecReport::METRIC.index(type))
    end
    raw_status
  end

  # returns metrics (counters) based on raw_status (aka bit field)
  # to get status of specific metric, @see #status_of
  def status
    @status ||= begin
      calculate if raw_status == 0
      counters = Hash.new(0)
      ServerspecReport::METRIC.each do |m|
        counters[m] = (raw_status || 0) >> (ServerspecReport::BIT_NUM * ServerspecReport::METRIC.index(m)) & ServerspecReport::MAX
      end
      counters
    end
  end

  def status_of(counter)
    raise(Foreman::Exception.new(N_("invalid type %s"), counter)) unless ServerspecReport::METRIC.include?(counter)
    status[counter]
  end

  # returns true if total error metrics are > 0
  def error?
    status_of('failure_count') > 0
  end

  # returns true if there are any changes pending
  def pending?
    status_of('pending_count') > 0
  end

  # generate dynamically methods for all metrics
  # e.g. applied failed ...
  ServerspecReport::METRIC.each do |method|
    define_method method do
      status_of(method)
    end
  end

  private

  attr_reader :raw_status, :counters
end
