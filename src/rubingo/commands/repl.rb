# frozen_string_literal: true

require 'debug'

require_relative '../../rubingo'

module Rubingo
  module Commands
    # drops the user in an IRB-like (debug) prompt with the API setup
    class Repl < Dry::CLI::Command
      desc 'Provide a REPL to try the API interface'

      argument :app, required: true, desc: 'The name of the Scalingo app'

      def call(**options)
        api = Rubingo::API.new(options[:app])

        debugger
      end
    end
  end
end
