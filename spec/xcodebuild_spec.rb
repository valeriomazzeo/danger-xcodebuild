require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerXcodebuild do
    it 'should be a plugin' do
      expect(Danger::DangerXcodebuild.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @xcodebuild = @dangerfile.xcodebuild
      end

      it "is a perfect build" do
        expect(@xcodebuild.perfect_build).to be true
        expect(@dangerfile.status_report[:messages].first).to eq("Perfect build 👍🏻")
        expect(@dangerfile.status_report[:errors]).to be_empty
        expect(@dangerfile.status_report[:warnings]).to be_empty
        expect(@dangerfile.status_report[:markdowns]).to be_empty
      end

      it "has to add build_title as prefix" do
        @xcodebuild.build_title = "Title"
        @xcodebuild.perfect_build

        expect(@dangerfile.status_report[:messages].first).to eq("Title Perfect build 👍🏻")
      end

      describe 'with warnings' do

        before do
          data = {
            :warnings => ['warning1', 'warning2'],
            :ld_warnings => ['ld_warnings'],
            :compile_warnings => ['compile_warnings']
          }.to_json

          filename = 'xcodebuild_warnings.json'
          allow(File).to receive(:open).with(filename, 'r').and_return(StringIO.new(data))

          @xcodebuild.json_file = filename
        end

        it "has to report warnings" do
          expect(@xcodebuild.parse_warnings).to eq(4)
          expect(@xcodebuild.perfect_build).to be false
          expect(@dangerfile.status_report[:warnings].first).to eq("Please fix **4** warnings 😒")
          expect(@dangerfile.status_report[:errors]).to be_empty
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

        it "has to add build_title as prefix" do
          @xcodebuild.build_title = "Title"
          @xcodebuild.parse_warnings
          expect(@dangerfile.status_report[:warnings].first).to eq("Title Please fix **4** warnings 😒")
        end

      end

      describe 'with errors' do

        before do
          data = {
            :errors => ['error1', 'error2'],
            :compile_errors => [
              { :file_path => '/tmp/file1.m', :reason => 'reason1' },
              { :file_path => '/tmp/file2.m', :reason => 'reason2' }
            ],
            :file_missing_errors => [
              { :file_path => '/tmp/missing_file1.m', :reason => 'reason1' },
              { :file_path => '/tmp/missing_file2.m', :reason => 'reason2' }
            ],
            :undefined_symbols_errors => [{ :message => 'undefined_symbols' }],
            :duplicate_symbols_errors => [{ :message => 'duplicate_symbols' }]
          }.to_json

          filename = 'xcodebuild_errors.json'
          allow(File).to receive(:open).with(filename, 'r').and_return(StringIO.new(data))

          @xcodebuild.json_file = filename
        end

        it "has to report errors" do
          expect(@xcodebuild.parse_errors).to eq(8)
          expect(@xcodebuild.perfect_build).to be false
          expect(@dangerfile.status_report[:errors].count).to eq(8+1)
          expect(@dangerfile.status_report[:errors].first).to eq("Build failed with **8** errors 🚨")
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

        it "has to add build_title as prefix" do
          @xcodebuild.build_title = "Title"
          @xcodebuild.parse_errors
          expect(@dangerfile.status_report[:errors].first).to eq("Title Build failed with **8** errors 🚨")
        end

      end

      describe 'with tests failures' do

        before do
          data = {
            :tests_failures => {
              :suite1 => [{ :file_path => '/tmp/file1.m', :test_case => "testCase1", :reason => 'reason1' }],
              :suite2 => [{ :file_path => '/tmp/file2.m', :test_case => "testCase2", :reason => 'reason2' }]
            }
          }.to_json

          filename = 'xcodebuild_tests.json'
          allow(File).to receive(:open).with(filename, 'r').and_return(StringIO.new(data))

          @xcodebuild.json_file = filename
        end

        it "has to report tests failures" do
          expect(@xcodebuild.parse_tests).to eq(2)
          expect(@xcodebuild.perfect_build).to be false
          expect(@dangerfile.status_report[:errors].count).to eq(2+1)
          expect(@dangerfile.status_report[:errors].first).to eq("Test execution failed with **2** errors 🚨")
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

        it "has to add build_title as prefix" do
          @xcodebuild.build_title = "Title"
          @xcodebuild.parse_tests
          expect(@dangerfile.status_report[:errors].first).to eq("Title Test execution failed with **2** errors 🚨")
        end

      end

    end
  end
end
