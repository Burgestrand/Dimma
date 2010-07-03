require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Dimma do
  before do
    @url ||= "http://api.beaconpush.com/#{Dimma::API_VERSION}/resource/"
    @obj = Dimma.new("resource")

    # Total user count
    stub_request(:get, @url + 'users').to_return(:body => {:online => 10}.to_json)
    
    # Channel message posting
    stub_request(:get, @obj.channel.url).to_return(:body => {:users => ['Kim']}.to_json)
    stub_request(:post, @obj.channel.url).
      with(:body => 'Message'.to_json).to_return(:body => {:messages_sent => 1}.to_json)
      
    # User API
    @user = @obj.user 'Kim'
    stub_request(:get, @user.url).to_return(:headers => {:code => 200})
    stub_request(:post, @user.url).
      with(:body => 'Message'.to_json).to_return(:body => {:messages_sent => 1}.to_json)
    stub_request(:delete, @user.url).to_return(:headers => {:code => 204})
  end
  
  it "can retrieve a total usercount" do
    @obj.users
    WebMock.should have_requested(:get, @obj['users'].url)
  end
  
  it "can send messages to default channel" do
    @obj.message 'Message'
    WebMock.should have_requested(:post, @obj.channel.url).with(:body => 'Message'.to_json)
  end
  
  describe Dimma::User do
    it "should have a name" do
      @user.name.should == 'Kim'
    end
    
    it "should be online" do
      @user.online?.should be true
      WebMock.should have_requested(:get, @user.url)
    end
    
    it "can be logged out by force" do
      @user.logout
      WebMock.should have_requested(:delete, @user.url)
    end
    
    it "can be sent messages" do
      @user.message 'Message'
      WebMock.should have_requested(:post, @user.url).with(:body => 'Message'.to_json)
    end
  end
  
  describe Dimma::Channel do
    it "should have a name" do
      @obj.channel.name.should == "default"
    end
    
    it "can be sent messages" do
      channel = @obj.channel
      channel.message 'Message'
      WebMock.should have_requested(:post, channel.url).with(:body => 'Message'.to_json)
    end
    
    it "should have a list of users" do
      channel = @obj.channel
      channel.users.should == ['Kim']
      WebMock.should have_requested(:get, channel.url)
    end
  end
end