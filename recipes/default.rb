# frozen_string_literal: true

tcb = 'win_time'

if node[tcb]['set_time_server']
  time_client 'UA Time Server' do
    server_url node[tcb]['time_server_url']
  end
end

if node[tcb]['set_time_zone']
  time_zone 'Alaska Zone' do
    zone_name node[tcb]['time_zone']
  end
end
