require 'aws-sdk-ec2'

module AwsRsync::AwsServices
  def ec2
    @ec2 ||= Aws::EC2::Client.new
  end
end
