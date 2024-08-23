#!/usr/bin/env rspec

require "spec_helper"
require File.join(File.dirname(__FILE__), "../../", "validator", "package_name.rb")

module MCollective
  module Validator
    describe Package_nameValidator do
      describe "#validate" do
        it "should validate a valid package name without errors" do
          lambda {
            described_class.validate("rspec")
          }.should_not raise_error

          lambda {
            described_class.validate("rspec1")
          }.should_not raise_error

          lambda {
            described_class.validate("rspec-package")
          }.should_not raise_error

          lambda {
            described_class.validate("rspec-package-1")
          }.should_not raise_error

          lambda {
            described_class.validate("rspec.package")
          }.should_not raise_error
        end
        it "should fail on a invalid package name" do
          lambda {
            described_class.validate("rspec!")
          }.should raise_error(RuntimeError, "rspec! is not a valid package name")
        end
      end
    end
  end
end
