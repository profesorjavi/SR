### Documentación para Administradores de Sistemas: Gestión de un Servidor DHCP con DNSMASQ

#### Introducción
`dnsmasq` es una herramienta ligera que proporciona servicios de DNS, DHCP, y TFTP. Es ideal para entornos pequeños, como redes domésticas o de pequeñas oficinas, y permite una configuración rápida y sencilla.

---

### 1. Instalación de DNSMASQ

Para instalar `dnsmasq` en Ubuntu:
```bash
sudo apt install dnsmasq
```

---

### 2. Archivos Involucrados

- **Archivo de configuración principal**:
   - **Ubicación**: `/etc/dnsmasq.conf`
   - **Descripción**: Configura tanto los servicios de DNS como los de DHCP. Aquí puedes definir los rangos de IP, interfaces de red, nombres de dominio, y tiempos de concesión.

- **Archivo de concesiones**:
   - **Ubicación**: `/var/lib/misc/dnsmasq.leases`
   - **Descripción**: Guarda la información de las concesiones DHCP activas.

---

### 3. Configuración Básica del Servidor DHCP

En el archivo de configuración `/etc/dnsmasq.conf`, se definen los parámetros para el servicio DHCP.

Ejemplo básico para DHCP:
```conf
# Interfaz de red
interface=eth0

# Rango de direcciones IP
dhcp-range=192.168.1.100,192.168.1.150,12h

# Puerta de enlace predeterminada
dhcp-option=3,192.168.1.1

# Servidor DNS
dhcp-option=6,8.8.8.8,8.8.4.4
```

### 4. Gestión de Concesiones DHCP

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

### 5. Logs y Depuración

Los logs de `dnsmasq` se almacenan en `/var/log/syslog`. Para ver mensajes específicos del servicio, puedes ejecutar:
```bash
sudo tail -f /var/log/syslog | grep dnsmasq
```

---

### 6. Configuración Avanzada

`dnsmasq` también permite configuraciones más avanzadas, como la asignación de IPs estáticas por dirección MAC, múltiples rangos de DHCP, o integración con servidores DNS externos.

Ejemplo de asignación estática:
```conf
dhcp-host=00:11:22:33:44:55,192.168.1.200
```

---

### 7. Reinicio del Servidor DNSMASQ

Para aplicar cualquier cambio o en caso de problemas con el servicio DHCP o DNS, utiliza los siguientes comandos:
- **Iniciar el servicio**:
  ```bash
  sudo systemctl start dnsmasq
  ```

- **Detener el servicio**:
  ```bash
  sudo systemctl stop dnsmasq
  ```

- **Reiniciar el servicio**:
  ```bash
  sudo systemctl restart dnsmasq
  ```
