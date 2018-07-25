
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "capistrano/vault/version"

Gem::Specification.new do |spec|
  spec.name          = "capistrano-vault"
  spec.version       = Capistrano::Vault::VERSION
  spec.authors       = ["蒼時弦也"]
  spec.email         = ["contact@frost.tw"]

  spec.summary       = %q{Load secret and ssh certificate from Hashicorp Vault}
  spec.description   = %q{Load secret and ssh certificate from Hashicorp Vault}
  spec.homepage      = "https://github.com/elct9620/capistrano-vault"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "vault", "~> 0.1"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
