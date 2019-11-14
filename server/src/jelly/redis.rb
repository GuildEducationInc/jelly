# frozen_string_literal: true

module Jelly
  class Redis
    include Singleton

    attr_reader :client
    cattr_accessor :logger

    def initialize
      @client = ::Redis.new logger: self.class.logger
    end
  end
end
