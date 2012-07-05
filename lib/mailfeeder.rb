# mail feeder for the GranmaHolidaysFeed

class MailFeeder
  # TODO : Les accesseurs sur les données qu'on veut mettre dans les vues.
  attr_accessor :lastmail, :mailmsgid, :mailsubject, :maildate, :mailtime, :mailtext, 
                :mailimagefile, :mailimagewidth, :mailimageheight, :mailimagelat, :mailimagelong
 
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
    #@lastmails = Array.new 
  end
  
  # Retrieves the messageId (whitout server name) of a mail in array of mails
  def getmessageid
    @mailmsgid = @lastmail.message_id.to_s[0 .. lastmail.message_id.to_s.index('@')-1]
  end
  
  # Retrieves mail subject of the array of mails, and force char encoding
  def getmaildate
    @mailsubject = @lastmail.subject.force_encoding('UTF-8')
  end
  
  # Retrieves the mail date of the array of mails, and force char encoding without hours/min/sec.
  def getsubject
    date = @lastmail.date.to_s.force_encoding('UTF-8')
    @maildate = date[0..9]
    @mailtime = date[11..18]
  end
  
  # Retrieving the body of the mail, in multipart mail, 
  # retrieves the first part which content-type is like 'text/plain'
  # if the attribute is already set (not nil) we don't crush it
  def getmailtext
    @lastmail.parts.map  do |p| 
      if p.content_type.start_with?('text/plain') && @mailtext.nil?
        @mailtext = p.body.to_s.force_encoding('UTF-8')
      end
    end
  end
  
  # retrieving image attachement and storing it in public/pictures directory
  def getimage
    @lastmail.attachments.each do | attachment |
      # Attachments is an AttachmentsList object containing anumber of Part objects
      if (attachment.content_type.start_with?('image/'))
        # extracting images for example...
        filename = @mailmsgid + "-" + attachment.filename.downcase!
        @mailimagefile = filename
        fullname = @images_dir +'/' + filename
        
        # Saving picture
        begin
          File.open(fullname, "w+b", 0644) {|f| f.write attachment.body.decoded} unless File.exist?(fullname)         
        rescue Exception => e
          puts "Unable to save data for #{filename} because #{e.message}"
        end
        
        # Playing with exif data
        begin 
          @mailimagewidth = EXIFR::JPEG.new(fullname).width
          @mailimageheight = EXIFR::JPEG.new(fullname).height
          @mailimagelat = EXIFR::JPEG.new(fullname).gps.latitude   if EXIFR::JPEG.method_defined? :latitude 
          @mailimagelong = EXIFR::JPEG.new(fullname).gps.longitude if EXIFR::JPEG.method_defined? :longitude 

        rescue Exception => e 
          puts "Unable to find exif data for #{filename} : #{e.message}"
        end
      end
    end
  end
  
  def retrievingAttr
    getmessageid
    getsubject
    getmaildate
    getmailtext
    getimage
  end
  
  # Retrieves the last mail from inbox
  def getlastmail
    @lastmail = @mailconn.last 
    retrievingAttr
  end
  
  # Retrives a list of mails for archive page generation
  def getlastmails(nb)
    @lastmails = @mailconn.find(:what => :first, :count => nb, :order => :desc)
    @lastmails.to_a
  end
  
  
  
end