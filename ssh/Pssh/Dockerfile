
FROM ubuntu:latest

MAINTAINER Javier garcia

#Update APT repository & Install OpenSSH
RUN apt-get update \
    && apt-get install -y openssh-server \
    && apt-get install -y ssh \
    && apt-get install -y net-tools \
    && apt-get install -y dnsutils

#Directorio necesario para la operatividad de SSH-SERVER
RUN mkdir /run/sshd


#Añadmimos una contraseña a root
RUN echo 'root:admini' | chpasswd

#Definimos el puerto como una variable de entorno
ENV PORT 22

#Modificamos el archivo de configuración para permitir el acceso a root
ADD ./sshd_config /etc/ssh/sshd_config

#expose port
EXPOSE $PORT

#Commands to be executed by default
CMD ["/usr/sbin/sshd","-D"]


#  docker run -e PORT="2121" -d -it -p 2323:2121 --name userverssh ssh_server_ubuntu

