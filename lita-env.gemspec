Gem::Specification.new do |spec|
  spec.name          = "lita-env"
  spec.version       = "0.0.1"
  spec.authors       = ["Ben Laplanche"]
  spec.email         = ["ben@laplanche.co.uk"]
  spec.description   = %q{Lita plugin to store the status of your environments}
  spec.summary       = %q{Lita plugin to store the status of your environments}
  spec.homepage      = "ben.laplanche.co.uk"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 3.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
