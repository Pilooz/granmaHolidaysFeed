# MailItem is an array of compoents of the mail, prepared for displaying
class MailItem
  attr_accessor :mailmsgid, :mailsubject, :maildate, :mailtime, :mailtext, 
                :mailattachmentlink, :mailattachmenttype,
                :mailimagewidth, :mailimageheight, :mailimagelat, :mailimagelong
                
  def initialize(mailmsgid, mailsubject, maildate, mailtime, mailtext, 
                mailattachmentlink, mailattachmenttype, 
                mailimagewidth, mailimageheight, mailimagelat, mailimagelong) 
      @mailmsgid        = mailmsgid
      @mailsubject      = mailsubject
      @maildate         = maildate
      @mailtime         = mailtime
      @mailtext         = mailtext
      @mailattachmentlink    = mailattachmentlink
      @mailattachmenttype    = mailattachmenttype
      @mailimagewidth   = mailimagewidth
      @mailimageheight  = mailimageheight
      @mailimagelat     = mailimagelat
      @mailimagelong    = mailimagelong
  end
end


