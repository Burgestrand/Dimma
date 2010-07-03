require 'delegate'
require 'rest-client'
require 'json'

module Dimma
  API_VERSION = "1.0.0"
  
  # @see Dimma::Session
  def Dimma.new(*args)
    Session.new *args
  end

  class Session < SimpleDelegator
    # Initialize the Beacon API resource.
    #
    # @param [#to_s] API key
    # @param [nil, #to_s] Secret key — not required if you have turned off authentication.
    # @param options (see RestClient#initialize)
    def initialize(key, secret = nil, options = {})
      url = "http://api.beaconpush.com/#{Dimma::API_VERSION}/#{key.to_s}/"
      options[:headers] ||= {}
      options[:headers].merge!({"X-Beacon-Secret-Key" => secret.to_s}) unless secret.nil?
      __setobj__ RestClient::Resource.new(url, options)
    end
    
    # Retrieve number of online users.
    #
    # @return [Fixnum]
    def users
      JSON.parse(self['users'].get.body)["online"]
    end

    # Send a message to the default channel (see Dimma#channel).
    def message(msg)
      channel.message(msg)
    end
    
    # Retrieve a user by name.
    #
    # @param [#to_s] Username
    # @return [RestClient::Resource]
    def user(name)
      User.new(name, __getobj__)
    end
    
    # Retrieve a channel by name.
    # 
    # @param [#to_s] Channel
    # @return [RestClient::Resource]
    def channel(name = 'default')
      Channel.new(name, __getobj__)
    end
  end
  
  class User < SimpleDelegator
    # Users’ name.
    attr_reader :name
    
    # Create a new User resource.
    #
    # @param [#to_s] Username
    # @param [RestClient::Resource]
    def initialize(name, resource)
      __setobj__ resource["users/#{@name = name.to_s}"]
    end

    # True if user is online.
    #
    # @return [Boolean]
    def online?
      get.code == 200 rescue false
    end

    # Force logout user.
    #
    # @return [RestClient::Response]
    def logout
      delete
    end

    # Send a message to the user.
    #
    # @param [#to_json] Data to send to the user.
    # @return [RestClient::Response]
    # @raise [RestClient::Exception]
    def message(msg)
      post msg.to_json
    end
  end
  
  class Channel < SimpleDelegator
    # Channel name.
    attr_reader :name
    
    # Create a new Channel resource.
    def initialize(name, resource)
      __setobj__ resource["channels/#{@name = name.to_s}"]
    end

    # Sends a message to the channel.
    #
    # @param [#to_json] Data to send to the channel.
    # @return [RestClient::Response]
    # @raise [RestClient::Exception]
    def message(msg)
      post msg.to_json
    end

    # Retrieve a list of users in a channel.
    #
    # @return [Array] Array of users.
    def users
      JSON.parse(get.body)["users"]
    end
  end
end