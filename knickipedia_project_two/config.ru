require 'rake'
require 'redcarpet'
require 'json'
require 'rest-client'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sendgrid-ruby'
require 'pg'
require 'pry'
require_relative './app'

use Rack::MethodOverride

run App::Server