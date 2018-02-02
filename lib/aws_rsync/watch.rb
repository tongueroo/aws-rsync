require 'filewatcher'

module AwsRsync
  class Watch
    def initialize(options)
      @options = options
    end

    def run
      Dir.chdir(@options[:cwd]) do
        puts "Watching dir #{@options[:cwd]}"
        ignore = %w[. .. .git log tmp] # TODO: dynamically look up ignores
        files = Dir.glob(['.*','*']) - ignore
        return false if @options[:noop]
        Sync.new(@options).run
        Filewatcher.new(files).watch() do |filename, event|
          Sync.new(@options).run
        end
      end
    end
  end
end
