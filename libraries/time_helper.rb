# frozen_string_literal: true

# This module implements helpers that are used for Time resources
module WinTime
  include Chef::Mixin::PowershellOut
  # This module implements helpers that are used for Time resources
  module Helper
    def empty_string?(string)
      return string.nil? || string.empty? || string == ''
    end

    def line_matches_or_empty?(line, regex)
      return true if empty_string?(line) # Happens on the edges
      return true if line.match?(/^-/) # Horizontal rule for header
      return true if line.match?(regex) # Header or footer
      return false
    end

    def log_powershell_out(script_name, script_code)
      Chef::Log.debug("Running #{script_name} script: '#{script_code}'")
      cmd = powershell_out(script_code)
      raise "Command returned #{cmd.exitstatus}" unless cmd.exitstatus.zero?
      raise "Command returned #{cmd.stderr}" unless cmd.stderr == ''
      Chef::Log.debug("Returned from #{script_name} script: '#{cmd.stdout}'")
      return cmd
    end

    def parse_time_zone_line(line, retval)
      Chef::Log.debug("Line: '#{line}'")
      line = line.strip
      Chef::Log.debug("Stripped line: '#{line}'")
      retval.push(line) unless line_matches_or_empty?(line, /^Id/) # The header
    end

    def parse_time_zone_lines(cmd)
      retval = []
      count = 0
      cmd.stdout.to_s.lines.each do |line|
        count += 1
        parse_time_zone_line(line, retval)
      end
      Chef::Log.debug("Processed #{count} lines, found #{retval.size} timezones")
      return retval
    end

    def parse_time_zone
      script_code = 'Get-TimeZone | select Id'
      cmd = log_powershell_out('parse', script_code)

      time_zones = parse_time_zone_lines(cmd)

      raise 'Failed to parse timezone' if time_zones.size != 1
      return time_zones.first
    end

    def set_time_zone(zone_name)
      script_code = "Set-TimeZone -Name '#{zone_name}'"
      cmd = log_powershell_out('time zone', script_code)
      raise 'Failed to set time zone' unless empty_string?(cmd.stdout.to_s.strip)
    end

    def ensure_time_server_name(time_server) # rubocop:disable Metrics/MethodLength # Not much can be done here
      powershell_script "set time server #{time_server.server_url}" do
        code <<-SCRIPT
          Set-Service w32time -startuptype "manual"
          w32tm /config /manualpeerlist:'#{time_server.server_url}' /syncfromflags:MANUAL /update
          Stop-Service w32time
          Start-Service w32time
        SCRIPT
        # Query from registry:
        # (Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Name 'NtpServer')
        # .NtpServer
        not_if <<-SCRIPT
          $current_server_raw = w32tm /query /source
          $current_server = ($current_server_raw.Split(' ') -replace ',0x.*') | ? {$_.trim() -ne "" }
          $dif = Compare-Object ($current_server) ('#{time_server.server_url}') | Measure
          $dif.count -eq 0
        SCRIPT
      end
    end

    def ensure_time_zone(time_zone)
      curr_zone = parse_time_zone
      Chef::Log.debug("Current Time Zone: #{curr_zone}")

      return if curr_zone == time_zone.zone_name

      converge_by "Set Time Zone #{time_zone.zone_name}" do
        set_time_zone(time_zone.zone_name)
      end
    end
  end
end

Chef::Recipe.include(WinTime::Helper)
Chef::Resource.include(WinTime::Helper)
