# frozen_string_literal: true

require_relative '../../rubingo'

require_relative './arguments/application'

module Rubingo
  module Commands
    class DeploymentsAverage < Dry::CLI::Command
      desc 'Write a CSV of the average deployments build time, per date'

      include Rubingo::Commands::Arguments::Application

      option :page_count, optional: true, default: 10, desc: 'the number of pages to grab'

      def call(**options)
        api = Rubingo::API.new(**options.slice(:application, :secnum))

        data = get_last_successful_deployments(api: api, page_count: options[:page_count])
               .group_by { |deploy| deploy.finished_at.to_date.to_s } # group on YYYY-MM-DD format
               .transform_values { |deploys| deploys.map(&:duration).sum.to_i / deploys.length }

        write_csv_file(options[:application], data)
      end

      private

      def get_last_successful_deployments(api:, page_count:)
        Array
          .new(page_count) { |index| api.deployments(page: index + 1) }
          .flatten
          .reverse # chronological order
          .filter(&:success?)
      end

      def write_csv_file(app, data)
        csv = CSV.generate_lines(
          data,
          write_headers: true,
          headers: ['date', 'average build time']
        )

        destination = "average_build_time_#{app}.csv"

        File.write(destination, csv)

        puts "CSV file written at #{destination}"
      end
    end
  end
end
