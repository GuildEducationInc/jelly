# frozen_string_literal: true

require 'active_support/core_ext/hash'
require_relative '../base'

module Donut
  module Services
    module Talks
      class Query < ::Donut::Services::Base
        KEY = "#{NAMESPACE}:all"

        def call
          ids = redis.zrevrangebyscore(KEY, '+inf', '-inf', withscores: true)
          hash = ids.to_h.transform_keys { |id| key id }
          return success([]) if hash.compact.empty?

          records = redis.mget(hash.keys).map do |record|
            obj = JSON.parse(record).with_indifferent_access
            obj.merge votes: hash[key obj[:id]]
          end

          success records.compact
        end

        private

        def key(id)
          "#{NAMESPACE}:#{id}"
        end
      end
    end
  end
end
