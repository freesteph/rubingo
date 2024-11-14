# frozen_string_literal: true

require_relative '../../rubingo'

module Rubingo
  module Commands
    class DeploymentsAverage < Dry::CLI::Command
      desc 'Write a CSV of the average deployments build time, per date'

      argument :app, required: true, desc: 'the Scalingo application name'

      def call(**options)
        api = Rubingo::API.new(options[:app])

        puts options[:app]
      end
    end
  end
end
