require_relative "lib/rmxp_extractor/version"

Gem::Specification.new do |spec|
  spec.name = "rmxp_extractor"
  spec.version = RMXPExtractor::VERSION
  spec.authors = ["Speak2Erase"]
  spec.email = ["matthew@nowaffles.com"]

  spec.summary = %q{A gem to dump *.rxdata files to JSON}
  spec.description = %q{A gem to dump and import *.rxdata files to and from JSON}
  spec.homepage = "https://rubygems.org/gems/rmxp_extractor"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Speak2Erase/RMXP-Extractor"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["**/**"].grep_v(/.gem$/)

  spec.executables = ["rmxp_extractor"]
  spec.require_paths = ["lib"]
end
