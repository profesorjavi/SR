En **Ubuntu Server 24.04 (Noble)**, el resolutor de nombres (DNS) es el componente que se encarga de convertir los nombres de dominio (como `example.com`) en direcciones IP que las máquinas pueden entender para conectarse a servicios en red.

Ubuntu utiliza **systemd-resolved** como su principal servicio de resolución de nombres. Este servicio gestiona las peticiones de DNS y otras consultas relacionadas con nombres en el sistema.

### Componentes Clave del Resolutor DNS en Ubuntu Server 24.04

1. **systemd-resolved**:
   - Es un servicio de resolución de nombres integrado en **systemd** que maneja la resolución DNS para el sistema. También gestiona el DNS sobre TLS (DoT), proporcionando seguridad en la resolución de nombres.
   - Este servicio escucha en interfaces de red configuradas y reenvía las consultas DNS a los servidores DNS configurados (normalmente se configuran en el archivo `/etc/systemd/resolved.conf` o de forma dinámica, por ejemplo, desde una configuración DHCP).

2. **Archivo `/etc/systemd/resolved.conf`**:
   - Aquí se configuran las opciones globales para systemd-resolved. Algunos parámetros incluyen:
     - `DNS=`: Define los servidores DNS a los que el sistema enviará las consultas.
     - `FallbackDNS=`: Servidores DNS secundarios a los que recurrir si los primarios fallan.
     - `DNSStubListener=`: Habilita o deshabilita el servicio de DNS en el puerto 53 de localhost.
   
   Ejemplo de configuración básica:
   ```ini
   [Resolve]
   DNS=8.8.8.8 8.8.4.4
   FallbackDNS=1.1.1.1 1.0.0.1
   DNSStubListener=yes
   ```

3. **`/etc/hosts`**:
   - Antes de recurrir a un servidor DNS, el sistema consulta este archivo, que mapea nombres de host directamente a direcciones IP. Es útil para resoluciones rápidas de nombres locales o personalizados.

4. **`/etc/nsswitch.conf`**:
   - Este archivo determina el orden en que se consultan los diferentes servicios de resolución de nombres. Por ejemplo, puede configurarse para que consulte primero el archivo `/etc/hosts`, luego los servidores DNS:
   ```ini
   hosts: files dns
   ```

5. **DNSMasq o Unbound (opcional)**:
   - En algunos entornos, se puede usar **dnsmasq** o **unbound** como servidores de caché de DNS locales, proporcionando consultas más rápidas y eficientes.
   
6. **NetworkManager** (en algunos servidores con entorno gráfico o configuración de red avanzada):
   - Aunque es más común en sistemas de escritorio, si está instalado, NetworkManager puede gestionar la configuración de red, incluyendo el DNS.

### Flujos de Resolución DNS

1. **Consulta Local**:
   El sistema primero busca en el archivo `/etc/hosts`. Si el nombre de dominio o host no está definido allí, pasa a consultar a los servidores DNS definidos en **systemd-resolved**.

2. **Resolución en systemd-resolved**:
   Si no se encuentra en el archivo `/etc/hosts`, **systemd-resolved** reenvía la consulta al servidor DNS configurado. La respuesta se almacena en caché por un tiempo, para futuras consultas.

3. **Cacheo de Respuestas**:
   **systemd-resolved** almacena en caché las respuestas DNS para evitar consultas repetitivas a los servidores DNS y acelerar la resolución de nombres.

### Verificación del Estado de systemd-resolved

Puedes verificar el estado del servicio con el siguiente comando:

```bash
systemctl status systemd-resolved
```

También puedes revisar las configuraciones actuales de DNS ejecutando:

```bash
resolvectl status
```

Esto te mostrará detalles como los servidores DNS activos y el estado de la caché.

### Archivo `/etc/resolv.conf`

En Ubuntu Server 24.04, este archivo es un enlace simbólico a **systemd-resolved** (a `/run/systemd/resolve/stub-resolv.conf`). Muestra el DNS local (`127.0.0.53`), que es gestionado por el servicio de **systemd-resolved**. Si necesitas usar servidores DNS específicos o desactivar este comportamiento, puedes modificar el archivo o usar `resolvectl` para configuraciones temporales.

