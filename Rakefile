specdir = File.join([File.dirname(__FILE__), "spec"])

require "rake"
begin
  require "rspec/core/rake_task"
  require "mcollective"
rescue LoadError
end

desc "Run agent and application tests"
task :test do
  require "#{specdir}/spec_helper.rb"
  if ENV["TARGETDIR"]
    test_pattern = "#{File.expand_path(ENV["TARGETDIR"])}/spec/**/*_spec.rb"
  else
    test_pattern = "spec/**/*_spec.rb"
  end
  sh "rspec #{Dir.glob(test_pattern).sort.join(" ")}"
end

task :default => :test

desc "Set versions for a release"
task :prep_version do
  abort("Please specify VERSION") unless ENV["VERSION"]

  Rake::FileList["**/*.ddl"].each do |file|
    sh 'sed -i"" -re \'s/(\s+:version\s+=>\s+").+/\1%s",/\' %s' % [ENV["VERSION"], file]
  end
end

desc "Builds the release package"
task :build do
  if ENV["VERSION"]
    Rake::Task[:test].execute
    Rake::Task[:prep_version].execute
  end

  cp "README.md", "puppet"
  cp "CHANGELOG.md", "puppet"

  sh "/opt/puppetlabs/puppet/bin/mco plugin package --format aiomodulepackage --vendor choria"
end
