# frozen_string_literal: true

module Donut
  class Redis
    include Singleton

    attr_reader :client

    def initialize
      @client = ::Redis.new
    end
  end
end
