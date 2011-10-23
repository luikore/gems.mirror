# Brief

To speed up bundler for slow network. Bundler 1.0.x and 1.1 are supported.

# Requirement

ruby, rack, nginx, mongrel

Can visit rubygems.org at your server

# Usage

### Generate nginx.conf:

    rake config

### Start server:

    rake start

### Stop server:

    rake stop

### Use mirror for gem and spec downloading:

On client machine(NOT your mirror server!), edit /etc/hosts

    <%= your_gem_mirror_server_ip %> production.cf.rubygems.org
    <%= your_gem_mirror_server_ip %> production.s3.rubygems.org

If you have problem visiting rubygems.org on client side, bind this instead:

    <%= your_gem_mirror_server_ip %> rubygems.org

### Renew specs hourly:

    crontab -e

Add an hourly task that redownloads specs.*.gz in nginx root

    0 */1 * * * /bin/bash -l -c 'ruby your_path/renew.rb'

# Generated dirs and files

- `root` static files downloaded and serving
- `var` contains logs and pids
- `nginx.conf` change it if not fit

# List of cached gems

After binding the ip of mirror server, visit production.cf.rubygems.org/gems/ or rubygems.org/gems/ (with the slash)

# Caveats

Remember to comment out the /etc/hosts binding of rubygems.org before visiting rubygems.org doing `gem push` or `gem yank`.

If mirror server be in a bad network, can block concurrent requests.
