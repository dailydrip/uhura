# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

# Clearing here because I want them to run in this order, specifically.
task(:default).clear

task :default do
  %i[rubocop spec].each do |task|
    Rake::Task[task].invoke
  rescue SystemExit
    puts "\e[31mTask Failed\e[0m"
  end
end
