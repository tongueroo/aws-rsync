$:.unshift(File.expand_path("../", __FILE__))
require "aws_rsync/version"
require "colorize"

module AwsRsync
  autoload :Help, "aws_rsync/help"
  autoload :Command, "aws_rsync/command"
  autoload :CLI, "aws_rsync/cli"
  autoload :AwsServices, "aws_rsync/aws_services"
  autoload :Sync, "aws_rsync/sync"
  autoload :Host, "aws_rsync/host"
  autoload :Watch, "aws_rsync/watch"
end
