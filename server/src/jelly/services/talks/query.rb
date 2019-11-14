# frozen_string_literal: true

require 'active_support/core_ext/hash'
require_relative '../base'
require_relative '../talks'

module Jelly
  module Services
    module Talks
      class Query < ::Jelly::Services::Base
        def call
          raw = lua.talks.query [NAMESPACE]

          records = MessagePack.unpack(raw).compact.map do |_id, hash|
            Talks.build(*hash['data'])
          end

          success records
        end
      end
    end
  end
end
