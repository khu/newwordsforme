# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.


require File.expand_path('../config/application', __FILE__)
require 'rake'

# for ci_reporter
require 'rubygems'
gem 'ci_reporter'
require 'ci/reporter/rake/test_unit'
# for ci_reporter end
include Rake::DSL
Keepin::Application.load_tasks
