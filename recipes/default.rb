# frozen_string_literal: true

tcb = 'win_time'

include_recipe 'chef_run_recorder::default'

if node[tcb]['set_time_server'] && !node[tcb]['time_server_url'].nil?
  time_client 'UA Time Server' do
    server_url node[tcb]['time_server_url']
  end
end

if node[tcb]['configure_time_zone']
  time_zone 'Alaska Zone' do
    zone_name node[tcb]['time_zone']
  end
end
