sudo apt update && sudo apt install -y php php-fpm php-mysql mysql-server git && \
sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS db_tracking;
CREATE USER IF NOT EXISTS 'gazali'@'localhost' IDENTIFIED BY 'gazali';
GRANT ALL PRIVILEGES ON db_tracking.* TO 'gazali'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF && \
sudo mkdir -p /var/www && cd /var/www && sudo git clone https://github.com/Muhammadalgazali/expose.git && cd expose && sudo mysql -u gazali -pgazali db_tracking < database.sql && \
sudo sed -i 's|root /var/www/html;|root /var/www/expose;|' /etc/nginx/sites-available/default && \
sudo sed -i '/index index.html index.htm index.nginx-debian.html;/c\    index index.php index.html;' /etc/nginx/sites-available/default && \
sudo sed -i '/location ~ \\\.php$ {/a\        include snippets/fastcgi-php.conf;\n        fastcgi_pass unix:/run/php/php8.3-fpm.sock;' /etc/nginx/sites-available/default && \
sudo systemctl reload nginx && \
echo "Setup complete. Here is the IP configuration:" && ifconfig
