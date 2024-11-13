# frozen_string_literal: true

require 'debug'
require 'httparty'
require 'json'
require 'csv'
require 'time'

require_relative 'resource_mapper'
require_relative 'mappers/deployment'

module ScalingoApi
  # a simple wrapper around the Scalingo API
  class API
    include HTTParty

    base_uri 'https://api.osc-fr1.scalingo.com/v1/apps'
    basic_auth '', ENV.fetch('SCALINGO_EXCHANGE_TOKEN')

    format :json

    extend ScalingoApi::ResourceMapper

    attr_reader :app

    mapped_resource :deployments

    def initialize(app)
      @app = app

      super()
    end
  end
end
