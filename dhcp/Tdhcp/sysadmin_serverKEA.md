### Documentación para Administradores de Sistemas: Gestión de un Servidor DHCP KEA

#### Introducción
Kea DHCP es una solución moderna para la asignación dinámica de direcciones IP y otros parámetros de red. Es desarrollado por ISC (Internet Systems Consortium) y está diseñado para ser modular, rápido y flexible.

### 1. Instalación de KEA

Para instalar KEA en Ubuntu, usa:
```bash
sudo apt install kea-dhcp4-server kea-dhcp6-server
```

### 2. Archivos Involucrados

- **Archivo de configuración principal**:
   - **Ubicación**: `/etc/kea/kea-dhcp4.conf` (para IPv4) y `/etc/kea/kea-dhcp6.conf` (para IPv6).
   - **Descripción**: Aquí se definen los parámetros del servidor DHCP, incluidos los rangos de direcciones, interfaces, tiempos de concesión y opciones adicionales.

- **Base de datos de concesiones**:
   - KEA almacena concesiones en una base de datos (puede ser MySQL, PostgreSQL o una simple DB de texto plano).
   - **Ubicación por defecto**: `/var/lib/kea/kea-leases4.csv` (para IPv4) y `/var/lib/kea/kea-leases6.csv` (para IPv6) si se usa texto plano.

### 3. Gestión de Concesiones

1. **Ver concesiones actuales**:
   KEA almacena las concesiones en el archivo `kea-leases4.csv`. Puedes ver las concesiones actuales ejecutando:
   ```bash
   cat /var/lib/kea/kea-leases4.csv
   ```

2. **Renovar una concesión**:
   Para que un cliente renueve su concesión, reinicia el cliente DHCP o usa un comando como:
   ```bash
   sudo dhclient -r && sudo dhclient
   ```
    O bien, dependiendo del cliente [dhcpdc](./sysadmin_clientedhcp)

3. **Liberar concesiones desde KEA**:
   No hay un comando directo para liberar concesiones desde el servidor KEA. Sin embargo, puedes reiniciar el servidor KEA o eliminar concesiones manualmente desde la base de datos.

4. **Comandos para gestionar KEA**:
   KEA usa un servicio basado en `systemd`. Para gestionar el servidor, puedes usar:
   - Iniciar el servidor:
     ```bash
     sudo systemctl start kea-dhcp4-server
     ```
   - Detener el servidor:
     ```bash
     sudo systemctl stop kea-dhcp4-server
     ```
   - Reiniciar el servidor:
     ```bash
     sudo systemctl restart kea-dhcp4-server
     ```



### 4. Logs y Monitoreo

Los logs del servidor KEA se almacenan en `/var/log/syslog`. Para visualizar eventos recientes:
```bash
sudo tail -f /var/log/syslog
```

### 6. Utilización de la API REST de KEA

Kea permite la gestión de concesiones y configuraciones a través de su API REST. Esta API facilita la interacción con el servidor, permitiendo obtener información sobre concesiones, agregar subredes, modificar configuraciones, etc.

#### Ejemplo de uso básico:

1. **Comprobar concesiones activas**:
   Usando una herramienta como `curl`, puedes consultar las concesiones activas:
   ```bash
   curl -X POST -d '{ "command": "lease4-get", "arguments": { "ip-address": "192.168.1.101" } }' http://localhost:8080/
   ```
