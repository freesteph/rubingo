# frozen_string_literal: true

require_relative '../src/scalingo_api'

PAGE_COUNT = 10
REPOSITORY = 'betagouv-site'

api = ScalingoApi::API.new(REPOSITORY)

# get a bunch of data
data = Array
       .new(PAGE_COUNT) { |index| api.deployments(page: index + 1) }
       .flatten
       .reverse # chronological order
       .filter(&:success?) # successful builds only
       .group_by { |deploy| deploy.finished_at.to_date.to_s } # group on YYYY-MM-DD format
       .transform_values { |deploys| deploys.map(&:duration).sum.to_i / deploys.length }

csv = CSV.generate_lines(
  data,
  write_headers: true,
  headers: ['date', 'average build time']
)

File.write("average_build_time_#{REPOSITORY}.csv", csv)
