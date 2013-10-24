# Resque::Monitoring

Gem to monitor resque and some plugins.

## Installation

Add this line to your application's Gemfile:

    gem 'resque-monitoring'

And then execute:

    $ bundle

Or install it yourself:

    $ gem install resque-monitoring

## Usage

### Monitoring resque-scheduler
Extend your scheduled job with Resque::Monitoring::Scheduler, like this:

  class MyScheduledJob
    extend Resque::Monitoring::Scheduler
  end

Now you can check if scheduler is ok with the api below:

  MyScheduledJob.status.when_error do |message|
    # This block will be called if, and only if there is an error.
  end

The possible errors are:

1. The job was not executed yet;
2. The job was executed a long time ago (by default this means the job was executed more than 15 minutes ago).

You can customize the time limit since last execution:

  class MyScheduledJob
    extend Resque::Monitoring::Scheduler
    scheduler_ok_when do |last_execution|
      last_execution > 30.minutes.ago # the job will be qualified as healthy when the last execution was performed at most 30 minutes ago.
    end
  end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
