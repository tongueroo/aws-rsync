module AwsRsync
  class Sync
    def initialize(options)
      @options = options
    end

    def run
      puts "=> #{command}".colorize(:green)
      system(command)
      raise "rsync execution returned failure" if ($?.exitstatus != 0)
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
      # dest = "rsync://#{host.ip}:#{port}/volume/"

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

  end
end
