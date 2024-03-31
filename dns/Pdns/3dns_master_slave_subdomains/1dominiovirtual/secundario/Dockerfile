# última versión de alpine a fecha de 2023-10-03
FROM alpine:3.18.4

LABEL version="20231003"
LABEL maintainer="profesorjavi"

# instalación de bind9
RUN apk update && apk add bind && rm -rf /var/cache/apt/*


# Copio los archivos de configuración base. Utilizo mas de los proporcionados en alpine como base
COPY conf/ /etc/bind

# Necesita este directorio con permisos para la operatividad
RUN mkdir -p /var/named
RUN chown -R named /var/named


#Crear un volumen en el anfitrión /var/lib/docker/volumes/ para poder realizar
# pruebas modificando los archivos de configuración
VOLUME /etc/bind

# Exponemos los puertos que utiliza bind9(DNS) 
EXPOSE 53/tcp 53/udp

# Ejecuta el comando, el usuario named
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "named"]

