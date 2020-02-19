#!/bin/bash


sudo apt update -y
sudo apt install -y nginx
sudo apt install -y firewalld
echo "Installed software"
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl start nginx
sudo systemctl enable nginx
echo "enabled software"

sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload

sudo mkdir -p /var/www/example.com/html
sudo chown -R $USER:$USER /var/www/example.com/html
sudo chmod -R 755 /var/www/example.com
sudo chown -R $USER:$USER /var/log/nginx
echo "Permissions Assigned"
sudo echo '<html>
    <head>
        <title>Welcome to Example.com!</title>
    </head>
    <body>
        <h1>Success!  The example.com server block is working!</h1>
    </body>
</html>' > /var/www/example.com/html/index.html
sudo echo 'server {
        listen 80;
        listen [::]:80;

        root /var/www/example.com/html;
        index index.html index.htm;

        server_name example.com www.example.com;

        location / {
                try_files $uri $uri/ =404;
        }
}' > /etc/nginx/sites-available/example.com
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
sudo nginx -t
echo "Files created and linked"
sudo systemctl restart nginx
