# encoding: utf-8

class Status
  attr_reader :name, :message
  @status = {}

  def self.ok
    fetch(:ok, 'status.alive') { |callback| }
  end

  def self.error(message)
    fetch(:error, message) do |callback|
      callback.call(message)
    end
  end

  def when_error(&callback)
    @status_callback.call(callback)
  end

  private
  def initialize(name, message, &status_callback)
    @name = name
    @message = message
    @status_callback = status_callback
  end

  def self.fetch(status, message, &callback)
    @status["#{status}#{message}"] ||= new(status, message, &callback)
  end
end
