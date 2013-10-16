# encoding: utf-8
require 'spec_helper'

describe Status do
  describe '.ok' do
    subject { Status.ok }

    its(:name) { should == :ok }
    its(:message) { should == 'status.alive' }
    it { should == Status.ok }
  end

  describe '.error' do
    subject { Status.error('error.message') }

    its(:name) { should == :error }
    its(:message) { should == 'error.message' }
    it { should == Status.error(subject.message) }
  end

  describe '#when_error' do
    let(:error_callback) { double(message: nil) }

    context 'whether status ok' do
      before { Status.ok.when_error { |message| error_callback.message } }
      it { expect(error_callback).to_not have_received(:message) }
    end

    context 'whether status error' do
      before {
        Status.error('error').when_error { |message| error_callback.message(message) }
      }
      it { expect(error_callback).to have_received(:message).with('error') }
    end
  end
end
