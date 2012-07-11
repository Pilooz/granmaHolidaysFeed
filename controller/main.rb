# coding:utf-8
class MainController < Controller
       
  layout 'default'
  set_layout nil => [:loadhistory, :test]
  
  # the index action is called automatically when no other action is specified
  def index
    # One page site stuff
                
    #Each time someone's viewving this page, we launch mail reading...
    # This should not be here, but where else ???
    @messages = MailFeeder.new( MYCONF[:mail_server], 
                        MYCONF[:mail_port], 
                        MYCONF[:mail_username], 
                        MYCONF[:mail_password],
                         __DIR__(MYCONF[:images_dir])
                      )

   @messages.getlastmail
  end
  
  # Ajax route to laod mail history
  def loadhistory
    @messages = MailFeeder.new( MYCONF[:mail_server], 
                        MYCONF[:mail_port], 
                        MYCONF[:mail_username], 
                        MYCONF[:mail_password],
                         __DIR__(MYCONF[:images_dir])
                      )

    @messages.getlistmails(20)
    # Don't take first element because it is already dispalyed.
    @messages.listmsg = @messages.listmsg[1..@messages.listmsg.length]
    render_view :loadhistory
  end

  def test
    render_view :test
  end  
end

