module AwsRsync
  class Host
    include AwsServices

    def initialize(options={})
      @options = options
      @instance_id = options[:instance_id]
    end

    def instance
      instance = find_instance
      unless instance
        puts "ERROR: unable to find instance '#{@instance_id}' in this aws account and region: #{region}"
        exit 1
      end
      instance
    end

    def find_instance
      instances = ec2.describe_instances(instance_ids: [@instance_id]).
        reservations.first["instances"] || []
      instance = instances.first
    rescue Aws::EC2::Errors::ServiceError => e
      puts "ERROR: Could not find the instance #{@instance_id}".colorize(:red)
      puts e.message
      puts "For the full internal backtrace re-run the command with DEBUG=1" unless ENV['DEBUG']
      puts e.backtrace if ENV['DEBUG']
      exit 1
    end

    def region
      `aws configure get region`.strip rescue 'us-east-1'
    end

    def ip
      @options[:private_ip] ?
        instance.private_ip_address :
        instance.public_ip_address
    end
  end
end
