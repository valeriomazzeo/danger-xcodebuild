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
        expect(@dangerfile.status_report[:messages]).to eq(["Perfect build 👍🏻"])
      end

    end
  end
end
