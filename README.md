# DressSocks

A pure ruby implementation of SOCKSSocket, allowing tunneling a socket through a SOCKS proxy.

Based heavily on Socksify, we needed more flexibility in how we setup the tcp connection and only setting it up for certain pieces of code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dress_socks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dress_socks

## Usage

DressSocks::Socket.new(remote_host, remote_port, socks_username: nil, socks_password: nil, socks_server: nil, socks_port: nil, socks_ignore: [], socks_version: '5')

Creates a new TCP Socket that tunnels through the socks configuration passed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chowly/dress_socks.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
