# encoding: UTF-8
#
require_relative '../helper'
require_relative '../../lib/kml'

gpxfile = __DIR__("data/test.gpx")
kmlfile = __DIR__("data/test.kml")

describe 'Testing gpx2kml class' do

  before do
  end
  
  it "should not convert a gpx to kml because kml file exists..." do 
    @kml = GPX2KML.new("","Trajet du jour", "line1","line1", gpxfile)
    result = File.exist?(kmlfile)
    result.should.be.equal true
  end
  
  it "should convert gpx to kml because kml file doesn't exist..." do
    File.delete(kmlfile)
    result1 = File.exist?(kmlfile)
    
    @kml = GPX2KML.new("","Trajet du jour", "line1","line1", gpxfile)
    result2 = File.exist?(kmlfile)
    
    result1.should.be.equal false
    result2.should.be.equal true
  end
  
end