# coding:utf-8
# Default url mappings are:
# 
# * a controller called Main is mapped on the root of the site: /
# * a controller called Something is mapped on: /something
# 
# If you want to override this, add a line like this inside the class:
#
#  map '/otherurl'
#
# this will force the controller to be mounted on: /otherurl.


class MainController < Controller
        
  # the index action is called automatically when no other action is specified
  def index
    # One page site stuff
                
    #Each time someone's viewving this page, we launch mail reading...
    @mail = MailFeeder.new(MYCONF[:mail_server], MYCONF[:mail_port], MYCONF[:mail_username], MYCONF[:mail_password], __DIR__(MYCONF[:images_dir]))
    @mail.getlastmail
    puts @mail.mailsubject
  end
end

