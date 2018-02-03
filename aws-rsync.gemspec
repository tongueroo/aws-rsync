# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "aws_rsync/version"

Gem::Specification.new do |spec|
  spec.name          = "aws-rsync"
  spec.version       = AwsRsync::VERSION
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tongueroo@gmail.com"]
  spec.description   = %q{Tool rsyncs local files to AWS EC2 instance for a faster development flow}
  spec.summary       = %q{Tool rsyncs local files to AWS EC2 instance for a faster development flow}
  spec.homepage      = "https://github.com/tongueroo/aws-rsync"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "colorize"
  spec.add_dependency "filewatcher"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
