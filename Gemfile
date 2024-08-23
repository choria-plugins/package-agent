#!ruby
source "https://rubygems.org"

group :test do
  gem "json"
  gem "mcollective-test"
  gem "mocha"
  gem "rake"
  gem "rspec"
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rake"
end

mcollective_version = ENV["MCOLLECTIVE_GEM_VERSION"]

if mcollective_version
  gem "mcollective-client", mcollective_version, :require => false
else
  gem "mcollective-client", :require => false
end
