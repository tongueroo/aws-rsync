module AwsRsync
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "hello NAME", "say hello to NAME"
    long_desc Help.text(:hello)
    option :from, desc: "from person"
    def hello(name="you")
      puts "from: #{options[:from]}" if options[:from]
      puts "Hello #{name}"
    end

  end
end
