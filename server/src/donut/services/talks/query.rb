# frozen_string_literal: true

require 'active_support/core_ext/hash'
require_relative '../base'

module Donut
  module Services
    module Talks
      class Query < ::Donut::Services::Base
        SCRIPT = <<~LUA
          local ids = redis.call("ZREVRANGEBYSCORE", ARGV[1] .. ":all", 0, -1)
          for i, id in ipairs(ids) do ids[i] = ARGV[1] .. ":" .. id end
          return redis.call("MGET", unpack(ids))
        LUA

        def call
          raw = redis.eval(SCRIPT, [], [NAMESPACE]).compact
          records = raw.map do |record|
            JSON.parse(record).with_indifferent_access
          end

          success records
        end
      end
    end
  end
end
