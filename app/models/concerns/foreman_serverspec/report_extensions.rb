module ForemanServerspec
  module ReportExtensions
    extend ActiveSupport::Concern

    included do
      has_many :examples
    end
  end
end