### Configuraciones Avanzadas

Para cambiar el comportamiento de **systemd-resolved** para que use, por ejemplo, un servidor DNS específico solo en ciertas interfaces de red o dominios de búsqueda, puedes configurar esas opciones usando las herramientas de **networkd** o directamente en los archivos de configuración.

Cuando configuras un servidor DNS como **BIND9** en Ubuntu Server (por ejemplo, en Ubuntu 24.04), debes asegurarte de que no haya conflicto de puertos entre **BIND9** y el servicio **systemd-resolved**, que también utiliza el puerto 53 para consultas DNS locales. Para que ambos puedan coexistir correctamente, se recomienda ajustar las configuraciones de modo que BIND9 maneje el DNS completo, mientras que **systemd-resolved** use un puerto distinto o esté desactivado para consultas locales.

### Pasos para configurar el resolutor y evitar el solapamiento de puertos:

1. **Desactivar el listener en `systemd-resolved`**:
   Por defecto, **systemd-resolved** escucha en `127.0.0.53:53`, lo que puede causar un conflicto con BIND9, ya que ambos querrán usar el puerto 53. Puedes deshabilitar este comportamiento de **systemd-resolved**.

   - Edita el archivo de configuración de **systemd-resolved**:
     ```bash
     sudo nano /etc/systemd/resolved.conf
     ```

   - Busca la opción `DNSStubListener` y deshabilítala (cámbiala a `no`):
     ```ini
     [Resolve]
     DNSStubListener=no
     ```

   - Guarda y cierra el archivo.

   - Reinicia el servicio **systemd-resolved** para aplicar los cambios:
     ```bash
     sudo systemctl restart systemd-resolved
     ```

   Con esta configuración, **systemd-resolved** ya no escuchará en el puerto 53, liberando el puerto para que BIND9 lo utilice.

2. **Configurar Servidor DNSMASQ - BIND9**:
   

3. **Actualizar `/etc/resolv.conf` para usar DNSMASQ/BIND9 como el DNS principal**:
   El archivo `/etc/resolv.conf` contiene la dirección del servidor DNS que el sistema utiliza para resolver nombres de dominio. Asegúrate de que está configurado para usar BIND9.

   - Verifica si `/etc/resolv.conf` está enlazado a **systemd-resolved**. Si es así, primero remueve el enlace:
     ```bash
     sudo rm /etc/resolv.conf
     ```

   - Luego, crea un nuevo archivo `/etc/resolv.conf` y añade la dirección de tu servidor BIND9 (normalmente `127.0.0.1` si BIND está corriendo localmente):
     ```bash
     sudo nano /etc/resolv.conf
     ```

   - Añade la siguiente línea:
     ```ini
     nameserver 127.0.0.1
     ```

   - Guarda y cierra el archivo.

4. **Verificar que BIND9 esté funcionando correctamente**:
   Puedes probar la configuración resolviendo algún dominio a través de `dig` o `nslookup` para asegurarte de que las consultas DNS son manejadas por BIND9.

   - Prueba una consulta DNS con `dig`:
     ```bash
     dig google.com
     ```

   - También puedes verificar el estado de **BIND9**:
     ```bash
     sudo systemctl status bind9
     ```

5. **(Opcional) Cacheo de DNS con BIND9**:
   Si quieres que BIND9 también almacene en caché las respuestas DNS para consultas repetidas, puedes habilitar el cacheo por defecto con BIND. Esto es útil en servidores que atienden muchas peticiones o en redes locales.

---

### Resumen:

1. **systemd-resolved** debe configurarse para que no escuche en el puerto 53 (`DNSStubListener=no`).
2. BIND9 debe configurarse como el servidor DNS principal y asegurarse de que está escuchando en `127.0.0.1:53` o en las interfaces que necesitas.
3. El archivo `/etc/resolv.conf` debe apuntar al servidor BIND9 (`127.0.0.1`).
4. Verifica que las resoluciones de nombres funcionan correctamente usando herramientas como `dig` o `nslookup`.

De esta manera, BIND9 se encarga de la resolución DNS completa, mientras que **systemd-resolved** no genera conflictos en el puerto 53.