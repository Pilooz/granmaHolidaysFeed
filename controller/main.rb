# coding:utf-8
class MainController < Controller
       
  layout 'default'
  set_layout nil => [:mails, :test]
  
  # the index action is called automatically when no other action is specified
  def index
    # One page site stuff
    @messages.listmsg = @messages.listmsg[0..0]
  end
  
  # Ajax route to laod mail history
  def mails
    # Don't take first element because it is already dispalyed.
    @messages.listmsg = @messages.listmsg[1..@messages.listmsg.length]
    render_view :mails
  end

  def test
    render_view :test
  end  
end

