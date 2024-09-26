
## `systemctl`

### ¿Qué es `systemctl`?

`systemctl` es la herramienta principal de administración de servicios en sistemas Linux que usan `systemd`. Permite iniciar, detener, reiniciar y verificar el estado de servicios. Además, es posible habilitar o deshabilitar servicios para que se inicien automáticamente durante el arranque del sistema.

### Comandos básicos de `systemctl`

1. **Iniciar un servicio:**

   ```bash
   sudo systemctl start <nombre-del-servicio>
   ```

   Ejemplo:

   ```bash
   sudo systemctl start dnsmasq
   ```

2. **Detener un servicio:**

   ```bash
   sudo systemctl stop <nombre-del-servicio>
   ```

3. **Reiniciar un servicio:**

   ```bash
   sudo systemctl restart <nombre-del-servicio>
   ```

4. **Verificar el estado de un servicio:**

   ```bash
   sudo systemctl status <nombre-del-servicio>
   ```

   Ejemplo:

   ```bash
   sudo systemctl status dnsmasq
   ```

5. **Habilitar un servicio para que se inicie automáticamente al arrancar el sistema:**

   ```bash
   sudo systemctl enable <nombre-del-servicio>
   ```

6. **Deshabilitar un servicio:**

   ```bash
   sudo systemctl disable <nombre-del-servicio>
   ```

---

### Ejemplo 1: Crear un servicio personalizado

Para crear un servicio personalizado con `systemctl`, necesitas crear un archivo de servicio en `/etc/systemd/system/`. Supongamos que tienes un script que quieres ejecutar como un servicio. 

#### Paso 1: Crear el archivo de servicio

1. Crea un archivo de servicio en `/etc/systemd/system/mi-servicio.service`:

   ```bash
   sudo nano /etc/systemd/system/mi-servicio.service
   ```

2. Añade el siguiente contenido al archivo:

   ```ini
   [Unit]
   Description=Mi Servicio Personalizado
   After=network.target

   [Service]
   ExecStart=/usr/local/bin/mi-script.sh
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

   Explicación:
   - `After=network.target`: Asegura que el servicio se inicie después de que la red esté levantada.
   - `ExecStart`: Comando que ejecuta el servicio.
   - `Restart=always`: Se reinicia automáticamente si el servicio falla.

3. Guarda el archivo y recarga el daemon de `systemd`:

   ```bash
   sudo systemctl daemon-reload
   ```

4. Habilita el servicio:

   ```bash
   sudo systemctl enable mi-servicio
   ```

5. Inicia el servicio:

   ```bash
   sudo systemctl start mi-servicio
   ```

---

### Ejemplo 2: Retrasar el inicio de `dnsmasq` hasta que ambas interfaces de red estén levantadas

#### Paso 1: Identificar las interfaces de red

Usa el comando `ip link` para identificar los nombres de tus interfaces de red. Supongamos que las interfaces se llaman `eth0` y `eth1`.

```bash
ip link
```

#### Paso 2: Crear una unidad de servicio personalizada para `dnsmasq`

1. Abre o crea un archivo de servicio personalizado para `dnsmasq`:

   ```bash
   sudo nano /etc/systemd/system/dnsmasq.service.d/delay-start.conf
   ```

   Si la carpeta `dnsmasq.service.d` no existe, créala con:

   ```bash
   sudo mkdir -p /etc/systemd/system/dnsmasq.service.d/
   ```

2. Añade el siguiente contenido:

   ```ini
   [Unit]
   Description=Retrasar inicio de dnsmasq hasta que ambas interfaces de red estén levantadas
   After=network-online.target
   Wants=network-online.target

   [Service]
   ExecStartPre=/bin/bash -c 'until ip link show eth0 | grep "state UP" && ip link show eth1 | grep "state UP"; do sleep 1; done'
   ```

   Explicación:
   - `After=network-online.target`: Asegura que el servicio `dnsmasq` no se inicie hasta que la red esté en línea.
   - `ExecStartPre`: Un script que espera hasta que ambas interfaces `eth0` y `eth1` estén activas (con `state UP`) antes de iniciar `dnsmasq`.

3. Guarda el archivo y recarga el daemon de `systemd`:

   ```bash
   sudo systemctl daemon-reload
   ```

4. Reinicia y habilita el servicio `dnsmasq`:

   ```bash
   sudo systemctl restart dnsmasq
   sudo systemctl enable dnsmasq
   ```

Este ajuste asegura que `dnsmasq` solo se inicie cuando ambas interfaces estén levantadas.

---

### Otras opciones útiles de `systemctl`

- **Listar todos los servicios:** 

  ```bash
  systemctl list-units --type=service
  ```

- **Ver logs de un servicio:**

  ```bash
  journalctl -u <nombre-del-servicio>
  ```

  Ejemplo:

  ```bash
  journalctl -u dnsmasq
  ```

- **Recargar la configuración sin reiniciar el servicio:**

  ```bash
  sudo systemctl reload <nombre-del-servicio>
  ```
