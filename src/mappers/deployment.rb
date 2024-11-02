# frozen_string_literal: true

require_relative 'base'

module ScalingoApi
  module Mappers
    # wraps a single deployment JSON
    class Deployment < Base
      def success?
        data['status'] == 'success'
      end

      def average_time
        finished_at - created_at
      end

      def finished_at
        Time.parse(data['finished_at'])
      end

      def created_at
        Time.parse(data['created_at'])
      end
    end
  end
end
