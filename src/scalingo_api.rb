# frozen_string_literal: true

require 'debug'
require 'httparty'
require 'json'
require 'csv'
require 'time'

require_relative 'mappers/deployment'

# a simple wrapper around the Scalingo API
module ScalingoApi
  class API
    include HTTParty

    base_uri 'https://api.osc-fr1.scalingo.com/v1/apps'
    basic_auth '', ENV.fetch('SCALINGO_EXCHANGE_TOKEN')

    format :json

    DEFAULT_PAGINATION_ARGS = {
      page: 1,
      per_page: 50
    }.freeze

    attr_reader :app

    class << self
      def mapped_resource(resource_name, paginable: true)
        options = {}

        options.merge!(query: { **DEFAULT_PAGINATION_ARGS }) if paginable

        define_method(resource_name) do |**opts|
          plural = "#{resource_name}s"

          self
            .class
            .get("/#{app}/#{plural}/", options.merge(opts))[plural]
            .map { |entry| self.class.mapper_for(resource_name).new(entry) }
        end

        def mapper_for(resource_name)
          const_get "::ScalingoApi::Mappers::#{resource_name.capitalize}"
        end
      end
    end

    mapped_resource :deployment

    def initialize(app)
      @app = app

      super()
    end
  end
end

api = ScalingoApi::API.new('betagouv-site')

api.deployment

debugger
