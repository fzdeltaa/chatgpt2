# app.rb
require 'sinatra'
require 'mysql2'
require 'sinatra/activerecord'
require 'digest'
require_relative 'routes'
require_relative 'models'
require_relative 'script/reverse'

set :database_file, 'database.yml'