# Sidekiq::Clockwork

Sidekiq::Clockwork is a simplistic implementation of a job scheduler based on Clockwork, but without having to run a separated process.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "sidekiq-clockwork"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-clockwork

## Usage

Create your job scheduler and make sure that it's loaded by Sidekiq's server (when you run the `sidekiq` command).

```ruby
Sidekiq::Clockwork.run do
  # This is the default timeout
  # sleep_timeout 0.1

  # By default, it comes with a error handler like the following:
  # error_handler do |error|
  #   $stderr << "[CLOCKWORK] #{error.class}: #{error.message}"
  #   $stderr << " (" << error.backtrace_locations.first << ")\n"
  # end
  #
  # You can clean up error handlers with:
  # error_handlers.clear
  #
  # You may want to use an exception tracker like Rollbar:
  # error_handler do |error|
  #   Rollbar.error(error)
  # end
  #

  # You can schedule jobs by using `every`, which receives
  # an interval in seconds.
  every(30.seconds) { SomeWorker.perform_async }
end
```

Sidekiq::Clockwork is single-threaded and sequencial by design, so make sure your scheduler only enqueue jobs without doing any processing (tl;dr make it as fast as you can).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fnando/sidekiq-clockwork. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sidekiq::Clockwork project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fnando/sidekiq-clockwork/blob/master/CODE_OF_CONDUCT.md).
