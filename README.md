# Windows Time Cookbook

__Maintainer: OIT Systems Engineering__ (<ua-oit-se@alaska.edu>)

## Purpose

The custom resources in this cookbook implement the _mechanism_ for configuring the system time in Windows.  For an example of a _policy_ for how to configure time, see the se-win-baseline cookbook.

## Requirements

### Chef

This cookbook requires Chef 13+

### Platforms

Supported Platform Families:

* Windows

Platforms validated via Test Kitchen:

* Windows Server 2016
* Windows Server 2012
* Windows Server 2008R2
* Windows 10

Notes:

* This is a low-level cookbook with precondition that Powershell 5.0 is installed
  * Custom resources will not work with previous versions of Powershell
  * Windows 2008 and 2012 require WMF update to install Powershell 5.0
  * Powershell is not installed by this cookbook

## Resources

This cookbook provides two resources for managing system time in Windows.  See [Set-TimeZone](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Management/Set-TimeZone?view=powershell-5.1) for details on configuring time zone in Windows.

### time_client

A time_client provides a single action to configure the time server for NTP/Win32tm.

__Actions__

One action is provided.

* `set_server_name` - Post condition is that the named server is used for time queries.

__Attributes__

This resource has a two attributes.

* `name` - The `name_property` of the resource.  Must be unique but otherwise ignored.
* `server_url` - The URL of a time server, e.g. `ntp.alaska.edu`.

### time_zone

A time_zone provides a single action to set the time zone for the system clock.

__Actions__

One action is provided.

* `set_zone` - Post condition is that the named time zone is set on the system.

__Attributes__

This resource has a two attributes.

* `name` - The `name_property` of the resource.  Must be unique but otherwise ignored.
* `zone_name` - The name of the time zone to be configured.  Must be a valid PowerShell time zone, e.g. `Alaskan Standard Time`.

## Recipes

### win_time::default

This recipe configures possibly both time client behavior and timezone.

__Attributes__

Several attributes are provided for time.

Time zone attributes:

* `node['win_time']['set_time_zone']` - Defaults to `true`.  Determines if time zone is set.
* `node['win_time']['time_zone']` - Defaults to `Alaskan Standard Time`. Valid options are Windows PowerShell time zones.

Time server attributes:

* `node['win_time']['set_time_server']` - Defaults to `true`. Determines if NTP/Win32tm servers are configured.
* `node['win_time']['time_server_url']` - Defaults to `ntp.alaska.edu`.  The URL of the time server to use for NTP/Win32tm queries.

## Examples

Custom resources can be used as below.

```ruby
time_client 'UA Time Server' do
  server_url 'ntp.alaska.edu'
end

time_zone 'Alaska Zone' do
  zone_name 'Alaskan Standard Time'
end
```

## Development

See CONTRIBUTING.md and TESTING.md.
