# frozen_string_literal: true

require_relative './node'

module Donut
  module GraphQL
    module Types
      class User < ::Donut::GraphQL::Types::Node
        field :profile_picture_url, String, null: true

        def profile_picture_url
          object.dig :google_profile, :picture
        end
      end
    end
  end
end
