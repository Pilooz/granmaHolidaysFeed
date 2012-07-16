# encoding: UTF-8
#

require_relative '../helper'
require 'mail'
require_relative '../../lib/mailitem'

describe 'Testing mailitem class' do
  before do 
    @i = MailItem.new(1234, 'Test subject', '2012-07-16', '11:49:00', 'This mail text', 'him@domain.com', 'link', 'DOC', '123', '321', '45.3333', '10.3333');
  end
   
  it 'should return correct values for all attributes...' do 

    @i.mailmsgid.should.equal 1234
    @i.mailsubject.should.equal 'Test subject'
    @i.maildate.should.equal '2012-07-16'
    @i.mailtime.should.equal '11:49:00'
    @i.mailtext.should.equal 'This mail text'
    @i.mailfrom.should.equal 'him@domain.com'
    @i.mailattachmentlink.should.equal 'link'
    @i.mailattachmenttype.should.equal 'DOC'
    @i.mailimagewidth.should.equal '123'
    @i.mailimageheight.should.equal '321'
    @i.mailimagelat.should.equal '45.3333'
    @i.mailimagelong.should.equal '10.3333'
  end
  
end