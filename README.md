# sidekiq-clockwork

[![Tests](https://github.com/fnando/sidekiq-clockwork/workflows/Tests/badge.svg)](https://github.com/fnando/sidekiq-clockwork)
[![Gem](https://img.shields.io/gem/v/sidekiq-clockwork.svg)](https://rubygems.org/gems/sidekiq-clockwork)
[![Gem](https://img.shields.io/gem/dt/sidekiq-clockwork.svg)](https://rubygems.org/gems/sidekiq-clockwork)

Sidekiq::Clockwork is a simplistic implementation of a job scheduler based on
Clockwork, but without having to run a separate process.

## Installation

```bash
gem install sidekiq-clockwork
```

Or add the following line to your project's Gemfile:

```ruby
gem "sidekiq-clockwork"
```

## Usage

Create your job scheduler and make sure that it's loaded by Sidekiq's server
(when you run the sidekiq command).

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

Sidekiq::Clockwork is single-threaded and sequencial by design, so make sure
your scheduler only enqueue jobs without doing any processing (tl;dr make it as
fast as you can).

## Maintainer

- [Nando Vieira](https://github.com/fnando)

## Contributors

- https://github.com/fnando/sidekiq-clockwork/contributors

## Contributing

For more details about how to contribute, please read
https://github.com/fnando/sidekiq-clockwork/blob/main/CONTRIBUTING.md.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT). A copy of the license can be
found at https://github.com/fnando/sidekiq-clockwork/blob/main/LICENSE.md.

## Code of Conduct

Everyone interacting in the sidekiq-clockwork project's codebases, issue
trackers, chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/sidekiq-clockwork/blob/main/CODE_OF_CONDUCT.md).
