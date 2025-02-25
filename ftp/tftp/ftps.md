# Protocolo FTPS Explícito

## Introducción

El protocolo **FTPS** (FTP Secure) es una extensión segura del protocolo FTP (File Transfer Protocol) que utiliza cifrado SSL/TLS para proteger la transferencia de datos. FTPS puede operar en dos modos: **implícito** y **explícito**. En este documento, nos centraremos en el modo **explícito**, que es el más utilizado y recomendado debido a su flexibilidad y compatibilidad.

---

## 1. ¿Qué es FTPS Explícito?

FTPS explícito es un modo de operación en el que el cliente FTP inicia una conexión no cifrada al servidor y luego negocia explícitamente el uso de SSL/TLS para cifrar la conexión. Esto se hace mediante el comando `AUTH TLS` o `AUTH SSL`.

### Características Clave:

- **Negociación explícita**: El cliente y el servidor negocian el uso de SSL/TLS después de establecer la conexión inicial.
- **Puerto estándar**: Utiliza el puerto 21 (el mismo que FTP no seguro) para la conexión inicial.
- **Cifrado opcional**: Permite conexiones no cifradas si el cliente no solicita cifrado.

---

## 2. Componentes Técnicos de FTPS Explícito

### 2.1. SSL/TLS en FTPS

FTPS utiliza SSL/TLS para cifrar tanto el canal de control como el canal de datos. Esto incluye:

- **Canal de control**: Usado para enviar comandos y recibir respuestas.
- **Canal de datos**: Usado para transferir archivos y listar directorios.

### 2.2. Comandos FTPS Explícitos

- **AUTH TLS**: Solicita al servidor que inicie una sesión TLS en el canal de control.
- **AUTH SSL**: Similar a `AUTH TLS`, pero utiliza SSL en lugar de TLS (menos común).
- **PBSZ**: Establece el tamaño del buffer de protección (debe ser 0 para FTPS).
- **PROT**: Define el nivel de protección para el canal de datos:
  - `PROT C`: Canal de datos no cifrado (clear).
  - `PROT P`: Canal de datos cifrado (private).

---

## 3. Flujo de una Conexión FTPS Explícita

1. **Conexión inicial**:
   - El cliente se conecta al servidor FTPS en el puerto 21.
   - El servidor responde con un banner de bienvenida.

2. **Negociación de SSL/TLS**:
   - El cliente envía el comando `AUTH TLS` o `AUTH SSL`.
   - El servidor responde con un certificado SSL/TLS y establece una conexión cifrada.

3. **Autenticación**:
   - El cliente envía su nombre de usuario y contraseña a través del canal cifrado.

4. **Configuración del canal de datos**:
   - El cliente envía `PBSZ 0` para establecer el tamaño del buffer de protección.
   - El cliente envía `PROT P` para cifrar el canal de datos.

5. **Transferencia de archivos**:
   - El cliente y el servidor intercambian archivos y comandos a través de los canales cifrados.

---

## 4. Configuración de un Servidor FTPS Explícito

### 4.1. Requisitos

- **Servidor FTP**: Como vsftpd (Very Secure FTP Daemon) o ProFTPD.
- **Certificado SSL/TLS**: Un certificado válido para el servidor.

### 4.2. Configuración en vsftpd

1. **Instalar vsftpd**:
   ```bash
   sudo apt update
   sudo apt install vsftpd
   ```

2. **Generar un certificado SSL/TLS**:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt
   ```

3. **Configurar vsftpd**:
   Edita el archivo de configuración (`/etc/vsftpd.conf`):
   ```bash
   sudo nano /etc/vsftpd.conf
   ```

   Añade o modifica las siguientes líneas:
   ```bash
   # Habilitar FTPS explícito
   ssl_enable=YES
   allow_anon_ssl=NO
   force_local_data_ssl=YES
   force_local_logins_ssl=YES
   ssl_tlsv1=YES
   ssl_sslv2=NO
   ssl_sslv3=NO

   # Ruta del certificado y clave
   rsa_cert_file=/etc/ssl/certs/vsftpd.crt
   rsa_private_key_file=/etc/ssl/private/vsftpd.key
   ```

4. **Reiniciar vsftpd**:
   ```bash
   sudo systemctl restart vsftpd
   ```

---

## 5. Conexión desde un Cliente FTPS

### 5.1. Usando `lftp` (Linux)

```bash
lftp -u usuario,contraseña -e "set ftp:ssl-protect-data true; set ftp:ssl-force true;" ftps://direccion_del_servidor
```

### 5.2. Usando FileZilla (Windows/Linux/macOS)

1. Abre FileZilla y ve a **Archivo > Administrador de sitios**.
2. Crea un nuevo sitio y selecciona **FTPS - FTP sobre TLS explícito**.
3. Especifica la dirección del servidor, el puerto (21), el nombre de usuario y la contraseña.
4. Conéctate y acepta el certificado del servidor.

---

## 6. Consideraciones de Seguridad

- **Certificados válidos**: Utiliza certificados SSL/TLS emitidos por una autoridad de certificación (CA) confiable.
- **Deshabilitar SSLv2/SSLv3**: Estos protocolos son inseguros y deben deshabilitarse.
- **Protección del canal de datos**: Asegúrate de que el canal de datos esté cifrado (`PROT P`).
- **Monitoreo**: Revisa los logs del servidor para detectar intentos de acceso no autorizados.

---

## 7. Comparación con SFTP

| Característica          | FTPS Explícito               | SFTP                       |
|-------------------------|------------------------------|----------------------------|
| **Protocolo base**       | FTP                         | SSH                        |
| **Puerto**               | 21 (control) + puertos datos | 22                         |
| **Cifrado**              | SSL/TLS                     | SSH                        |
| **Autenticación**        | Usuario/contraseña o certificado | Usuario/contraseña o clave pública |
| **Compatibilidad**       | Amplia (clientes FTP tradicionales) | Limitada (requiere soporte SSH) |
| **Seguridad**            | Alta (con configuración adecuada) | Muy alta                   |

