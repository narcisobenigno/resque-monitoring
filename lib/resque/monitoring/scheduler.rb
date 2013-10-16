# encoding: utf-8

require_relative 'scheduler/last_execution'

module Resque
  module Monitoring
    module Scheduler
      def before_enqueue_record_last_execution
        last_execution.report_new
      end

      def scheduler_ok_when(&assert)
        @assert = assert
        self
      end

      def status
        last_execution_date = last_execution.date
        return not_executed_yet unless last_execution_date.present?
        return Status.ok if assert.call(last_execution_date)
        executed_long_time_ago(last_execution_date)
      end

      private
      def not_executed_yet
        Status.error('not executed yet')
      end

      def executed_long_time_ago(last_execution_date)
        Status.error("executed a long time ago, last execution: #{last_execution_date}")
      end

      def assert
        @assert ||= default_assert
      end

      def last_execution
        @last_execution ||= LastExecution.by(name)
      end

      def default_assert
        Proc.new do |last_execution|
          last_execution >= DateTime.now - 15.minutes
        end
      end
    end
  end
end

