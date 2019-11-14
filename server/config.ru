# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require

require './src/jelly/app'

run Jelly::App
