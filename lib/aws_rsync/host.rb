module AwsRsync
  class Host
    include AwsServices

    def initialize(options={})
      @options = options
      @instance_id = options[:instance_id]
    end

    def instance
      instances = ec2.describe_instances(instance_ids: [@instance_id]).
        reservations.first["instances"] || []
      instance = instances.first
      unless instance
        puts "ERROR: unable to find instance '#{@instance_id}' in this aws account and region."
        # TODO: get region from ~/.aws/config
        exit 1
      end
      instance
    end

    def ip
      @options[:public_ip] ?
        instance.public_ip_address :
        instance.private_ip_address
    end
  end
end
