# encoding: UTF-8
#
require_relative '../helper'
require_relative '../../lib/mailfeeder'


describe 'Testing mailfeeder class' do

  before do
    @m = MailFeeder.new(MYCONF[:attachment_dir])

    @mailAryFaked = Array.new 
    count = 0
    10.times do |i|
      if i == 5 
        sender =  'me@mydomain.com'
      else 
        sender =  MYCONF[:mail_from].to_s 
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
    @m.connect
    
    @m.connected.should.be.equal true
  end 
  
  it 'should filter mails where sender is not "' + MYCONF[:mail_from] + '"...' do 
    # No connection, just fake
    @mailAryFaked.each { |m|  @m.listmsg.push m }    
    @m.filter!
    @m.listmsg.size.should.equal 9
  end 
end