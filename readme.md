# Brief

To speed up bundler for slow network. Bundler 1.0.x and 1.1 are supported.

# Requirement

ruby, rack, nginx, mongrel

# Usage

### Generate nginx.conf:

    rake config

### Start server:

    rake start

### Stop server:

    rake stop

### Simply mock rubygems.org:

On client machine(not the mirror server!), edit /etc/hosts

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

After binding the ip of mirror server to rubygems.org, visit rubygems.org/gems/

# Caveats

Remember to comment out the /etc/hosts binding of the mirror server before doing `gem push` or `gem yank` etc.