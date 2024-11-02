# frozen_string_literal: true

module ScalingoApi
  # ResourceMapper adds the class macro `mapped_ressource` which can
  # be used to declare and map a resource on the ScalingoAPI.
  module ResourceMapper
    DEFAULT_PAGINATION_ARGS = {
      page: 1,
      per_page: 50
    }.freeze

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
    end

    def mapper_for(resource_name)
      const_get "::ScalingoApi::Mappers::#{resource_name.capitalize}"
    end
  end
end
