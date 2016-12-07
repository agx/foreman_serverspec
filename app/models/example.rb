class Example < ActiveRecord::Base
    belongs_to :report

    validates :report_id, :status_id, :full_description, :presence => true

    LEVELS = [ 'passed', 'pending', 'failed' ]

    def status=(l)
      write_attribute(:status_id, LEVELS.index(l))
    end

    def status
      LEVELS[status_id]
    end
end
