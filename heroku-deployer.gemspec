# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "heroku-deployer/version"

Gem::Specification.new do |s|
  s.name        = "heroku-deployer"
  s.version     = Heroku::Deployer::VERSION
  s.authors     = ["ph"]
  s.email       = ["patrick@heisiph.de"]
  s.homepage    = ""
  s.summary     = %q{Adds deployment commands to the heroku CLI to ease deployment of Rails apps}
  s.description = %q{Adds deployment commands to the heroku CLI to ease deployment of Rails apps}

  s.rubyforge_project = "heroku-deployer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency "heroku"
end
