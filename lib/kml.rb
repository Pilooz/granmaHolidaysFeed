# -*- coding: utf-8; -*-
require 'rexml/document'
include REXML

# class that generates kml files.
# Usage : 
#   kml = GPX2KML.new("","Trajet du jour", "line1","line1", fullname)
#
class GPX2KML

	#
	# name = KML
	# description = KML
	#
	def initialize(docname="Trajet du jour",docdesc="trace du jour",lineid,linename,gpxfilename)
    targetfilename = gpxfilename.gsub('.gpx', '.kml')
    coordinate_data = ""
	  # The PGX to KML conversion is done only if the kml file does not exists.
    if !File.exist?(targetfilename)
      @doc = '<?xml version="1.0" encoding="UTF-8"?>
              <kml xmlns="http://earth.google.com/kml/2.2">
                <Document>
                  <name>' + docname + '</name>
                  <description>' + docdesc + '</description>
              
                  <Style id="' + lineid + '">
                    <LineStyle>
                      <color>ff0000ff</color>
                    </LineStyle>
                  </Style>
              
                  <Placemark>
                    <name>' + linename + '</name>
                    <styleUrl>#' + lineid + '</styleUrl>
                    <LineString>
                      <altitudeMode>relative</altitudeMode>
                      <coordinates>'
      gpxdoc = Document.new File.new(gpxfilename)
      # Putting coordinates in kml
      gpxdoc.elements.each("/gpx/trk/trkseg/trkpt") do |element| 
        coordinate_data <<  element.attributes["lon"] + ',' + element.attributes["lat"]
        elevation = "0"
        elevation = element.elements['ele'].text unless !element.has_elements?
        coordinate_data << ',' + elevation  + "\n" 
      end
      @doc << coordinate_data
      @doc << '</coordinates></LineString></Placemark></Document></kml>'
      # writing file.
      File.open(targetfilename, "w+b", 0644) {|f| f.write @doc} unless File.exist?(targetfilename) 
    end
  end
  
end

