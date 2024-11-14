# frozen_string_literal: true

require 'debug'
require 'httparty'
require 'json'
require 'csv'
require 'time'

require_relative 'rubingo/resource_mapper'
require_relative 'rubingo/mappers/deployment'

module Rubingo
  # a simple wrapper around the Scalingo API
  class API
    include HTTParty

    base_uri 'https://api.osc-fr1.scalingo.com/v1/apps'
    basic_auth '', ENV.fetch('SCALINGO_EXCHANGE_TOKEN')

    format :json

    extend Rubingo::ResourceMapper

    attr_reader :app

    mapped_resource :deployments

    def initialize(app)
      @app = app

      super()
    end
  end
end
