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
        return :ok if assert.call(last_execution.date)
        :error
      end

      private
      def assert
        @assert ||= Proc.new do |last_execution|
                               last_execution >= DateTime.now - 15.minutes
                             end
      end

      def last_execution
        @last_execution ||= LastExecution.by(name)
      end
    end
  end
end

