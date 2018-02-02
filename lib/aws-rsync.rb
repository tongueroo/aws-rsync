$:.unshift(File.expand_path("../", __FILE__))
require "aws_rsync/version"

module AwsRsync
  autoload :Help, "aws_rsync/help"
  autoload :Command, "aws_rsync/command"
  autoload :CLI, "aws_rsync/cli"
end
