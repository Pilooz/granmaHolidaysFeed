require 'ramaze'
require 'ramaze/spec/bacon'

require __DIR__('../app')

describe MainController do
  behaves_like :rack_test

#  should 'show start page' do
#    get('/').status.should == 200
#    last_response['Content-Type'].should == 'text/html'
#    last_response.should =~ /@{#appname}/
#  end
end
