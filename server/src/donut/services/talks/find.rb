# frozen_string_literal: true

require 'active_support/core_ext/hash'
require_relative '../base'

module Donut
  module Services
    module Talks
      class Find < ::Donut::Services::Base
        def call(id:)
          find id
        rescue StandardError => e
          failure [e.message]
        end

        private

        def find(id)
          raw = lua.talks.find [NAMESPACE, id]
          success Talks.build(*MessagePack.unpack(raw))
        end
      end
    end
  end
end
