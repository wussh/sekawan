# Installation and Configuration Guide for Laravel Application Server

## Step 1: Create EC2 Instance
1. Create an EC2 Instance on AWS or your preferred cloud provider.
2. SSH into the created instance.
### Instance Specifications

For this project, I'm using the following specifications for the EC2 Instance:

- **OS:** Ubuntu 22.04
- **Instance Type:** t2.micro
- **vCPU:** 1
- **RAM:** 1.0 GB
- **Storage:** 1x8 GiB gp2 (General Purpose SSD)

## Step 2: Install PHP, Nginx, and MariaDB
```bash
#!/bin/bash

# Update system packages and install dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y ca-certificates apt-transport-https software-properties-common

# Add Ondrej PPA repository
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update

# Install PHP 8.1 and PHP-FPM
sudo apt install -y php8.1 php8.1-fpm

# Verify PHP-FPM service
sudo systemctl status php8.1-fpm

# Install Nginx
sudo apt install -y nginx

# Start and enable Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx

# Add UFW
sudo ufw enable
sudo ufw allow 22
sudo ufw allow 'Nginx HTTP'

# Create a new Nginx configuration file
sudo nano /etc/nginx/sites-available/default
```

**Add Nginx configuration:**
```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

**Restart Nginx:**
``` sudo systemctl restart nginx ```

## Step 4: Install Composer, PHP Extensions, Node.js, and MariaDB
```bash
# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --version=2.2.0
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Install PHP 8.1 and Extensions
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt install -y php8.1 php8.1-fpm php8.1-zip php8.1-xml php8.1-curl php8.1-gmp php8.1-bcmath php8.1-mysql php8.1-mbstring php8.1-common php8.1-cli

# Install Node.js
curl -s https://deb.nodesource.com/setup_16.x | sudo bash
sudo apt install -y nodejs

# Install MariaDB
sudo apt install -y mariadb-server
sudo mysql_secure_installation
```

## Step 5: Install Laravel Application
1. Git clone `https://github.com/nasirkhan/laravel-starter.git`.
2. Navigate to the project directory and run `composer install`.
3. Create a `.env` file by copying from `.env.example` using the command `cp .env.example .env`.
4. Update database name and credentials in the `.env` file.
5. Run `php artisan key:generate`.
6. Run `php artisan migrate --seed`.
7. Link the storage directory with the command `php artisan storage:link`.
8. You can create a virtual host or run `php artisan serve` from the project root and visit http://127.0.0.1:8000.

## Step 6: Test the Application
1. Open the application in the browser.
2. Register a new user.
3. Log in with the newly created user.
4. Ensure features like displaying posts, categories, tags, comments, etc., are functional.

### Default User
- Email: super@admin.com
- Password: secret

### Adding Demo Data
To add demo data, run the following command:
```bash
php artisan starter:insert-demo-data
```

# Email Configuration using Mailtrap.io
To configure email services in your Laravel application and use Mailtrap.io as the SMTP service provider, follow these steps:

1. **Create a Mailtrap.io Account**:
   - Create an account on [Mailtrap.io](https://mailtrap.io/).
   - Obtain SMTP credential information provided by Mailtrap.io.

2. **Update .env Configuration**:
   - Open the `.env` file in your Laravel project.
   - Change or add the following email configuration:

    ```env
    MAIL_MAILER=smtp
    MAIL_HOST=sandbox.smtp.mailtrap.io
    MAIL_PORT=2525
    MAIL_USERNAME=743bf0b52f4988
    MAIL_PASSWORD=d76b55e1bad666
    MAIL_ENCRYPTION=null
    MAIL_FROM_ADDRESS="hello@example.com"
    MAIL_FROM_NAME="${APP_NAME}"
    ```

    Be sure to replace `MAIL_USERNAME` and `MAIL_PASSWORD` with the correct values you obtained from Mailtrap.io.

3. **Save and Run the Application**:
   - Save changes to the `.env` file.
   - Run the command `php artisan config:cache` to cache the configuration.

With this configuration, your Laravel application will use Mailtrap.io as the email service provider for development and testing purposes. Make sure to replace the credential values with correct information from your Mailtrap.io account.