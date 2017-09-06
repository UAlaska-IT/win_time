# Windows Time Cookbook

__Maintainer: OIT Systems Engineering__ (<ua-oit-se@alaska.edu>)

## Purpose

The custom resources in this cookbook implement the _mechanism_ for configuring the system time in Windows.  For an example of a _policy_ for how to configure time, see the se-win-baseline cookbook.

## Requirements

### Chef

Version 2.0.0+ of this cookbook requires Chef 13+

### Platforms

Supported Platform Families:

* Windows

Platforms validated via Test Kitchen:

* Windows 10
* Windows Server 2016

Notes:

* Only Windows 2016 is fully tested.
* Custom resources typically use raw PowerShell scripts for converge and idempotence.  Most recipes therefore should support older versions of Windows, but these are not tested.
* Cookbook dependencies are handled via Berkshelf and are verified only to be compatible with Windows 2016/10.

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

This is a resource-only cookbook; and adding the default recipe to a node's runlist will have no effect.

## Examples

```ruby
time_client 'UA Time Server' do
  server_url 'ntp.alaska.edu'
end

time_zone 'Alaska Zone' do
  zone_name 'Alaskan Standard Time'
end
```

## Development

Development should follow [GitHub Flow](https://guides.github.com/introduction/flow/) to foster some shared responsibility.

* Fork/branch the repository
* Make changes
* Fix all Rubocop (`rubocop`) and Foodcritic (`foodcritic .`) offenses
* Write smoke tests that reasonably cover the changes (`kitchen verify`)
* Pass all smoke tests
* Submit a Pull Request using Github
* Wait for feedback and merge from a second developer

### Requirements

For running tests in Test Kitchen a few dependencies must be installed.

* [ChefDK](https://downloads.chef.io/chef-dk/)
* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Install dependency tree with `berks install`
* Install Vagrant WinRM plugin:  `vagrant plugin install vagrant-winrm`

### Windows Server 2016 Box

This cookbook was tested in Test Kitchen using the base box at

`\\fbk-tss-store1.apps.ad.alaska.edu\Department\Technology Support Services\Engineering\Packer Boxes\win2016core-virtualbox.box`

If this box has not been cached by Vagrant, it can be placed (without .box extension) in the kitchen-generated directory

`.kitchen/kitchen-vagrant/kitchen-se-win-baseline-default-win2016gui-virtualbox/.vagrant/machines/default/virtualbox`

or added to Vagrant using the shell command

`vagrant box add <name> <base_box>.box`

Windows boxes are not widely available as standard downloads, but alternative base boxes can be built, for example using [boxcutter](https://github.com/boxcutter/windows).
