# frozen_string_literal: true

# A time_client provides a single action to configure the time server
resource_name :time_client
provides :time_client, os: 'windows'

default_action :set_server_name

property :server_url, String, required: true

action :set_server_name do
  set_server_name_helper(@new_resource)
end

action_class.class_eval do
  include ::WinTime::Helper

  def set_server_name_helper(new_resource)
    ensure_time_server_name(new_resource)
  end
end
