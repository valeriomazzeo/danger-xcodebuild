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
  #          xcodebuild.perfect_build
  #
  # @see  valeriomazzeo/danger-xcodebuild
  # @tags xcode, xcodebuild, errors, warnings, tests, xcpretty-json-formatter
  #
  class DangerXcodebuild < Plugin

    def initialize(arg)
      super
      @warning_count = 0
      @error_count = 0
      @test_failures_count = 0
      @xcodebuild_json = nil
    end

    # Allows you to specify a build title to prefix all the reported messages.
    # @return   [String]
    #
    attr_accessor :build_title

    # Allows you to specify an xcodebuild JSON file location to parse.
    attr_reader :json_file

    # Allows you to specify an xcodebuild JSON file location to parse.
    # @return   [void]
    #
    def json_file=(value)
      @json_file = value
      @xcodebuild_json = JSON.parse(File.open(value, 'r').read)
    end

    # Parses and exposes eventual warnings.
    # @return   [warning_count]
    #
    def parse_warnings
      @warning_count = @xcodebuild_json["warnings"].count
      @warning_count = @warning_count + @xcodebuild_json["ld_warnings"].count
      @warning_count = @warning_count + @xcodebuild_json["compile_warnings"].count
      if @warning_count > 0
        warning_string = @warning_count == 1 ? "warning" : "warnings"
        message = Array.new
        message.push (@build_title) unless @build_title.nil?
        message.push("Please fix **#{@warning_count}** #{warning_string} 😒")
        warn(message.reject(&:empty?).join(" "))
      end
      return @warning_count
    end

    # Parses and expose eventual errors.
    # @return   [error_count]
    #
    def parse_errors
      errors = @xcodebuild_json["errors"].map {|x| "`#{x}`"}
      errors += @xcodebuild_json["compile_errors"].map {|x| "`[#{x["file_path"].split("/").last}] #{x["reason"]}`"}
      errors += @xcodebuild_json["file_missing_errors"].map {|x| "`[#{x["file_path"].split("/").last}] #{x["reason"]}`"}
      errors += @xcodebuild_json["undefined_symbols_errors"].map {|x| "`#{x["message"]}`"}
      errors += @xcodebuild_json["duplicate_symbols_errors"].map {|x| "`#{x["message"]}`"}
      if errors.count > 0
        error_string = errors.count == 1 ? "error" : "errors"
        message = Array.new
        message.push (@build_title) unless @build_title.nil?
        message.push("Build failed with **#{errors.count}** #{error_string} 🚨")
        fail(message.reject(&:empty?).join(" "))
        errors.each do |error|
          fail(error)
        end
      end
      @error_count = errors.count
      return @error_count
    end

    # Parses and exposes eventual test failures.
    # @return   [test_failures]
    #
    def parse_tests
      test_failures = Array.new
      @xcodebuild_json["tests_failures"].each do |key, value|
        test_failures += value.map {|x| "`[#{x["file_path"].split("/").last}] [#{x["test_case"]}] #{x["reason"]}`"}
      end

      if test_failures.count > 0
        test_string = test_failures.count == 1 ? "error" : "errors"
        message = Array.new
        message.push (@build_title) unless @build_title.nil?
        message.push("Test execution failed with **#{test_failures.count}** #{test_string} 🚨")
        fail(message.reject(&:empty?).join(" "))
        test_failures.each do |test_failure|
          fail(test_failure)
        end
      end
      @test_failures_count = test_failures.count
      return @test_failures_count
    end

    # Prints "Perfect build 👍🏻" if everything is ok after parsing.
    # @return   [is_perfect_build]
    #
    def perfect_build
      is_perfect_build = @warning_count == 0 && @error_count == 0 && @test_failures_count == 0
      message = Array.new
      message.push (@build_title) unless @build_title.nil?
      message.push ("Perfect build 👍🏻")
      message(message.reject(&:empty?).join(" ")) if is_perfect_build
      return is_perfect_build
    end

    def self.instance_name
          to_s.gsub("Danger", "").danger_underscore.split("/").last
    end
  end
end
