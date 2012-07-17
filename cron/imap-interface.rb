#!/usr/bin/env ruby
require_relative '../app'
MYCONF[:mail_attachment_dir] = '../public/content'

# set Redis
redis = Redis.new(:host => MYCONF[:redis_server], :port => MYCONF[:redis_port])

# Get last messages
@messages = MailFeeder.new(__DIR__(MYCONF[:mail_attachment_dir]))
@messages.retrieve(100)

# Put into a redis key
redis.set("listmsg", Marshal.dump(@messages.listmsg))