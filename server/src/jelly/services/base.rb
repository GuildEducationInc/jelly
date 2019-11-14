# frozen_string_literal: true

require_relative '../redis'

module Jelly
  module Services
    class Base
      Result = Struct.new :success, :value do
        def success?
          success
        end

        def failure?
          !success
        end
      end

      class << self
        def call(*args)
          new.call(*args)
        end
      end

      protected

      def lua
        ::Wolverine
      end

      def success(value)
        Result.new true, value
      end

      def failure(value)
        Result.new false, value
      end

      def redis
        ::Jelly::Redis.instance.client
      end
    end
  end
end
