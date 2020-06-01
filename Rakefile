ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'


def reload!
  load_all './lib'
end

task :console do
  Pry.start
end