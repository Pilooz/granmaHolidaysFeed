# encoding: UTF-8
#
require_relative '../helper'
require_relative '../../app'


describe 'Testing Main controller' do
  behaves_like :rack_test

  before do
  end
  
  it "should give index page" do 
    get("/index").status.should == 200
    last_response.should =~ /<!-- This is index view -->/
  end
  
  it "should give history" do 
    get("/mails").status.should == 200
    last_response.should =~ /<!-- This mails view -->/
  end
  
end