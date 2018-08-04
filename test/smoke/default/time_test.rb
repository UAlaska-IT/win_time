# frozen_string_literal: true

# Validate time server is reachable
describe host('ntp.alaska.edu') do
  it { should be_resolvable }
  it { should be_reachable }
end

# Validate time server url
describe powershell('w32tm /query /source') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  its(:stdout) { should match Regexp.new('ntp.alaska.edu') }
end

# Validate time zone name
describe powershell('Get-TimeZone | select Id') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  its(:stdout) { should match Regexp.new('Alaskan Standard Time') }
end
