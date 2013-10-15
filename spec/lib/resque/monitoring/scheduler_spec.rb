# encoding: utf-8
require 'spec_helper'

Scheduler = Resque::Monitoring::Scheduler
LastExecution = Resque::Monitoring::Scheduler::LastExecution

describe Scheduler do
  let(:now) { DateTime.iso8601('2013-10-11T16:19:13-03:00') }
  before {
    allow(Resque.redis).to receive(:set)
    allow(DateTime).to receive(:now).and_return(now)
  }

  describe '.before_enqueue_record_last_execution' do
    subject { class TestJob; extend Scheduler; end }
    it 'records execution timestamp' do
      expect_any_instance_of(LastExecution).to receive(:report_new)
      subject.before_enqueue_record_last_execution
    end
  end

  describe '.status' do
    before { allow_any_instance_of(LastExecution).to receive(:date).and_return(DateTime.now) }
    context 'when assert matches' do
      subject {
        class TestJob
          extend Scheduler
          scheduler_ok_when do |last_execution|
            last_execution > DateTime.now - 1.second
          end
        end
      }
      its(:status) { should == :ok }
    end

    context 'when assert not matches' do
      subject {
        class TestJob
          extend Scheduler
          scheduler_ok_when do |last_execution|
            last_execution > DateTime.now
          end
        end
      }
      its(:status) { should == :error }
    end

    context 'uses 15 minutes ago as default assert' do
      subject {
        class TestJob
          extend Scheduler
        end
      }
      context 'last execution >= 15 minutes ago' do
        before { allow_any_instance_of(LastExecution).to receive(:date).and_return(DateTime.now - 15.minutes) }
        its(:status) { should == :ok }
      end

      context 'last execution < 50 minutes ago' do
        before { allow_any_instance_of(LastExecution).to receive(:date).and_return(DateTime.now - 15.minutes - 1.second) }
        its(:status) { should == :error }
      end
    end
  end

  after { Object.send(:remove_const, :TestJob) }
end

