module AwsRsync
  class Sync
    def initialize(options)
      @options = options
    end

    def run
      puts "=> #{command}".colorize(:green)
      return if @options[:noop]
      success = system(command)
      unless success
        puts "ERROR: rsync command failed".colorize(:red)
        exit 1
      end
      note_time
    end

    def command
      main_options = build_main_options
      exclude = build_exclude_options
      options = "#{main_options} #{exclude}"
      dest = "#{user}@#{host.ip}:#{folder}"

      "rsync #{options} #{src} #{dest}"
    end

    # A default set of options is provided.
    # You can override this with the environment variable AWS_RSYNC_OPTIONS.
    #
    def build_main_options
      return ENV['AWS_RSYNC_OPTIONS'] if ENV['AWS_RSYNC_OPTIONS']

      # --numeric-ids               don't map uid/gid values by user/group name
      # --safe-links                ignore symlinks that point outside the tree
      # -a, --archive               recursion and preserve almost everything (-rlptgoD)
      # -x, --one-file-system       don't cross filesystem boundaries
      # -z, --compress              compress file data during the transfer
      # -S, --sparse                handle sparse files efficiently
      # -v, --verbose               verbose
      #     --delete                delete extraneous files from destination dirs
      #
      "--delete --numeric-ids --safe-links -axzSv"
    end

    # The rsync exclude options are automatically calculated and added with some
    # sane defaults. You can override the options with the environment variable
    # AWS_RSYNC_EXCLUDE.  To have no exclude options at all use a blank string:
    # AWS_RSYNC_EXCLUDE=''
    def build_exclude_options
      return ENV['AWS_RSYNC_EXCLUDE'] if ENV['AWS_RSYNC_EXCLUDE']

      exclude = %w/.git tmp log/ # default values
      exclude += get_excludes('.gitignore')
      exclude += get_excludes('.dockerignore')
      exclude = exclude.uniq.map{|path| "--exclude='#{path}'"}.join(' ')
      exclude
    end

    def user
      @options[:user] || "ec2-user"
    end

    def host
      @host ||= Host.new(@options)
    end

    # destination folder
    def folder
      src = src == '.' ? Dir.pwd : src
      @options[:folder] || File.basename(src)
    end

    def src
      src = @options[:cwd] || Dir.pwd
      src[-1] == '/' ? src : "#{src}/" # ensure trailing /
    end

    def get_excludes(file)
      exclude = []
      path = "#{@options[:cwd]}/#{file}"
      if File.exist?(path)
        exclude = File.read(path).split("\n")
      end
      result = exclude.map {|i| i.strip}.reject {|i| i =~ /^#/ || i.empty?}
      result
    end

    def note_time
      puts "Last synced at: #{Time.now}".colorize(:green)
    end
  end
end
