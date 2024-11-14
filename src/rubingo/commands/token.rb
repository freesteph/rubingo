# frozen_string_literal: true

require 'httparty'

require_relative '../../rubingo'

module Rubingo
  module Commands
    # grabs the exchange token
    class Token < Dry::CLI::Command
      desc 'Get a fresh token from Scalingo and write it in the env file'

      option :write, type: :boolean, default: true, desc: 'Write the token in the .env file'

      def call(**options)
        token = grab_exchange_token

        if options.fetch(:write)
          File.write('.env', "\nSCALINGO_EXCHANGE_TOKEN=#{token}", mode: 'a+')
        else
          puts "Your Scalingo exchange token is:\n\n#{token}\n\n"
        end
      end

      private

      class ExchangeTokenError < ::StandardError
        attr_reader :response

        def initialize(response)
          @response = response

          super
        end

        def message
          <<-ERR
      Something went wrong when asking for a token:

      #{response.body}

      Double check the value of the SCALINGO_API_TOKEN in your
      environment: it usually starts with "tk-...".

        ERR
        end
      end

      def grab_exchange_token
        api_token = ENV.fetch('SCALINGO_API_TOKEN')

        response = HTTParty.post(
          'https://auth.scalingo.com/v1/tokens/exchange',
          basic_auth: { password: api_token },
          headers: { 'Content-Type' => 'application/json' }
        )

        raise ExchangeTokenError, response unless response.success?

        response['token']
      end
    end
  end
end
