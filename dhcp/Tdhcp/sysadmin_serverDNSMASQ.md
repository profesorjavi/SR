### Documentación para Administradores de Sistemas: Gestión de un Servidor DHCP con DNSMASQ

#### Introducción
`dnsmasq` es una herramienta ligera que proporciona servicios de DNS, DHCP, y TFTP. Es ideal para entornos pequeños, como redes domésticas o de pequeñas oficinas, y permite una configuración rápida y sencilla.


### 1. Archivos Involucrados

- **Archivo de configuración principal**:
   - **Ubicación**: `/etc/dnsmasq.conf`
   - **Descripción**: Configura tanto los servicios de DNS como los de DHCP. Aquí puedes definir los rangos de IP, interfaces de red, nombres de dominio, y tiempos de concesión.

- **Archivo de concesiones**:
   - **Ubicación**: `/var/lib/misc/dnsmasq.leases`
   - **Descripción**: Guarda la información de las concesiones DHCP activas.




### 2. Gestión de Concesiones DHCP

1. **Ver concesiones actuales**:
   Las concesiones se almacenan en el archivo `/var/lib/misc/dnsmasq.leases`. Puedes ver las concesiones actuales ejecutando:
   ```bash
   cat /var/lib/misc/dnsmasq.leases
   ```

2. **Reiniciar el servicio**:
   Después de cambiar configuraciones o para forzar nuevas concesiones, reinicia el servicio:
   ```bash
   sudo systemctl restart dnsmasq
   ```

3. **Liberar concesiones manualmente**:
   Puedes eliminar entradas del archivo de concesiones para liberar una dirección IP. Después, reinicia `dnsmasq` para aplicar los cambios.

### 3. Logs y Depuración

Los logs de `dnsmasq` se almacenan en `/var/log/syslog`. Para ver mensajes específicos del servicio, puedes ejecutar:
```bash
sudo tail -f /var/log/syslog | grep dnsmasq
```