# frozen_string_literal: true

tcb = 'win_time'

# Attribute to determine timezone
default[tcb]['set_time_zone'] = true
default[tcb]['time_zone'] = 'Alaskan Standard Time'

# Attribute to determine if time servers should be set
default[tcb]['set_time_server'] = true
default[tcb]['time_server_url'] = nil
