# frozen_string_literal: true

tcb = 'win_time'

# Validate time server is reachable
describe host(json('C:/chef/cache/chef_node.json').params['default'][tcb]['time_server_url']) do
  let(:node) { json('C:/chef/cache/chef_node.json').params }
  before do
    skip unless node['default'][tcb]['set_time_server']
  end

  it { should be_resolvable }
  it { should be_reachable }
end

# Validate time server url
describe powershell('w32tm /query /source') do
  let(:node) { json('C:/chef/cache/chef_node.json').params }
  before do
    skip unless node['default'][tcb]['set_time_server']
  end

  its('exit_status') { should eq 0 }
  its('stderr') { should eq '' }
  its('stdout') { should match Regexp.new(node['default'][tcb]['time_server_url']) }
end

# Validate time zone name
describe powershell('Get-TimeZone | select Id') do
  let(:node) { json('C:/chef/cache/chef_node.json').params }
  before do
    skip unless node['default'][tcb]['set_time_zone']
  end

  its('exit_status') { should eq 0 }
  its('stderr') { should eq '' }
  its('stdout') { should match Regexp.new(node['default'][tcb]['time_zone']) }
end
