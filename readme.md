## Usage

Generate nginx.conf:

    rake config

Start server:

    rackup -E production -D config.ru
    sudo nginx -c `pwd`/nginx.conf