# danger-xcodebuild

[![Gem Version](https://badge.fury.io/rb/danger-xcodebuild.svg)](https://badge.fury.io/rb/danger-xcodebuild) [![Build Status](https://travis-ci.org/valeriomazzeo/danger-xcodebuild.svg?branch=master)](https://travis-ci.org/valeriomazzeo/danger-xcodebuild)

Exposes warnings, errors and test results. It requires a JSON generated using [xcpretty-json-formatter](https://github.com/marcelofabri/xcpretty-json-formatter), to be passed as an argument for it to work.

## Installation

    $ gem install danger-xcodebuild

## Usage

    xcodebuild.json_file = "./fastlane/reports/xcpretty-json-formatter-results.json"

    xcodebuild.parse_warnings # returns number of warnings
    xcodebuild.parse_errors # returns number of errors
    xcodebuild.parse_tests # returns number of test failures
    xcodebuild.perfect_build # returns a bool indicating if the build was perfect

Messages are posted by default. You can stop them like this:

    xcodebuild.post_messages = false

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
