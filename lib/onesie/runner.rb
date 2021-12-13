# frozen_string_literal: true

module Onesie
  # The Runner is responsible for running tasks, recording errors, and printing
  # the output
  class Runner
    attr_reader :errors, :tasks

    # @param tasks [TaskProxy, Array<TaskProxy>]
    def self.perform(tasks)
      new(tasks).perform
    end

    # @param tasks [TaskProxy, Array<TaskProxy>]
    def initialize(tasks)
      @errors = {}
      @tasks = Array(tasks).sort_by(&:version)
    end

    def perform
      tasks.each do |task|
        task.run
      rescue StandardError => e
        puts "An error occurred with #{task.class.name}".red
        errors[task.class.name] = e
      end

      print_errors if errors.any?
    end

    private

    def print_errors
      puts "The following Tasks contained errors\n\n".red

      errors.each do |task_class, error|
        puts "#{task_class.red}: #{error.class} #{error.message}\n"
        puts error.full_message
        puts "\n"
      end
    end
  end
end