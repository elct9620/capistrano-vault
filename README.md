# Capistrano Vault

Provide capistrano access your Hashicrop Vault server to signature certificate to ssh into server, or read access token saved in Vault.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-vault'
```

## Usage

### SSH without config

Enable SSH Plugin in Capfile

```ruby
# ...
require "capistrano/vault"

# This Hook will override your ssh options to use signed key and publickey mode to ssh.
install_plugin Capistrano::Vault::SSH
```

Setup the options to sign

```ruby
set :vault_address, 'https://vault.example.com' # If not set, it will use EVN['VAULT_ADDR']
set :vault_ssh_mount_path, 'ssh-client-signer'
set :vault_ssh_role, 'deploy'
```

Before running capistrano command, make sure you are already `vault login`

> Make sure your are added the trusted ca in your server.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elct9620/capistrano-vault.
