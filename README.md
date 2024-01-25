# Panduan Instalasi dan Konfigurasi Server untuk Aplikasi Laravel

## Langkah 1: Membuat EC2 Instance
1. Buat EC2 Instance di AWS atau cloud provider pilihan Anda.
2. Lakukan SSH ke instance yang telah dibuat.

## Langkah 2: Instalasi PHP, Nginx, dan MariaDB
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
sudo ufw allow 80

# Create a new Nginx configuration file
sudo nano /etc/nginx/sites-available/default
```

**Tambahkan konfigurasi Nginx:**
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
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```


## Langkah 4: Instalasi Composer, PHP Extensions, Node.js, dan MariaDB
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

## Langkah 5: Instalasi Aplikasi Laravel
1. Clone atau unduh repository.
2. Masuk ke direktori proyek dan jalankan `composer install`.
3. Buat file `.env` dengan menyalin dari `.env.example` menggunakan perintah `cp .env.example .env`.
4. Perbarui nama dan kredensial database di file `.env`.
5. Jalankan perintah `php artisan key:generate`.
6. Jalankan perintah `php artisan migrate --seed`.
7. Link direktori storage dengan perintah `php artisan storage:link`.
8. Anda dapat membuat virtual host atau jalankan `php artisan serve` dari root proyek dan kunjungi http://127.0.0.1:8000.

## Langkah 6: Uji Coba Aplikasi
1. Buka aplikasi di browser.
2. Lakukan registrasi user baru.
3. Login dengan user baru.
4. Pastikan fitur-fitur seperti menampilkan posts, categories, tags, comments, dan lainnya dapat digunakan.

### User Default
- User: super@admin.com
- Password: secret

### Menambahkan Demo Data
Untuk menambahkan data demo, jalankan perintah berikut:
```bash
php artisan starter:insert-demo-data
```

# Konfigurasi Email menggunakan Mailtrap.io
Untuk mengkonfigurasi layanan email pada aplikasi Laravel dan menggunakan Mailtrap.io sebagai penyedia layanan SMTP, berikut adalah langkah-langkahnya:

1. **Buat Akun Mailtrap.io**:
   - Buat akun di [Mailtrap.io](https://mailtrap.io/).
   - Dapatkan informasi kredensial SMTP yang diberikan oleh Mailtrap.io.

2. **Ubah Konfigurasi .env**:
   - Buka file `.env` pada proyek Laravel Anda.
   - Ganti atau tambahkan konfigurasi email berikut:

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

    Pastikan untuk mengganti `MAIL_USERNAME` dan `MAIL_PASSWORD` dengan nilai yang sesuai yang Anda dapatkan dari Mailtrap.io.

3. **Simpan dan Jalankan Aplikasi**:
   - Simpan perubahan pada file `.env`.
   - Jalankan perintah `php artisan config:cache` untuk meng-cache konfigurasi.

Dengan konfigurasi ini, aplikasi Laravel Anda akan menggunakan Mailtrap.io sebagai penyedia layanan email untuk keperluan pengembangan dan pengujian. Pastikan untuk mengganti nilai-nilai kredensial dengan informasi yang benar dari akun Mailtrap.io Anda.