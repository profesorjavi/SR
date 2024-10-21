### Documentación para Administradores de Sistemas: Gestión de DHCP desde el Cliente

#### Introducción
El comando `dhcpcd` es una herramienta para gestionar las configuraciones de red de un cliente mediante DHCP (Dynamic Host Configuration Protocol). Este documento describe cómo los administradores de sistemas pueden interactuar con los servidores DHCP desde el cliente usando `dhcpcd`, los ficheros relevantes involucrados y las mejores prácticas para gestionar las concesiones.

---

### 1. Comando `dhcpcd`

`dhcpcd` es el cliente DHCP que solicita, configura y gestiona dinámicamente direcciones IP y otros parámetros de red desde un servidor DHCP. Además, se encarga de renovar y liberar las concesiones de IP cuando es necesario.

#### Sintaxis básica:
```bash
dhcpcd [opciones] [interfaz]
```
Donde `interfaz` es la tarjeta de red (ej. `eth0` o `wlan0`).

---

### 2. Parámetros Principales

- **Renovar concesión**: 
   - `dhcpcd -n`: Renueva la concesión actual sin reiniciar la interfaz.
   
- **Liberar concesión**: 
   - `dhcpcd -k`: Libera la concesión IP actual.

- **Forzar IPv4 o IPv6**:
   - `dhcpcd -4`: Solo usa IPv4.
   - `dhcpcd -6`: Solo usa IPv6.

- **Ejecutar en modo silencioso**:
   - `dhcpcd -q`: Reduce la salida de mensajes.

---

### 3. Archivos Involucrados

#### 3.1 Archivo de concesiones:
- **Ubicación**: `/var/lib/dhcpcd/dhcpcd-[interfaz].lease`
- **Descripción**: Contiene información sobre las concesiones IP obtenidas desde el servidor DHCP para cada interfaz. Aquí se almacenan los detalles como dirección IP, tiempo de concesión, etc.

#### 3.2 Archivo de configuración:
- **Ubicación**: `/etc/dhcpcd.conf`
- **Descripción**: Configuración principal de `dhcpcd`. Aquí se pueden definir reglas personalizadas, parámetros específicos de interfaces y ajustes como tiempos de concesión o rutas predeterminadas.

---

### 4. Gestión de Concesiones DHCP

1. **Ver concesiones actuales**:
   El archivo `/var/lib/dhcpcd/dhcpcd-[interfaz].lease` muestra la concesión activa para una interfaz.
   ```bash
   cat /var/lib/dhcpcd/dhcpcd-[interfaz].lease
   ```

2. **Renovar una concesión**:
   Para solicitar una nueva concesión de IP sin reiniciar la interfaz, usa el siguiente comando:
   ```bash
   sudo dhcpcd -n
   ```

3. **Liberar una concesión**:
   Si quieres liberar la concesión y eliminar la dirección IP asignada por DHCP:
   ```bash
   sudo dhcpcd -k
   ```

4. **Reiniciar `dhcpcd`**:
   Para reiniciar el cliente DHCP y solicitar una nueva concesión, ejecuta:
   ```bash
   sudo dhcpcd
   ```

---

### 5. Logs de DHCP

Para verificar cualquier problema o la actividad de `dhcpcd`, puedes revisar los logs del sistema:

```bash
sudo journalctl -u dhcpcd
```

---

### 6. Mejoras en la Configuración

El archivo de configuración `/etc/dhcpcd.conf` permite ajustes como:
- Reservar direcciones IP estáticas para dispositivos específicos.
- Configurar tiempos de concesión personalizados.

Ejemplo de asignación de una IP fija por dirección MAC:
```conf
interface eth0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8
```

--