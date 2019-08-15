# frozen_string_literal: true

require "test_helper"

module Sidekiq
  def self.server?
    true
  end
end

class ClockworkTest < Minitest::Test
  def wait_for_interruption(clockwork)
    loop do
      break if clockwork.interrupt?

      sleep 0.01
    end
  end

  test "run job every 1 second" do
    times = []
    start = Time.now.to_i

    clockwork = Sidekiq::Clockwork.run do
      every(1) do
        times << Time.now.to_i
        interrupt! if times.size == 2
      end
    end

    wait_for_interruption(clockwork)

    assert_equal 2, times.size
    assert_equal 1, times[0] - start
    assert_equal 2, times[1] - start
  end

  test "use default error handler" do
    _, stderr = capture_io do
      clockwork = Sidekiq::Clockwork.run do
        every(0.1) do
          raise "ouch!"
        end

        every(0.1) do
          interrupt!
        end
      end

      wait_for_interruption(clockwork)
    end

    assert_equal "[SIDEKIQ:CLOCKWORK] RuntimeError: ouch! (#{__FILE__}:42:in `block (4 levels) in <class:ClockworkTest>')\n", stderr
  end

  test "use custom error handler" do
    err = nil

    clockwork = Sidekiq::Clockwork.run do
      error_handlers.clear

      error_handler do |error|
        err = error
        interrupt!
      end

      every(0.1) do
        raise "ouch!"
      end
    end

    wait_for_interruption(clockwork)

    assert_kind_of RuntimeError, err
    assert_equal "ouch!", err.message
  end

  test "don't explode if error handler raises exception" do
    _, stderr = capture_io do
      clockwork = Sidekiq::Clockwork.run do
        error_handlers.clear

        error_handler do |_error|
          raise "i had one job"
        end

        every(0.1) do
          raise "ouch!"
        end

        every(0.1) do
          interrupt!
        end
      end

      wait_for_interruption(clockwork)
    end

    assert_equal stderr, "[SIDEKIQ:CLOCKWORK] Error handler raised exception. RuntimeError: i had one job (#{__FILE__}:84:in `block (4 levels) in <class:ClockworkTest>')\n"
  end
end
