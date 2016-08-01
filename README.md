# danger-xcodebuild

Exposes warnings, errors and test results. It requires a JSON generated using [xcpretty-json-formatter](https://github.com/marcelofabri/xcpretty-json-formatter), to be passed as an argument for it to work.

## Installation

    $ gem install danger-xcodebuild

## Usage

    xcodebuild.parse_warnings
    xcodebuild.parse_errors
    xcodebuild.parse_tests
    xcodebuild.perfect_build

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
