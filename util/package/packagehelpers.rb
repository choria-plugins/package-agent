require "digest"

module MCollective
  module Util
    module Package
      class PackageHelpers
        def self.count
          manager = packagemanager
          case manager
          when :yum
            rpm_count
          when :apt
            dpkg_count
          when :pkg
            pkg_count
          else
            raise "Cannot find a compatible package system to count packages"
          end
        end

        def self.rpm_count(output="")
          raise "Cannot find rpm at /bin/rpm" unless File.exist?("/bin/rpm")

          result = {:exitcode => nil,
                    :output => ""}
          cmd = Shell.new("/bin/rpm -qa", :stdout => output)
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus
          result[:output] = output.split("\n").reject { |line| line == "" }.size.to_s

          raise "rpm command failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          result
        end

        def self.dpkg_count(output="")
          raise "Cannot find dpkg at /usr/bin/dpkg" unless File.exist?("/usr/bin/dpkg")

          result = {:exitcode => nil,
                    :output => ""}
          cmd = Shell.new("/usr/bin/dpkg --list", :stdout => output)
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus
          result[:output] = output.split("\n").count { |line| line[0..1] == "ii"}.to_s

          raise "dpkg command failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          result
        end

        def self.pkg_count(output="")
          raise "Cannot find pkg at /usr/sbin/pkg" unless File.exist?("/usr/sbin/pkg")

          result = {:exitcode => nil,
                    :output => ""}
          cmd = Shell.new("/usr/sbin/pkg query '%n'", :stdout => output)
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus
          result[:output] = output.chomp.split("\n").size.to_s

          raise "pkg command failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          result
        end

        def self.md5
          manager = packagemanager
          case manager
          when :yum
            rpm_md5
          when :apt
            dpkg_md5
          when :pkg
            pkg_md5
          else
            raise "Cannot find a compatible package system to get a md5 of the package list"
          end
        end

        def self.rpm_md5(output="")
          raise "Cannot find rpm at /bin/rpm" unless File.exist?("/bin/rpm")

          result = {:exitcode => nil,
                    :output => ""}
          cmd = Shell.new("/bin/rpm -qa", :stdout => output)
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus
          result[:output] = Digest::MD5.new.hexdigest(output)

          raise "rpm command failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          result
        end

        def self.dpkg_md5(output="")
          raise "Cannot find dpkg at /usr/bin/dpkg" unless File.exist?("/usr/bin/dpkg")

          result = {:exitcode => nil,
                    :output => ""}
          cmd = Shell.new("/usr/bin/dpkg --list", :stdout => output)
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus
          result[:output] = Digest::MD5.new.hexdigest(output.split("\n").select { |line| line[0..1] == "ii"}.join("\n"))

          raise "dpkg command failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          result
        end

        def self.pkg_md5(output="")
          raise "Cannot find pkg at /usr/sbin/pkg" unless File.exist?("/usr/sbin/pkg")

          result = {:exitcode => nil,
                    :output => ""}
          cmd = Shell.new("/usr/sbin/pkg query '%n'", :stdout => output)
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus
          result[:output] = Digest::MD5.new.hexdigest(output.chomp)

          raise "pkg command failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          result
        end

        def self.yum_clean(clean_mode)
          raise "Cannot find yum at /usr/bin/yum" unless File.exist?("/usr/bin/yum")

          result = {:exitcode => nil,
                    :output => ""}

          if ["all", "headers", "packages", "metadata", "dbcache", "plugins", "expire-cache"].include?(clean_mode)
            cmd = Shell.new("/usr/bin/yum clean #{clean_mode}", :stdout => result[:output])
            cmd.runcommand
            result[:exitcode] = cmd.status.exitstatus
          else
            raise "Unsupported yum clean mode: %s" % clean_mode
          end

          raise "Yum clean failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          result
        end

        def self.apt_update
          raise "Cannot find apt-get at /usr/bin/apt-get" unless File.exist?("/usr/bin/apt-get")

          result = {:exitcode => nil,
                    :output => ""}

          cmd = Shell.new("/usr/bin/apt-get update", :stdout => result[:output])
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus

          raise "apt-get update failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          # Everything was fine.  Discard the current result and return the
          # actual status of the system.
          apt_checkupdates
        end

        def self.pkg_update
          raise "Cannot find pkg at /usr/sbin/pkg" unless File.exist?("/usr/sbin/pkg")

          result = {:exitcode => nil,
                    :output => ""}

          cmd = Shell.new("/usr/sbin/pkg update", :stdout => result[:output])
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus

          raise "pkg update failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          result
        end

        def self.yum_update
          raise "Cannot find yum at /usr/bin/yum" unless File.exist?("/usr/bin/yum")

          yum_clean("metadata")
          yum_checkupdates
        end

        def self.zypper_update
          raise "Cannot find zypper at /usr/bin/zypper" unless File.exist?("/usr/bin/zypper")

          result = {:exitcode => nil,
                    :output => ""}

          cmd = Shell.new("/usr/bin/zypper refresh", :stdout => result[:output])
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus

          raise "zypper refresh failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          result
        end

        def self.packagemanager
          if File.exist?("/usr/bin/yum")
            :yum
          elsif File.exist?("/usr/bin/apt-get")
            :apt
          elsif File.exist?("/usr/bin/zypper")
            :zypper
          elsif File.exist?("/usr/sbin/pkg")
            :pkg
          end
        end

        def self.checkupdates
          manager = packagemanager
          case manager
          when :yum
            yum_checkupdates
          when :apt
            apt_checkupdates
          when :zypper
            zypper_checkupdates
          when :pkg
            pkg_checkupdates
          else
            raise "Cannot find a compatible package system to check updates"
          end
        end

        def self.yum_checkupdates(output="")
          raise "Cannot find yum at /usr/bin/yum" unless File.exist?("/usr/bin/yum")

          result = {:exitcode => nil,
                    :output => output,
                    :outdated_packages => [],
                    :package_manager => "yum"}

          cmd = Shell.new("/usr/bin/yum -q check-update", :stdout => result[:output])
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus

          result[:output].strip.each_line do |line|
            break if /^Obsoleting\sPackages/i.match?(line)

            pkg, ver, repo = line.split
            next unless pkg && ver && repo

            result[:outdated_packages] << {:package => pkg.strip,
                                           :version => ver.strip,
                                           :repo => repo.strip}
          end

          result
        end

        def self.zypper_checkupdates(output="")
          raise "Cannot find zypper at /usr/bin/zypper" unless File.exist?("/usr/bin/zypper")

          result = {:exitcode => nil,
                    :output => output,
                    :outdated_packages => [],
                    :package_manager => "zypper"}

          cmd = Shell.new("/usr/bin/zypper -q list-updates", :stdout => result[:output])
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus

          result[:output].each_line do |line|
            next if /^S\s/.match?(line)
            next if /^--/.match?(line)

            sup, repo, name, cur_ver, new_ver, arch = line.split("|")
            next unless repo && name && new_ver

            result[:outdated_packages] << {:package => name.strip,
                                           :version => new_ver.strip,
                                           :repo => repo.strip}
          end

          result
        end

        def self.apt_checkupdates(output="")
          raise "Cannot find apt-get at /usr/bin/apt-get" unless File.exist?("/usr/bin/apt-get")

          result = {:exitcode => nil,
                    :output => output,
                    :outdated_packages => [],
                    :package_manager => "apt"}

          cmd = Shell.new("/usr/bin/apt-get --simulate dist-upgrade", :stdout => result[:output])
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus

          raise "Apt check-update failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          result[:output].each_line do |line|
            next unless /^Inst/.match?(line)

            # Inst emacs23 [23.1+1-4ubuntu7] (23.1+1-4ubuntu7.1 Ubuntu:10.04/lucid-updates) []
            next unless line =~ /Inst (.+?) \[.+?\] \((.+?)\s(.+?)\)/

            result[:outdated_packages] << {:package => $1.strip,
                                           :version => $2.strip,
                                           :repo => $3.strip}
          end

          result
        end

        def self.pkg_checkupdates(query_output="", rquery_output="")
          raise "Cannot find pkg at /usr/sbin/pkg" unless File.exist?("/usr/sbin/pkg")

          result = {:exitcode => nil,
                    :output => "",
                    :outdated_packages => [],
                    :package_manager => "pkg"}

          cmd = Shell.new('/usr/sbin/pkg query --all "%n\\t%v\\t%R"', :stdout => query_output)
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus
          raise "pkg query failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          installed_packages = {}
          query_output.chomp.split("\n").each do |line|
            name, version, repository = line.split("\t")
            installed_packages[name] = {:version => version, :repository => repository}
          end

          cmd = Shell.new('/usr/sbin/pkg rquery --all --no-repo-update "%n\\t%v\\t%R"', :stdout => rquery_output)
          cmd.runcommand
          result[:exitcode] = cmd.status.exitstatus
          raise "pkg rquery failed, exit code was #{result[:exitcode]}" unless result[:exitcode] == 0

          available_packages = {}
          rquery_output.chomp.split("\n").each do |line|
            name, version, repository = line.split("\t")
            available_packages[name] = {:version => version, :repository => repository}
          end

          installed_packages.each do |name, info|
            next unless available_packages[name] && available_packages[name] != info

            result[:outdated_packages] << {:package => name,
                                           :version => available_packages[name][:version],
                                           :repo => available_packages[name][:repository]}
          end

          # Mimic the output from pkg version
          result[:output] = result[:outdated_packages].map do |package|
            installed = "%s-%s" % [package[:package], installed_packages[package[:package]][:version]]
            "%-34s <   needs updating (remote has %s)\n" % [installed, package[:version]]
          end.join

          result
        end

        def self.refresh
          manager = packagemanager
          case manager
          when :apt
            apt_update
          when :pkg
            pkg_update
          when :yum
            yum_update
          when :zypper
            zypper_update
          else
            raise "Cannot find a compatible package system to update packages"
          end
        end
      end
    end
  end
end
