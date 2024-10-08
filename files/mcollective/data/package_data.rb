module MCollective
  module Data
    class Package_data < Base
      activate_when {PluginManager["package_agent"]}

      query do |package|
        val = {}
        Agent::Package.do_pkg_action(package, :status, val)
        result[:status] = val[:ensure] if val[:ensure]
        # If the package is either 'absent' or 'purged' report it as not installed
        result[:installed] = !["absent", "purged"].include?(val[:ensure])
      rescue => e
        Log.warn("Could not get status for package #{package}: #{e}")
      end
    end
  end
end
