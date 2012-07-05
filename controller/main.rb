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
       
  layout 'default'
  set_layout nil => [:loadhistory]
  
  # the index action is called automatically when no other action is specified
  def index
    # One page site stuff
                
    #Each time someone's viewving this page, we launch mail reading...
    @mailconn = MailFeeder.new( MYCONF[:mail_server], 
                            MYCONF[:mail_port], 
                            MYCONF[:mail_username], 
                            MYCONF[:mail_password],
                             __DIR__(MYCONF[:images_dir])
                          )
    @mailconn.getlastmail
  end
  
  # Ajax route to laod mail history
  def loadhistory
    @mailconn = MailFeeder.new( MYCONF[:mail_server], 
                            MYCONF[:mail_port], 
                            MYCONF[:mail_username], 
                            MYCONF[:mail_password],
                             __DIR__(MYCONF[:images_dir])
                          )
    @mailconn.getlistmails(10)
    render_view :loadhistory
  end
  
end

