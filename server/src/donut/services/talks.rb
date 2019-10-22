# frozen_string_literal: true

module Donut
  module Services
    module Talks
      NAMESPACE = :talk

      class << self
        def build(
          data,
          votes = 0.0,
          voter_ids = [],
          scheduled_for = nil,
          links = []
        )
          obj = data.is_a?(Hash) ? data : JSON.parse(data)

          obj.with_indifferent_access.merge(
            votes_count: votes,
            voter_ids: voter_ids,
            scheduled_for: scheduled_for,
            links: links
          )
        end
      end
    end
  end
end
