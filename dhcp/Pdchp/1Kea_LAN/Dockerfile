# última versión de alpine a fecha de 2023-24-10
FROM ubuntu:23.10

LABEL version="20232410"
LABEL maintainer="profesorjavi"

# instalación de bind9
RUN	apt update \
	&& apt install -y kea-dhcp4-server \
	&& rm -rf /var/lib/apt/lists/*

#https://stackoverflow.com/questions/60525106/kea-dhcp4-server-doesnt-work-after-a-restart-of-the-raspberry
RUN mkdir -p  /var/run/kea/
RUN mkdir -p /var/lib/kea/

# Copio los archivos de configuración base.
COPY kea-dhcp4.conf /etc/kea/kea-dhcp4.conf

# Exponemos los puertos que utiliza kea(DHCP)
# EXPOSE 67 67/udp 

# Ejecuta el comando para lanzar el servicio
CMD ["kea-dhcp4", "-c", "/etc/kea/kea-dhcp4.conf"]

