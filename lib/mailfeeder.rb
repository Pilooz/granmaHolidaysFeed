# mail feeder for the GranmaHolidaysFeed
class MailFeeder
  attr_accessor :connected, :mailqueue, :listmsg
 
  # Initilize The connection to mail server
  def initialize(attch_dir)
    # is the connection ready ?
    @connected = false
    # dir for attachment
    @attch_dir = attch_dir
    # An array of mail::Message these are not filtered
    @mailqueue = Array.new
    # An array of MailItems : these mail are filtered 
    @listmsg = Array.new
  end
    
  # IMAP Cnnection method
  # returns true if connected
  def connect 
    begin
      @conn = Mail.defaults do
          retriever_method :imap, 
          :address    => MYCONF[:mail_server],
          :port       => MYCONF[:mail_port],
          :user_name  => MYCONF[:mail_username],
          :password   => MYCONF[:mail_password],
          :enable_ssl => false
      end
      @connected = true
    rescue Exception => e
      puts "Unable to connect to IMAP server. Reason : #{e.message}"
    end 
    @conn
  end
  
  #
  # Find and building list of mails
  #
  def find(nb=MYCONF[:mail_queuesize])
    @mailqueue = @conn.find(:what => :first, :count => nb, :order => :desc).to_a
    
    @mailqueue.each do |mail| 
      # Messageid (whitout server name)
      mailmsgid = mail.message_id.to_s[0 .. mail.message_id.to_s.index('@')-1]
      
      #sender
      mailfrom = mail.From
      
      # Subject
      mailsubject = mail.subject.force_encoding('UTF-8')
      
      # Date & time in separated attributes
      maildate = mail.date.to_s.force_encoding("UTF-8")[0..9]
      mailtime = mail.date.to_s.force_encoding("UTF-8")[11..18]
      
      # text
      mailtext = nil
      if mail.multipart? 
        mail.parts.map  do |p| 
          if p.content_type.start_with?('text/plain') && mailtext.nil?
            mailtext = p.body.to_s.force_encoding("UTF-8")
          end
        end
      else
        mailtext = mail.body.decoded.to_s.force_encoding("UTF-8")
      end
      
      # Attachement if any
      mailattachmentlink = nil
      mailattachmenttype = nil
      mailimagewidth = nil
      mailimageheight = nil
      mailimagelat = nil
      mailimagelong = nil
      mail.attachments.each do | attachment |
        # extracting images for example...
        filename = mailmsgid.downcase! + "-" + attachment.filename.downcase!
        mailattachmentlink = filename
        mailattachmenttype = 'doc'
        fullname = @attch_dir +'/' + filename
        
        # Saving attached doc
        begin
          File.open(fullname, "w+b", 0644) {|f| f.write attachment.body.decoded} unless File.exist?(fullname)         
        rescue Exception => e
          puts "Unable to save data for #{filename} because #{e.message}"
        end
        
        if (attachment.content_type.start_with?('image/'))
          mailattachmenttype = 'image'
          # Playing with exif data if attachment is a picture
          begin 
            mailimagewidth = EXIFR::JPEG.new(fullname).width
            mailimageheight = EXIFR::JPEG.new(fullname).height
            mailimagelat = EXIFR::JPEG.new(fullname).gps.latitude   if EXIFR::JPEG.method_defined? :latitude 
            mailimagelong = EXIFR::JPEG.new(fullname).gps.longitude if EXIFR::JPEG.method_defined? :longitude 
  
          rescue Exception => e 
            puts "Unable to find exif data for #{filename} : #{e.message}"
          end
        end
        
        # if attachment is a gpx file, let's convert it into kml file
        if (attachment.content_type.start_with?('application/gpx'))
          mailattachmenttype = 'gpx'
          kml = GPX2KML.new("","Trajet du jour", "line1","line1", fullname)
        end
      end
      
      # A MailItem Object in list 
      @listmsg.push MailItem.new(mailmsgid, mailsubject, maildate, mailtime, mailtext, mailfrom, mailattachmentlink, 
                                  mailattachmenttype, mailimagewidth, mailimageheight, mailimagelat, mailimagelong)
    end
  end
  
  #
  # filtering unneeded mails
  #
  def filter!
    @listmsg.keep_if {|msg| msg.mailfrom.to_s.include? MYCONF[:mail_from] } 
  end
  
  #
  # retrive method. This just simplify usage of the class.
  #
  def retrieve(nb)
    connect
    find(nb)
    filter!
  end  
    
end