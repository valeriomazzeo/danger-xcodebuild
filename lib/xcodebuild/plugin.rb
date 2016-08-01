module Danger
  # Exposes warnings, errors and test results.
  # It requires a JSON generated using [xcpretty-json-formatter](https://github.com/marcelofabri/xcpretty-json-formatter),
  # to be passed as an argument for it to work.
  #
  # @example Ensure the project compiles without warnings, errors and all tests are executed correctly
  #
  #          xcodebuild.parse_warnings
  #          xcodebuild.parse_errors
  #          xcodebuild.parse_tests
  #
  # @see  valeriomazzeo/danger-xcodebuild
  # @tags xcode, xcodebuild, errors, warnings, tests, xcpretty-json-formatter
  #
  class DangerXcodebuild < Plugin

    # Allows you to specify an xcodebuild JSON file location to parse.
    attr_accessor :xcodebuild_json

    def initialize
        @warning_count = 0
        @error_count = 0
        @test_failures_count = 0
    end

    # Parses and exposes eventual warnings.
    # @return   [warning_count]
    #
    def parse_warnings

    end

    # Parses and expose eventual errors.
    # @return   [error_count]
    #
    def parse_errors

    end

    # Parses and exposes eventual test failures.
    # @return   [test_failures]
    #
    def parse_tests

    end

    # Prints "Perfect build 👍🏻" if everything is ok after parsing.
    # @return   [is_perfect_build]
    #
    def perfect_build
      is_perfect_build = @warning_count == 0 && @errors.count == 0 && @test_failures.count == 0
      message("Perfect build 👍🏻") if is_perfect_build
      return is_perfect_build
      end
    end

    def self.instance_name
          to_s.gsub("Danger", "").danger_underscore.split("/").last
    end
  end
end
