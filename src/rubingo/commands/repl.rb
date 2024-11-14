# frozen_string_literal: true

require 'debug'

require_relative '../../rubingo'

require_relative './arguments/application'

module Rubingo
  module Commands
    # drops the user in an IRB-like (debug) prompt with the API setup
    class Repl < Dry::CLI::Command
      desc 'Provide a REPL to try the API interface'

      include Rubingo::Commands::Arguments::Application

      def call(**options)
        api = Rubingo::API.new(**options.slice(:application, :secnum))

        debugger
      end
    end
  end
end
