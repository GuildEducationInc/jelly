# frozen_string_literal: true

require_relative '../base'

module Donut
  module Services
    module Talks
      class Vote < ::Donut::Services::Base
        def call(id:, direction:)
          success vote!(id, direction)
        rescue StandardError => e
          failure [e.message]
        end

        private

        def vote!(id, direction); end
      end
    end
  end
end
