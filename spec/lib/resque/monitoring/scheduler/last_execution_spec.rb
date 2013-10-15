require 'spec_helper'

describe Resque::Monitoring::Scheduler::LastExecution do
  let(:class_name) { 'ClassTestName' }
  subject { described_class.new(class_name) }
  let(:now) { DateTime.iso8601('2013-10-11T16:19:13-03:00') }

  before { allow(DateTime).to receive(:now).and_return(now) }

  describe '#report_new' do
    it 'records execution timestamp' do
      expect(Resque.redis).to receive(:set).with("monitoring:last_execution:#{class_name}", now.iso8601)
      subject.report_new
    end
  end

  describe '#date' do
    context 'gets last execution date' do
      before { allow(Resque.redis).to receive(:get).with("monitoring:last_execution:#{class_name}").and_return(now.iso8601) }
      its(:date) { should == now }
    end

    context 'when there is no date' do
      before { allow(Resque.redis).to receive(:get).and_return(nil) }
      its(:date) { should == DateTime.now - 30.years }
    end
  end
end
