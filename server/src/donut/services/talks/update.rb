# frozen_string_literal: true

require_relative '../base'
require_relative './find'

module Donut
  module Services
    module Talks
      class Update < ::Donut::Services::Base
        def call(params = {})
          success update_talk!(params)
        end

        private

        def update_talk!(params)
          id = params.delete :id
          k = key id
          redis.watch k

          raise "talk not found: #{id}" unless redis.exists(k)

          prev = redis.get k
          obj = JSON.parse(prev).with_indifferent_access
          updated = obj.merge params.compact

          result = redis.multi do |txn|
            txn.set k.to_s, updated.to_json
            lua.talks.find [NAMESPACE, id]
          end

          Talks.build(*MessagePack.unpack(result.last))
        end

        def key(id)
          "#{NAMESPACE}:#{id}"
        end
      end
    end
  end
end
