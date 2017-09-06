# frozen_string_literal: true

# A time_zone provides a single action to configure time zone for a machine
resource_name :time_zone
provides :time_zone, os: 'windows'

default_action :set_zone

property :name, String, name_property: true
property :zone_name, String, required: true # Must be a valid Powershell timezone

extend ::WinTime::Helper

action :set_zone do
  set_zone_helper(@new_resource)
end

action_class.class_eval do
  include ::WinTime::Helper

  def set_zone_helper(new_resource)
    ensure_time_zone(new_resource)
  end
end
