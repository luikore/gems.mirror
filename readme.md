# Usage

### Generate nginx.conf:

    rake config

### Start server:

    rackup -E production -D config.ru
    sudo nginx -c `pwd`/nginx.conf

### Simply mock rubygems.org

On client machine(not the mirror server!), edit /etc/hosts

    <%= your_gem_mirror_server_ip %> rubygems.org

### Renew specs hourly:

    crontab -e

Add an hourly task that removes specs.*.gz in nginx root