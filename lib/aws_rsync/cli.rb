module AwsRsync
  class CLI < Command
    class_option :noop, type: :boolean

    desc "sync INSTANCE_ID", "rsync files on your local machine to a server"
    long_desc Help.text(:sync)
    option :watch, type: :boolean, desc: "watches your folder for changes and re-runs sync"
    option :private_ip, type: :boolean, desc: "whether to use the private or public ip address"
    option :folder, default: File.basename(Dir.pwd), desc: "the destination folder"
    option :user, default: "ec2-user", desc: "user to use to connect to server"
    option :cwd, default: ".", desc: "The local directory to sync"
    def sync(instance_id)
      merged_options = options.merge(instance_id: instance_id)
      if @options[:watch]
        Watch.new(merged_options).run
      else
        Sync.new(merged_options).run
      end
    end

    desc "version", "prints version"
    def version
      puts AwsRsync::VERSION
    end
  end
end
