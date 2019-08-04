# frozen_string_literal: true

require_relative '../base'

module Donut
  module Services
    module Talks
      class Vote < ::Donut::Services::Base
        def call(id:, direction:)
          vote! id, direction
          services[:find].call id
        rescue StandardError => e
          failure [e.message]
        end

        private

        def vote!(id, direction)
          redis.zincrby "#{NAMESPACE}:all", direction, id
        end

        def services
          {
            find: ::Donut::Services::Talks::Find
          }
        end
      end
    end
  end
end
