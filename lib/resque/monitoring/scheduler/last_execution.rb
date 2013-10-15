
module Resque
  module Monitoring
    module Scheduler
      class LastExecution
        def initialize(class_name)
          @class_name = class_name
        end

        def self.by(class_name)
          new(class_name)
        end

        def report_new
          Resque.redis.set(key, DateTime.now.iso8601)
        end

        def date
          value = Resque.redis.get(key)
          return DateTime.iso8601(value) if value
          DateTime.now - 30.years
        end

        private
        def key
          "monitoring:last_execution:#{@class_name}"
        end
      end
    end
  end
end
