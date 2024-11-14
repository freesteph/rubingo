# frozen_string_literal: true

require 'debug'
require 'httparty'
require 'json'
require 'csv'
require 'time'

require 'dotenv/load'

require_relative 'rubingo/resource_mapper'
require_relative 'rubingo/mappers/deployment'

module Rubingo
  # a simple wrapper around the Scalingo API
  class API
    include HTTParty

    API_URL = 'https://api.osc-fr1.scalingo.com/v1/apps'
    SECNUM_API_URL = 'https://api.osc-secnum-fr1.scalingo.com/v1/apps'

    basic_auth '', ENV.fetch('SCALINGO_EXCHANGE_TOKEN')

    format :json

    extend Rubingo::ResourceMapper

    attr_reader :app

    mapped_resource :deployments
    mapped_resource :collaborators

    def initialize(application:, secnum:)
      @app = application

      api_url = secnum ? SECNUM_API_URL : API_URL

      self.class.base_uri(api_url)

      super()
    end
  end
end
