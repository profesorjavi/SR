## Protocolo SFTP y Enjaulamiento de Usuarios

## Introducción

El protocolo **SFTP** (SSH File Transfer Protocol) es un protocolo de transferencia de archivos seguro que utiliza SSH (Secure Shell) para proporcionar autenticación y cifrado. A diferencia de FTP, que transmite datos en texto plano, SFTP asegura la transferencia de archivos mediante cifrado, lo que lo hace ideal para entornos donde la seguridad es crítica.

En esta documentación, se explicará en detalle el protocolo SFTP, su funcionamiento y cómo configurar un servidor SFTP para enjaular (chroot) a usuarios específicos que pertenecen a un grupo determinado.

---

## 1. ¿Qué es SFTP?

SFTP es un protocolo que permite la transferencia de archivos entre un cliente y un servidor de manera segura. Utiliza el puerto 22 (el mismo que SSH) y se basa en las siguientes características:

- **Cifrado**: Todos los datos, incluyendo nombres de usuario, contraseñas y archivos, se transmiten cifrados.
- **Autenticación**: Soporta autenticación mediante contraseña o clave pública/privada.
- **Funcionalidades avanzadas**: Permite operaciones como listar directorios, eliminar archivos, cambiar permisos, etc.

---

## 2. Configuración Básica de SFTP

Para utilizar SFTP, es necesario tener un servidor SSH configurado, ya que SFTP es una extensión de SSH. La mayoría de las distribuciones Linux ya incluyen un servidor SSH (como OpenSSH).

### Pasos para habilitar SFTP:

1. **Instalar OpenSSH** (si no está instalado):
   ```bash
   sudo apt update
   sudo apt install openssh-server
   ```

2. **Verificar que el servicio SSH esté activo**:
   ```bash
   sudo systemctl status ssh
   ```

3. **Conectar mediante SFTP**:
   Desde un cliente, puedes conectarte usando:
   ```bash
   sftp usuario@direccion_del_servidor
   ```

---

## 3. Enjaulamiento (Chroot) de Usuarios en SFTP

El enjaulamiento (chroot) es una técnica que restringe a un usuario a un directorio específico, impidiendo que acceda a otras partes del sistema de archivos. Esto es útil para proporcionar acceso seguro a usuarios que solo necesitan transferir archivos.

### Requisitos:

- Un grupo de usuarios específico (por ejemplo, `sftpusers`).
- Un directorio base para los usuarios enjaulados (por ejemplo, `/var/sftp`).

---

### Pasos para Configurar el Enjaulamiento:

1. **Crear un grupo para los usuarios enjaulados**:
   ```bash
   sudo groupadd sftpusers
   ```

2. **Crear un directorio base para los usuarios enjaulados**:
   ```bash
   sudo mkdir -p /var/sftp
   sudo chown root:root /var/sftp
   sudo chmod 755 /var/sftp
   ```

3. **Crear un usuario y asignarlo al grupo**:
   ```bash
   sudo useradd -m -s /usr/sbin/nologin -G sftpusers usuario1
   sudo passwd usuario1
   ```

   - `-m`: Crea el directorio home del usuario.
   - `-s /usr/sbin/nologin`: Impide que el usuario inicie sesión en el sistema.
   - `-G sftpusers`: Asigna el usuario al grupo `sftpusers`.

4. **Crear un directorio personal para el usuario dentro del directorio base**:
   ```bash
   sudo mkdir -p /var/sftp/usuario1
   sudo chown usuario1:sftpusers /var/sftp/usuario1
   sudo chmod 755 /var/sftp/usuario1
   ```

5. **Configurar SSH para enjaular a los usuarios del grupo `sftpusers`**:
   Edita el archivo de configuración de SSH (`/etc/ssh/sshd_config`):
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```

   Añade las siguientes líneas al final del archivo:
   ```bash
   Match Group sftpusers
       ChrootDirectory /var/sftp
       ForceCommand internal-sftp
       AllowTcpForwarding no
       X11Forwarding no
   ```

   - **Match Group sftpusers**: Aplica las siguientes reglas solo a los usuarios del grupo `sftpusers`.
   - **ChrootDirectory /var/sftp**: Enjaula a los usuarios en el directorio `/var/sftp`.
   - **ForceCommand internal-sftp**: Fuerza a los usuarios a usar solo SFTP.
   - **AllowTcpForwarding no**: Deshabilita el reenvío de puertos TCP.
   - **X11Forwarding no**: Deshabilita el reenvío de X11.

6. **Reiniciar el servicio SSH**:
   ```bash
   sudo systemctl restart sshd
   ```

---

## 4. Ejemplo Práctico

Supongamos que queremos enjaular a un usuario llamado `usuario1` que pertenece al grupo `sftpusers`.

### Estructura de Directorios:
```
/var/sftp/
└── usuario1/
    ├── archivo1.txt
    └── subdirectorio/
```

### Conexión del Usuario:

El usuario `usuario1` se conectará mediante SFTP:
```bash
sftp usuario1@direccion_del_servidor
```

Una vez conectado, el usuario solo podrá acceder a su directorio personal (`/var/sftp/usuario1`) y no podrá navegar fuera de este.

---

## 5. Verificación y Pruebas

- **Verificar el acceso**:
  Conéctate como `usuario1` y prueba subir y descargar archivos dentro de su directorio enjaulado.

- **Verificar el enjaulamiento**:
  Intenta acceder a directorios fuera de `/var/sftp/usuario1`. Deberías recibir un error de permisos.

---

## 6. Consideraciones de Seguridad

- **Permisos del directorio base**: El directorio base (`/var/sftp`) debe ser propiedad de `root` y tener permisos `755`.
- **Usuarios sin shell**: Los usuarios enjaulados no deben tener acceso a una shell (usa `/usr/sbin/nologin`).
- **Monitoreo**: Monitorea los logs de SSH (`/var/log/auth.log`) para detectar intentos de acceso no autorizados.

