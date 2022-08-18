module MCollective
  module Util
    module Package
      class PuppetPackage < Base
        def install
          if !absent? && no_version_requested?
            {:status => status, :msg => "Package is already installed"}
          else
            {:output => call_action(:install), :status => status}
          end
        end

        def update
          if absent?
            {:status => status, :msg => "Package is not present on the system"}
          else
            {:output => call_action(:update), :status => status}
          end
        end

        def uninstall
          if absent?
            {:status => status, :msg => "Package is not present on the system"}
          else
            {:output => call_action(:uninstall), :status => status}
          end
        end

        def purge
          if purged?
            {:status => status, :msg => "Package is not present on the system"}
          else
            {:output => call_action(:purge), :status => status}
          end
        end

        # Status returns a hash of package properties
        def status
          provider.properties
        end

        private

        # Creates a Puppet package provider
        def provider
          require "puppet"
          @provider ||= Puppet::Type.type(:package).new({:name => @package}.merge(@options)).provider

          if @provider.class.to_s == "Puppet::Type::Package::ProviderWindows"
            # the windows provider cannot uninstall unless you got the object
            # via instances, as uninstall is implemented in terms of
            # provider.package
            instances = @provider.class.instances
            instance = instances.find { |pkg| pkg.name == @package }
            @provider.package = instance.package if instance
          end
          @provider
        end

        # Check whether the package is absent or present
        def absent?
          [:absent, :purged].include?(provider.properties[:ensure])
        end

        def purged?
          provider.properties[:ensure] == :purged
        end

        # Check whether the package was requested to be installed with a specific version
        def no_version_requested?
          @options[:ensure].nil?
        end

        # Calls and cleans up the Puppet provider
        def call_action(action)
          output = provider.send(action)
          provider.flush
          output
        end
      end
    end
  end
end
