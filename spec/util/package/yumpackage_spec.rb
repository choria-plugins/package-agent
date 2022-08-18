require "spec_helper"
require File.join(File.dirname(__FILE__), "../../../", "util", "package", "base.rb")
require File.join(File.dirname(__FILE__), "../../../", "util", "package", "yumpackage.rb")

module MCollective
  module Util
    module Package
      describe YumPackage do
        let(:package) { described_class.new("rspec", {}) }

        describe "#install" do
          it "should delegate to call_action" do
            package.expects(:call_action).with(:install).returns("install output")

            package.install.should eq "install output"
          end
        end

        describe "#update" do
          it "should delegate to call_action" do
            package.expects(:call_action).with(:update).returns("update output")

            package.update.should eq "update output"
          end
        end

        describe "#uninstall" do
          it "should delegate to call_action" do
            package.expects(:call_action).with(:remove).returns("remove output")

            package.uninstall.should eq "remove output"
          end
        end

        describe "#status" do
          it "should delegate to call_action" do
            package.expects(:call_action).with(:status).returns("status output")

            package.status.should eq "status output"
          end
        end

        describe "#search" do
          it "should delegate to call_action" do
            package.expects(:call_action).with(:search).returns("search output")

            package.search.should eq "search output"
          end
        end

        describe "#call_action" do
          let(:status)  { mock("status") }
          let(:command) do
            command = mock("command")
            command.expects(:status).returns(status)
            command
          end

          it "should invoke the yumHelper.py and process the output" do
            File.stubs(:join).returns("test_yumHelper.py")
            File.expects(:exist?).with("test_yumHelper.py").returns(true)
            Shell.expects(:new).with("test_yumHelper.py --test_action rspec", :stdout => "").returns(command)

            command.expects(:runcommand)
            status.expects(:exitstatus).returns(0)

            JSON.expects(:parse).returns({"faked" => "Called action"})
            result = package.send(:call_action, "test_action")
            result.should eq({:faked => "Called action"})
          end
        end
      end
    end
  end
end
