# frozen_string_literal: true

if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method(:time_client)

  def set_server_name_time_client(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:time_client, :set_server_name, resource)
  end

  ChefSpec::Runner.define_runner_method(:time_zone)

  def set_zone_time_zone(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:time_zone, :set_zone, resource)
  end
end
