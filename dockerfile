# Usar la imagen base de PHP 7.3.5 con Apache
FROM php:7.3.5-apache

# Copiar el listado de recursos corregido en el contenedor.
# Esto es importante para la ejecución de comandos en Debian stretch.
COPY bin/sources.list /etc/apt/sources.list

# Instalar dependencias requeridas para las extensiones de PHP
RUN apt-get update && \
    apt-get install -y \
        git \
        libzip-dev \
        zlib1g-dev \
        zip \
        unzip \
        nano

# Instalar y habilitar la extensión ZIP para PHP
RUN docker-php-ext-install zip

# Limpiar el cache de APT para reducir el tamaño de la imagen
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Definir 'ServerName' como 'localhost'.
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Configurar el directorio de trabajo en el contenedor
WORKDIR /var/www/html

# Copiar el código de la aplicación al directorio de trabajo
COPY ./app/src/ /var/www/html/

# Configurar permisos adecuados para el directorio de la aplicación
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Exponer el puerto 80 para acceder a Apache
EXPOSE 80
