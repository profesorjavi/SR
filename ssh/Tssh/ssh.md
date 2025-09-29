
# Acceso y Administración Remota en Sistemas

## 1. Introducción
En este documento aprenderás a:
- Acceder y administrar sistemas remotamente en modo texto y gráfico.
- Instalar y configurar servicios de acceso remoto.
- Configurar y gestionar accesos mediante SSH y VNC.
- Crear túneles con SSH para la transmisión segura de datos.
- Evaluar las ventajas y desventajas de cada método.

**Plataforma de trabajo**: Ubuntu Server

---

## 2. Acceso a Sistemas: Terminales en Modo Texto

### 2.1. ¿Qué es el modo texto?
El modo texto o terminal (CLI, Command Line Interface) es una forma eficiente de interactuar con un sistema sin necesidad de una interfaz gráfica, ideal para administrar servidores de forma remota.

### 2.2. SSH: Acceso Remoto en Modo Texto
**SSH (Secure Shell)** es el protocolo estándar y más seguro para acceder y administrar sistemas de manera remota a través de una terminal.

#### Instalación y uso de SSH en Ubuntu Server:
1. Instalar el servicio SSH en el servidor:
   ```bash
   sudo apt update
   sudo apt install openssh-server
   ```
2. Verificar el estado del servicio:
   ```bash
   sudo systemctl status ssh
   ```
3. Conectar desde otro sistema (cliente):
   ```bash
   ssh usuario@ip_servidor
   ```

### 2.3. Configuración avanzada de SSH
SSH permite una gran personalización para incrementar la seguridad de tus servidores.

#### Configuración del archivo `sshd_config`:
El archivo de configuración principal se encuentra en `/etc/ssh/sshd_config`. Aquí puedes definir parámetros clave como:

- **Control de acceso de usuarios**: Para restringir qué usuarios pueden conectarse mediante SSH, añade la siguiente línea al archivo:
  ```bash
  AllowUsers usuario1 usuario2
  ```
- **comprobar cambios aplicados**: 
 te está mostrando la configuración efectiva después de aplicar todo (/etc/ssh/sshd_config
```bash
  sshd -T
  ```

- **Cambio del puerto por defecto (22)**: Cambiar el puerto por defecto es una medida de seguridad básica.
  ```bash
  Port 2200
  ```


Recuerda reiniciar el servicio después de realizar cambios:
```bash
sudo systemctl restart ssh
```

#### Autenticación mediante clave pública/privada
Usar claves SSH en lugar de contraseñas mejora la seguridad. Para configurarlo:

1. Generar un par de claves en el cliente:
   ```bash
   ssh-keygen -t rsa
   ```
2. Copiar la clave pública al servidor:
   ```bash
   ssh-copy-id usuario@ip_servidor
   ```
3. Ahora podrás conectarte sin necesidad de contraseña:
   ```bash
   ssh usuario@ip_servidor
   ```

### 2.4. Túneles SSH
SSH también permite crear túneles para transmitir datos de forma segura. Algunos tipos de túneles son:

- **Túnel local**: Redirige el tráfico local a través del servidor remoto.
   ```bash
   ssh -L 8080:localhost:80 usuario@ip_servidor
   ```
- **Túnel remoto**: Permite acceder a un puerto local del cliente desde el servidor remoto.
   ```bash
   ssh -R 8080:localhost:80 usuario@ip_servidor
   ```

---

## 3. Acceso a Sistemas: Terminales en Modo Gráfico

### 3.1. VNC: Acceso Remoto en Modo Gráfico
**VNC (Virtual Network Computing)** permite acceder a la interfaz gráfica de un sistema remoto. Esto es útil para gestionar visualmente el sistema en lugar de hacerlo mediante comandos de terminal.

#### Instalación de VNC en Ubuntu Server:
1. Instalar VNC:
   ```bash
   sudo apt update
   sudo apt install tightvncserver
   ```
2. Configurar el servidor VNC y crear una contraseña:
   ```bash
   vncserver
   ```
3. Para conectarte, puedes usar un cliente VNC como **Remmina** (en Ubuntu) o **RealVNC** (en otros sistemas).

### 3.2. AnyDesk
Aquí tienes la descripción del nuevo punto sobre **AnyDesk**:

---

### 3.2. AnyDesk: Acceso Remoto en Modo Gráfico

**AnyDesk** es una herramienta de acceso remoto que permite conectarse y controlar otros equipos a través de su interfaz gráfica, similar a VNC pero con características adicionales como velocidad optimizada y facilidad de uso. AnyDesk es multiplataforma, lo que significa que se puede usar tanto en sistemas Linux, Windows, macOS, y otros.

#### Instalación de AnyDesk en Ubuntu Server:
1. Descarga e instala AnyDesk en Ubuntu Server:
   ```bash
   wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
   echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
   sudo apt update
   sudo apt install anydesk
   ```

2. Una vez instalado, puedes iniciar AnyDesk en el servidor y obtener el número de acceso único para ese equipo.

#### Conexión y uso:
- **Desde otro equipo**: Instala AnyDesk en tu máquina cliente (por ejemplo, un ordenador Windows o Mac), e ingresa el número de acceso del servidor Ubuntu.
- Puedes establecer una conexión segura y comenzar a interactuar con el escritorio del servidor de manera gráfica, como si estuvieras físicamente frente a él.

#### Ventajas de AnyDesk:
- **Bajo consumo de ancho de banda**: AnyDesk está optimizado para conexiones de baja latencia, lo que lo hace ideal para conexiones remotas rápidas incluso en redes lentas.
- **Multiplataforma**: Compatible con diferentes sistemas operativos, facilitando la administración remota entre sistemas de distinta naturaleza.
- **Transferencia de archivos**: Permite arrastrar y soltar archivos entre el cliente y el servidor de manera sencilla.


#### Crear un túnel SSH para VNC:
El acceso remoto a VNC se puede asegurar mediante un túnel SSH para evitar que el tráfico viaje sin cifrar por la red. Para ello, ejecuta lo siguiente en tu máquina cliente:
   ```bash
   ssh -L 5901:localhost:5901 usuario@ip_servidor
   ```
Esto redirigirá el puerto del VNC a través de una conexión segura de SSH.

---

## 4. Pruebas entre Sistemas de Distinta Naturaleza

Para comprobar el funcionamiento del acceso remoto entre sistemas de distinta naturaleza (por ejemplo, entre Linux y Windows), puedes realizar pruebas de acceso utilizando un cliente SSH o VNC en un sistema Windows y conectándote a un servidor Ubuntu. Los clientes más utilizados para estos fines en Windows son:
- **PuTTY** para SSH.
- **RealVNC** o **TightVNC** para acceso gráfico.

Realiza pruebas y verifica las configuraciones para comparar el rendimiento y la facilidad de uso entre distintos sistemas operativos.

---

## 5. Evaluación de Métodos: Ventajas y Desventajas

### 5.1. SSH (Modo Texto)
- **Ventajas**:
  - Ligero y rápido.
  - Seguro gracias al cifrado de extremo a extremo.
  - Personalizable y flexible.
- **Desventajas**:
  - No ofrece una interfaz visual.
  - Requiere conocimientos de línea de comandos.

### 5.2. VNC (Modo Gráfico)
- **Ventajas**:
  - Ofrece acceso visual al escritorio remoto.
  - Más intuitivo para usuarios que no dominan la terminal.
- **Desventajas**:
  - Consume más recursos que SSH.
  - Menos seguro sin túneles SSH.
