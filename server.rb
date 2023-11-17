# app.rb
require 'sinatra'
require 'mysql2'
require 'sinatra/activerecord'
require 'digest'
require 'openssl'
require 'base64'
require_relative 'routes'
require_relative 'models'
require_relative 'script/reverse'
require_relative 'script/algoritma_aes'

set :database_file, 'database.yml'