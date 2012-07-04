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
        
  # the index action is called automatically when no other action is specified
  def index
    # One page site stuff
                
    #Each time someone's viewving this page, we launch mail reading...
    # Imap connection
    Mail.defaults do
      retriever_method :imap, :address    => MYCONF[:mail_server],
                              :port       => MYCONF[:mail_port],
                              :user_name  => MYCONF[:mail_username],
                              :password   => MYCONF[:mail_password],
                              :enable_ssl => false
    end    
    # Retrieve last news
    lastmail = Mail.last
    
    # re-encoding Iphone mails that are ASCII_8BIT encoded...
    mailmsgid = lastmail.message_id.to_s[0 .. lastmail.message_id.to_s.index('@')-1]
    @mailsubject = lastmail.subject.force_encoding('UTF-8')
    @maildate = lastmail.date.to_s.force_encoding('UTF-8')

    lastmail.parts.map  do |p| 
      if p.content_type.start_with?('text/plain') && @mailtext.nil?
        @mailtext = autolink(nl2br p.body.to_s.force_encoding('UTF-8'))
      end
    end

    # Get image or video...
    lastmail.attachments.each do | attachment |
      images_dir = __DIR__(MYCONF[:images_dir])
      # Attachments is an AttachmentsList object containing anumber of Part objects
      if (attachment.content_type.start_with?('image/'))
        # extracting images for example...
        filename = mailmsgid + "-" + attachment.filename.downcase!
        @mailimagefile = filename
        fullname = images_dir +'/' + filename
        
        # Saving picture
        begin
          File.open(fullname, "w+b", 0644) {|f| f.write attachment.body.decoded} unless File.exist?(fullname)         
        rescue Exception => e
          puts "Unable to save data for #{filename} because #{e.message}"
        end
        
        # Palying with exif data
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
end

