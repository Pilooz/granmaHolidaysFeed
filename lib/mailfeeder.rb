# mail feeder for the GranmaHolidaysFeed
class MailFeeder
  attr_accessor :listmsg
 
  # Initilize The connection to mail server
  def initialize(server, port, username, password, images_dir)
    @images_dir = images_dir
    @mailconn = Mail.defaults do
                  retriever_method :imap, :address    => server,
                                          :port       => port,
                                          :user_name  => username,
                                          :password   => password,
                                          :enable_ssl => false
    end
    # An array of mail::Message
    @lastmails = Array.new
    # An array of MailItems
    @listmsg = Array.new
  end
    
  def retrievingAttr(idx)
    # Verifying from address agaisnt CONFIG
#    if @lastmails[idx].from == MYCONF[:mail_from]
      # Messageid (whitout server name)
      mailmsgid = @lastmails[idx].message_id.to_s[0 .. @lastmails[idx].message_id.to_s.index('@')-1]
      # Subject
      mailsubject = @lastmails[idx].subject.force_encoding('UTF-8')
      # Date & time in separated attributes
      date = @lastmails[idx].date.to_s.force_encoding("UTF-8")
      maildate = date[0..9]
      mailtime = date[11..18]
      # body
      mailtext = nil
      if @lastmails[idx].multipart? 
        @lastmails[idx].parts.map  do |p| 
          if p.content_type.start_with?('text/plain') && mailtext.nil?
            mailtext = p.body.to_s.force_encoding("UTF-8")
          end
        end
      else
        mailtext = @lastmails[idx].body.decoded.to_s.force_encoding("UTF-8")
      end
  
      mailattachmentlink = nil
      mailattachmenttype = nil
      mailimagewidth = nil
      mailimageheight = nil
      mailimagelat = nil
      mailimagelong = nil
      # Image Attatchement if any and storing it in public/pictures directory
      @lastmails[idx].attachments.each do | attachment |
        # extracting images for example...
        filename = mailmsgid.downcase! + "-" + attachment.filename.downcase!
        mailattachmentlink = filename
        mailattachmenttype = 'doc'
        fullname = @images_dir +'/' + filename
        
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
      
      # A MailItem Object
      @mailItemTemp = MailItem.new(mailmsgid, mailsubject, maildate, mailtime, mailtext, mailattachmentlink, 
                                   mailattachmenttype, mailimagewidth, mailimageheight, mailimagelat, mailimagelong)
#   end  
 end
  
  # Retrieves the last mail from inbox
  def getlastmail
    # When retruning only one message, objetc is not an array but a instance of mail::Message
    # So we put it in an array to retrieve needed data in the same way as getlistmails method
    lastmail = @mailconn.last
    @lastmails.push lastmail 
    @listmsg.push retrievingAttr(0) 
  end
  
  # Retrives a list of mails for archive page generation
  def getlistmails(nb)
    @lastmails = @mailconn.find(:what => :first, :count => nb, :order => :desc).to_a
    if !@lastmails.nil?
      @lastmails.each_index do |idx|
         @listmsg.push retrievingAttr(idx)
      end
    end
  end
end