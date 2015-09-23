source 'https://rubygems.org'

gem 'rails', '4.2.1'

# dev
group :development, :test do
  gem 'sqlite3', '1.3.8'
end

# tests
group :test do 
  gem 'shoulda'
end

gem 'awesome_nested_set', '~> 3.0.1'
gem "friendly_id", "~> 5.0.1"
gem 'amoeba'

gem 'sunspot_rails', git: "http://github.com/betam4x/sunspot.git" # , '2.1.1'
gem 'sunspot_solr', git: "http://github.com/betam4x/sunspot.git" # '2.1.1'

# assets management
gem "sass-rails", "~> 4.0.2"
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.1'
gem 'jquery-rails', '3.0.4'
gem 'jquery-ui-rails'

gem 'coffee-script-source', '1.8.0'

# viewable
gem 'kramdown'
gem 'jbuilder', '1.0.2'
gem 'cocoon'
gem 'kaminari'
gem 'draper', '~> 1.3'

# user expierence
gem 'devise'


group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin]
