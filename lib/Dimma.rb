require 'delegate'
require 'rest-client'
require 'json'

# See http://beaconpush.com/guide for specification details.
#
module Dimma
  # The Beacon API (http://beaconpush.com/guide/rest-api) version Dimma conforms to.
  API_VERSION = "1.0.0"
  
  # @param (see Session#initialize)
  # @return (see Session#initialize)
  # @see Session#initialize
  def Dimma.new(*args)
    Session.new *args
  end

  class Session < SimpleDelegator
    # Initialize the Beacon API resource; you get both your API key and secret key from http://beaconpush.com/account/settings.
    #
    # @example
    #   # Specify that no requests must take longer than 10 seconds.
    #   dimma = Dimma::Session.new "key", "secret", :timeout => 10
    #
    # @param [#to_s] key API key.
    # @param [nil, #to_s] secret Secret key. Set to nil if you have turned off authentication.
    # @param [Hash] options (see RestClient#initialize)
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

    # Send a message to the 'default' channel.
    #
    # @param (see Channel#message)
    # @return (see Channel#message)
    # @see Channel#message
    def message(message)
      channel.message(message)
    end
    
    # Retrieve a user by name, bound to this Session.
    #
    # @param [#to_s] name
    # @return (see Session#initialize)
    def user(name)
      User.new(name, __getobj__)
    end
    
    # Retrieve a channel by name, bound to this Session.
    # 
    # @param [#to_s] name
    # @return (see Channel#initialize)
    def channel(name = 'default')
      Channel.new(name, __getobj__)
    end
  end
  
  class User < SimpleDelegator
    # @return [String]
    attr_reader :name
    
    # Create a new User resource.
    #
    # @param [#to_s] name
    # @param [RestClient::Resource] resource An object conformant with the RestClient API.
    def initialize(name, resource)
      __setobj__ resource["users/#{@name = name.to_s}"]
    end

    # True if the user is online.
    #
    # @return [Boolean]
    def online?
      get.code == 200 rescue false
    end

    # Force-logout the user.
    #
    # @return [RestClient::Response]
    def logout
      delete
    end

    # Send a message to the user.
    #
    # @param [#to_json] message Data to send to the user.
    # @return [RestClient::Response]
    # @raise [RestClient::Exception]
    def message(message)
      post message.to_json
    end
  end
  
  class Channel < SimpleDelegator
    # @return [String]
    attr_reader :name
    
    # Create a new Channel resource.
    #
    # @param [#to_s] name
    # @param [RestClient::Resource] resource An object conformant with the RestClient API.
    def initialize(name, resource)
      __setobj__ resource["channels/#{@name = name.to_s}"]
    end

    # Sends a message to all users in the channel.
    #
    # @param [#to_json] message Data to send to the channel.
    # @return [RestClient::Response]
    # @raise [RestClient::Exception]
    def message(message)
      post message.to_json
    end

    # Retrieve all users in the channel.
    #
    # @return [Array<User>] Array of users.
    def users
      JSON.parse(get.body)["users"].map { |user| User.new(user, __getobj__) }
    end
  end
end