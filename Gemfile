#!ruby
source "https://rubygems.org"

group :test do
  gem "json", "~> 1.8.3"
  gem "mcollective-test"
  gem "mocha", "~> 0.10.0"
  gem "rake", "~> 10.4"
  gem "rspec", "~> 2.11.0"
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
