
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dress_socks/version"

Gem::Specification.new do |spec|
  spec.name          = "dress_socks"
  spec.version       = DressSocks::VERSION
  spec.authors       = ["Justin McNally"]
  spec.email         = ["justin@chowlyinc.com"]

  spec.summary       = 'A pure ruby implementation of SOCKSSocket'
  spec.description   = 'SOCKSSocket is great but require a lot of C gymnastics. This aims to do the same thing in all Ruby code.'
  spec.homepage      = 'https://github.com/chowly/dress_socks'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://rubygems.org'

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/chowly/dress_socks"
    spec.metadata["changelog_uri"] = "https://github.com/Chowly/dress_socks/blob/master/Changelog.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
