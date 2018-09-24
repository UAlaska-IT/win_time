# Tests

Integration tests are provided in either the test/integration directory.
For application cookbooks, unit test are provided in either the spec/unit or test/unit directory.

# Running tests

## Integration

Integration tests are run in test Kitchen.

`kitchen test`

## Unit

Unit tests use rspec.

`chef exec rspec`

# Requirements

## Dependencies

For running tests in Test Kitchen a few dependencies must be installed.

* Install [ChefDK](https://downloads.chef.io/chef-dk)
* Install [Vagrant](https://www.vagrantup.com/downloads.html)
* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Install the Vagrant WinRM plugin if the cookbook supports Windows: `vagrant plugin install vagrant-winrm`
* Install the cookbook dependency tree with `berks install`

## Platforms and storage

Integration tests run on multiple platforms.
Many vagrant boxes may be added the first time the tests are run.
For cross-platform cookbooks this may entail 90 GB of downloads.

Some platforms are commented out .kitchen.yml.
These platforms were tested and found to not work.
See .kitchen.yml for notes on failures.

## Secrets

Some cookbooks require secrets to be placed in the `test/integration/data_bags` directory.
Such tests typically fail with an HTTP 404 error when the appropriate data bag is not found.
