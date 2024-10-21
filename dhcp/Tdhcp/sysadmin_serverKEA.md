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

3. **Liberar concesiones**:
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

### 4. Configuración Básica del Servidor DHCP KEA

El archivo de configuración `/etc/kea/kea-dhcp4.conf` tiene una estructura JSON. Aquí puedes configurar rangos de direcciones, opciones como la puerta de enlace predeterminada y los servidores DNS.

Ejemplo básico de configuración:

```json
{
    "Dhcp4": {
        "interfaces-config": {
            "interfaces": [ "eth0" ]
        },
        "lease-database": {
            "type": "memfile",
            "persist": true,
            "name": "/var/lib/kea/kea-leases4.csv"
        },
        "subnet4": [
            {
                "subnet": "192.168.1.0/24",
                "pools": [ { "pool": "192.168.1.100 - 192.168.1.200" } ],
                "option-data": [
                    { "name": "routers", "data": "192.168.1.1" },
                    { "name": "domain-name-servers", "data": "8.8.8.8, 8.8.4.4" }
                ]
            }
        ]
    }
}
```

### 5. Logs y Monitoreo

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

2. **Agregar una nueva subred**:
   Puedes agregar nuevas subredes dinámicamente mediante la API REST.
