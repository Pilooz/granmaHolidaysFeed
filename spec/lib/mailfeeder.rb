# encoding: UTF-8
#
require_relative '../helper'
require_relative '../../lib/mailfeeder'

# Put the mail module in test mode
Mail.defaults do
  retriever_method :test
  delivery_method  :test
end 

# Mock the Mail.find method
#def Mail::find(nb)
   
#end

describe 'Testing mailfeeder class' do

  before do
    @m = MailFeeder.new(MYCONF[:mail_attachment_dir])
    # Define an array of mail
    @mailAryFaked = Array.new 
    count = 0
    10.times do |i|
      if i == 5 
        sender =  'me@mydomain.com'
      else 
        sender =  MYCONF[:mail_from]
      end
      mm = MailItem.new('#' + i.to_s, 'Test subject', '2012-07-1'+ i.to_s, '11:49:00', 'This mail text' + i.to_s, sender, 'link', 'DOC', '1', '1', '1.1', '1.1')
      @mailAryFaked.push mm
    end
  end
  
  it "should initialize an empty array..." do 
    @m.should.not.be.same_as Array.new
    @m.listmsg.should.be.empty
    @m.listmsg.size.should.equal 0
  end
  
  it 'should connect correctly' do
    old_mail_server = MYCONF[:mail_server]
    MYCONF[:mail_server] = 'fakeimapserver.mydomain.com'
    @m.connect
    
    @m.listmsg.should.be.empty
    @m.connected.should.be.equal true
    
    MYCONF[:mail_server] = old_mail_server
  end 
  
#  it "should find " + MYCONF[:mail_queuesize] + " mails (default number in conf)..." do 
#    @m.find()
#    
#    @m.listmsg.size.should.equal MYCONF[:mail_server]
#  end
  
#  it "should find 3 mails..." do 
#    @m.find(3)
    
#    @m.listmsg.size.should.equal 3
#  end
  
  
  it 'should filter mails where sender is not "' + MYCONF[:mail_from] + '"...' do 
    # No connection, just fake
    @mailAryFaked.each { |m| @m.listmsg.push m }    
    @m.filter!
    @m.listmsg.size.should.equal 9
  end 
end