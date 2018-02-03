# Aws Rsync

Rsync local files to an AWS EC2 instance for a faster development flow.

This tool is useful for working with single EC2 instances.  It takes the instance's id as the main argument and uses it to look up the instance's IP address. It then rsyncs your local project folder to the EC2 instance.

Some convenient things the tool does:.

* Allows you to use a local text editor of your preference and have your changes reflected on the server pretty quickly.
* Watches your files for changes and automatically re-syncs.
* Some useful rsync default options are pre-configured. These can be overriden if desired.
* The rsync exclude option is derived from your `.gitignore` and `.dockerignore` files. These can be overriden if desired.

## Usage

```sh
aws-rsync sync INSTANCE_ID # one time rsync call
aws-rsync sync INSTANCE_ID --watch # auto re-sync
```

For example, say you are in a demo-rails folder, and you run the command in the folder.  It will sync that demo-rails folder to the home folder of the EC2 instance.

```sh
$ git clone https://github.com/tongueroo/demo-rails
$ cd demo-rails
$ aws-rsync sync i-123456789
=> rsync --delete --numeric-ids --safe-links -axzSv --exclude='.git' --exclude='tmp' --exclude='log' --exclude='/.bundle' --exclude='/log/*' --exclude='/tmp/*' --exclude='!/log/.keep' --exclude='!/tmp/.keep' --exclude='/node_modules' --exclude='/yarn-error.log' --exclude='.byebug_history' --exclude='config/database.yml' ./ ec2-user@11.22.33.44:demo-rails
building file list ... done

sent 2742 bytes  received 20 bytes  1841.33 bytes/sec
total size is 38976  speedup is 14.11
Last synced at: 2018-02-02 17:07:00 -0800
```

Let's verify that the files are on the server now:

```
$ ssh ec2-user@11.22.33.44 'ls'
demo-rails
$ ssh ec2-user@11.22.33.44 'ls demo-rails | head -3'
app
bin
config
$
```

### Watch folder and automatically re-sync

Running the command with the `--watch` flag will sync once and then monitor the local directory for any file changes. When changes are detected, it'll automatically call sync again.

This allows you to use any local editor you prefer and have your changes reflect on the server pretty quickly.

### More Examples

```sh
aws-rsync sync i-123456789
aws-rsync sync i-123456789 --watch
aws-rsync sync i-123456789 --private-ip
aws-rsync sync i-123456789 --private-ip --watch
aws-rsync sync i-123456789 --user ec2-user
aws-rsync sync i-123456789 --noop
aws-rsync sync -h # more help
```

## Overriding the rsync command

You can override the rsync command with 2 environment variables:

* AWS\_RSYNC_OPTIONS: Override the rsync main options used.
* AWS\_RSYNC_EXCLUDE: Override the rsync exclude options used.

The pre-configured rsync options are listed here for convenience. For the most up to date pre-configured options, reference the source code here [sync.rb](lib/aws_rsync/sync.rb).

```sh
  --numeric-ids               don't map uid/gid values by user/group name
  --safe-links                ignore symlinks that point outside the tree
  -a, --archive               recursion and preserve almost everything (-rlptgoD)
  -x, --one-file-system       don't cross filesystem boundaries
  -z, --compress              compress file data during the transfer
  -S, --sparse                handle sparse files efficiently
  -v, --verbose               verbose
      --delete                delete extraneous files from destination dirs
```

## Installation

```sh
$ gem install aws-rsync
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
