# Requirement

ruby, rack, nginx

# Usage

### Generate nginx.conf:

    rake config

### Start server:

    rake server

### Simply mock rubygems.org

On client machine(not the mirror server!), edit /etc/hosts

    <%= your_gem_mirror_server_ip %> rubygems.org

### Renew specs hourly:

    crontab -e

Add an hourly task that redownloads specs.*.gz in nginx root

    ruby your_path/renew.rb