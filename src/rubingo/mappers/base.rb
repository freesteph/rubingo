# frozen_string_literal: true

module Rubingo
  module Mappers
    # the base class for all mappers; stores the data for later access.
    class Base
      attr_reader :data

      def initialize(data)
        @data = data
      end
    end
  end
end
