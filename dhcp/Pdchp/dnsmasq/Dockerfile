# última versión de alpine a fecha de 2023-24-10
FROM ubuntu:23.10

LABEL version="20232410"
LABEL maintainer="profesorjavi"

# instalación de dnsmasq
RUN	apt update \
	&& apt install -y dnsmasq \
	&& rm -rf /var/lib/apt/lists/*



# Copio los archivos de configuración base.
COPY dnsmasq.conf /etc/dnsmasq.conf

# Exponemos los puertos que utiliza kea(DHCP)
# EXPOSE 67 67/udp 
 EXPOSE 53 53/udp

# Ejecuta el comando para lanzar el servicio
CMD  ["/usr/sbin/dnsmasq", "-k"]