# This file contains your application, it requires dependencies and necessary parts of 
# the application.
#
# It will be required from either `config.ru` or `start.rb`
require 'ramaze'

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [__DIR__]

# Dependencies. 
require 'ramaze/helper/user'
require 'yaml'
require 'mail'
require 'exifr'
require 'redis'
require 'json'

# Initialize controllers and models
require __DIR__('config/init')
require __DIR__('lib/init')
require __DIR__('controller/init')
