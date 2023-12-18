#!/bin/bash
sudo yum update -y
sudo yum install -y php
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<html><html lang=\"en\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title>Hostname Display</title></head><body><html><html><p><?php echo \"hostname is : \".gethostname(); ?></p></body></html>" | sudo tee  /usr/share/nginx/html/index.php && sudo sed -i 's/index\.html/index\.php/g' /etc/nginx/nginx.conf