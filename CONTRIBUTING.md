# Uniformity

This project lints code with both Rubocop and Foodcritic.
The purpose is to encourage uniformity within the project and with community standards for Ruby and Chef.
Disabling checks is discouraged, and developers should have a good reason for doing so.

# Code review

Development should follow [GitHub Flow](https://guides.github.com/introduction/flow/) to foster some shared responsibility.
Test-driven development is encouraged to ensure comprehensive coverage, but at a minimum tests should reasonably cover all changes.

* Fork/branch the repository
* Write InSpec tests (`kitchen test`)
* For application cookbooks, write ChefSpec tests (`chef exec rspec`)
* Make changes to fix all test errors
* Fix all Rubocop (`rubocop`) and Foodcritic (`foodcritic .`) offenses
* Submit a Pull Request on Github
* Wait for feedback and merge from a second developer
