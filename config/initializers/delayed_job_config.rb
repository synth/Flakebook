Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 1.hour
Delayed::Worker.read_ahead = 10
Delayed::Worker.delay_jobs = true#!Rails.env.test?
Delayed::Worker.logger = Rails.logger
Delayed::Worker.logger.auto_flushing = 1

module Delayed
  class Worker
    def say_with_flushing(text, level = Logger::INFO)
      if logger
        say_without_flushing(text, level)
        logger.flush
      end
    end
    alias_method_chain :say, :flushing
  end
end