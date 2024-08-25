#!/usr/bin/env rspec

require "spec_helper"
require File.join(File.dirname(__FILE__), "../../../", "files", "mcollective", "util", "package", "base.rb")

module MCollective
  module Util
    module Package
      describe Base do
        let(:base) { described_class.new("rspec", {:rkey => "rvalue"}) }

        describe "#initialize" do
          it "sets the package name and the options hash" do
            base.package.should eq "rspec"
            base.options.should eq({:rkey => "rvalue"})
          end
        end

        describe "install" do
          it "should raise an error if called" do
            lambda {
              base.install
            }.should raise_error "error. MCollective::Util::Package::Base does not implement #install"
          end
        end

        describe "uninstall" do
          it "should raise an error if called" do
            lambda {
              base.uninstall
            }.should raise_error "error. MCollective::Util::Package::Base does not implement #uninstall"
          end
        end

        describe "purge" do
          it "should raise an error if called" do
            lambda {
              base.purge
            }.should raise_error "error. MCollective::Util::Package::Base does not implement #purge"
          end
        end

        describe "update" do
          it "should raise an error if called" do
            lambda {
              base.update
            }.should raise_error "error. MCollective::Util::Package::Base does not implement #update"
          end
        end

        describe "status" do
          it "should raise an error if called" do
            lambda {
              base.status
            }.should raise_error "error. MCollective::Util::Package::Base does not implement #status"
          end
        end

        describe "search" do
          it "should raise an error if called" do
            lambda {
              base.search
            }.should raise_error "error. MCollective::Util::Package::Base does not implement #search"
          end
        end
      end
    end
  end
end
