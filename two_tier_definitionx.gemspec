$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "two_tier_definitionx/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "two_tier_definitionx"
  s.version     = TwoTierDefinitionx::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of TwoTierDefinitionx."
  s.description = "TODO: Description of TwoTierDefinitionx."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">=3.2.12"
  s.add_dependency "jquery-rails"
  s.add_dependency "simple_form"  
  s.add_dependency "will_paginate"
  s.add_dependency "database_cleaner"
  s.add_dependency "execjs"

  s.add_dependency "sass-rails", '~>3.2.3'
  s.add_dependency "coffee-rails", '~>3.2.1'   
  s.add_dependency "uglifier"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", ">= 2.0.0"
  s.add_development_dependency "factory_girl_rails" #, '~>3.0'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'launchy'   #with capybara
end
