# Utilisation d'une image de base avec PHP et Apache
# FROM php:7.4-apache
FROM php:8.0-apache
# Installation des dépendances nécessaires pour Laravel
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install zip pdo pdo_mysql \
    && a2enmod rewrite

# Définition du répertoire de travail
WORKDIR /var/www/html

# Copie du code source de Laravel dans le conteneur
COPY . /var/www/html/

# Installation des dépendances de composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction --no-scripts --prefer-dist

# Configuration d'Apache pour Laravel
# COPY docker/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY ./vhost.conf /etc/apache2/sites-available/000-default.conf

# Définition des variables d'environnement pour Laravel
ENV APP_KEY=base64:Ldt4y4PzFjEocJgD5p5ukSia5LHdJG80j6fzd+pXzjg=
ENV APP_ENV=local
ENV APP_DEBUG=true
ENV APP_URL=http://localhost

# Exposition du port 80 pour l'accès à l'application web
EXPOSE 80

# Commande de démarrage du conteneur
CMD ["apache2-foreground"]
