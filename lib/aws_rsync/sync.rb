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
      # --numeric-ids               don't map uid/gid values by user/group name
      # --safe-links                ignore symlinks that point outside the tree
      # -a, --archive               recursion and preserve almost everything (-rlptgoD)
      # -x, --one-file-system       don't cross filesystem boundaries
      # -z, --compress              compress file data during the transfer
      # -S, --sparse                handle sparse files efficiently
      # -v, --verbose               verbose
      exclude = %w/.git tmp log/
      exclude += get_excludes('.gitignore')
      exclude += get_excludes('.dockerignore')
      exclude = exclude.uniq.map{|path| "--exclude='#{path}'"}.join(' ')
      options = "--delete --numeric-ids --safe-links -axzSv #{exclude}"
      src = get_src
      dest = "#{user}@#{host.ip}:#{folder}"

      "rsync #{options} #{src} #{dest}"
    end

    def get_src
      src = @options[:cwd] || Dir.pwd
      src[-1] == '/' ? src : "#{src}/" # ensure trailing /
    end

    def user
      @options[:user] || "ec2-user"
    end

    def host
      @host ||= Host.new(@options)
    end

    # destination folder
    def folder
      src = get_src
      src = src == '.' ? Dir.pwd : src
      @options[:folder] || File.basename(src)
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
