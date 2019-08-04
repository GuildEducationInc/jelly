# frozen_string_literal: true

module Donut
  module GraphQL
    module Types
      class Direction < ::GraphQL::Schema::Enum
        value :UP, value: 1
        value :DOWN, value: -1
      end
    end
  end
end
