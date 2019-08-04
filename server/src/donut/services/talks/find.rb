# frozen_string_literal: true

require 'active_support/core_ext/hash'
require_relative '../base'

module Donut
  module Services
    module Talks
      class Find < ::Donut::Services::Base
        SCRIPT = <<~LUA
          if redis.call("EXISTS", ARGV[1] .. ARGV[2]) == 1 then
            local record = redis.call("GET", ARGV[1] .. ARGV[2])
            local score = redis.call("ZSCORE", ARGV[1] .. "all", ARGV[2])
            return { record, score }
          else
            return nil
          end
        LUA

        def call(id)
          raw = redis.eval SCRIPT, [], ["#{NAMESPACE}:", id]
          return nil unless raw.present?

          JSON.parse(raw[0]).with_indifferent_access.merge votes: raw[1].to_f
        end
      end
    end
  end
end
