# frozen_string_literal: true

require 'active_support/core_ext/hash'
require_relative '../base'

module Donut
  module Services
    module Talks
      class Find < ::Donut::Services::Base
        def call(id)
          return nil unless redis.exists(key(id))

          raw = redis.get key(id)
          obj = JSON.parse(raw).with_indifferent_access
          votes = redis.zscore "#{NAMESPACE}:all", id
          success obj.merge(votes: votes)
        end

        private

        def key(id)
          "#{NAMESPACE}:#{id}"
        end
      end
    end
  end
end
