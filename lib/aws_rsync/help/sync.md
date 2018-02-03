Rsync local folder to an EC2 instance so you can quickly develop and test. Example:

  $ aws-rsync sync i-123456789

To watch changed files and re-run rsync automatically, use the --watch flag. Example:

  $ aws-rsync sync i-123456789 --watch

By default, the public ip address of the ec2 instance is used.  If you would like to use the private ip address instead, use the --private-ip flag. Example:

  $ aws-rsync sync i-123456789 --private-ip
