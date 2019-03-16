# frozen_string_literal: true

require "sidekiq/clockwork/version"

module Sidekiq
  class Clockwork
    SIGNALS = %w[INT TERM HUP].freeze

    def self.run(&block)
      return unless Sidekiq.server?

      clockwork = new
      clockwork.instance_eval(&block)
      clockwork.run
      clockwork
    end

    attr_reader :error_handlers

    def initialize
      @error_handlers = []
      @sleep_timeout = 0.1
      @interrupt = false

      use_default_error_handler
    end

    def jobs
      @jobs ||= []
    end

    def sleep_timeout(timeout = nil)
      @sleep_timeout = timeout if timeout
      @sleep_timeout
    end

    def every(interval, &block)
      run_at = Time.now + interval
      jobs << {run_at: run_at, interval: interval, block: block}
    end

    def error_handler(&block)
      error_handlers << block
    end

    def run_error_handlers(error)
      error_handlers.each do |handler|
        begin
          handler.call(error)
        rescue StandardError => handler_error
          $stderr << error_message(handler_error, "Error handler raised exception. ")
        end
      end
    end

    def error_message(error, prefix = nil)
      "[SIDEKIQ:CLOCKWORK] #{prefix}#{error.class}: #{error.message} (#{error.backtrace_locations.first})\n"
    end

    def use_default_error_handler
      error_handler do |error|
        $stderr << error_message(error)
      end
    end

    def run_job(job)
      now = Time.now

      return if now < job[:run_at]

      job[:run_at] = now + job[:interval]
      job[:block].call
    rescue StandardError => error
      run_error_handlers(error)
    end

    def interrupt?
      @interrupt
    end

    def interrupt!
      @interrupt = true
    end

    def trap_signals
      SIGNALS.each do |signal|
        trap(signal) do
          interrupt!
        end
      end
    end

    def run
      trap_signals

      Thread.new do
        loop do
          jobs.each do |job|
            run_job(job)
          end

          break if interrupt?

          sleep(sleep_timeout)
        end
      end
    end
  end
end
