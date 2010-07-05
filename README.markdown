What is Dimma?
==============
Dimma is a Ruby library aimed to create a simple interface to [Beacons REST API](http://www.beaconpush.com/), built on top of the sweet [REST Client](http://github.com/archiloque/rest-client).

How do I use it?
----------------
Excellent question! This is how:

    # Set up the session.
    beacon = Dimma.new(API_KEY, SECRET_KEY)
    
    # Send a message to all users in the default channel.
    beacon.message "We now have a total of #{beacon.users} users online!"
    
    # Send a message to all users in the “chunky” channel.
    chunky = beacon.channel "chunky"
    chunky.message "Chunky bacon!"
    # Spit out all the channel users in the “chunky” channel.
    chunky.message "Current users in “chunky” channel: #{chunky.users.map(&:name).join ', '}"
    
    # Send a message to a specific user if she is online.
    candy = beacon.user "godisnappen88"
    candy.message 'A/S/L?' if candy.online?

Really? Yeah, really! For more advanced usage I suggest you [read the documentation](http://rdoc.info/projects/Burgestrand/Dimma).

Yeah, yeah… and installing it?
------------------------------
There are several alternatives! Far easiest is if you are using
[Rubygems](http://rubygems.org/): `gem install dimma`.

If you are not I assume you know what you are doing.

Miscellaneous notes
-------------------
- Dimma uses [Semantic Versioning](http://semver.org/) as of version v1.0.0!
- Dimma is completely *rubygems agnostic* — it assumes all required libraries are available, but does not care how.