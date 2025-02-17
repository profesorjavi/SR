**Protocolo IMAP (Internet Message Access Protocol)**

## 1. Introducción
IMAP (Internet Message Access Protocol) es un protocolo utilizado para acceder y gestionar correos electrónicos almacenados en un servidor de correo. A diferencia de POP3, IMAP permite el acceso simultáneo desde múltiples dispositivos y mantiene los correos en el servidor hasta que el usuario los elimina manualmente.

## 2. Características Principales
- **Permite acceso remoto a los correos sin necesidad de descargarlos.**
- **Opera en el puerto 143 (sin cifrado) y 993 (con SSL/TLS).**
- **Soporta múltiples clientes conectados simultáneamente.**
- **Permite organizar los correos en carpetas y gestionar estados (leído, no leído, archivado).**
- **Compatible con el estándar MIME para gestionar archivos adjuntos.**

## 3. Funcionamiento del Protocolo IMAP
1. El usuario accede a su cliente de correo electrónico (MUA).
2. El cliente se conecta al servidor IMAP y se autentica.
3. Se sincronizan los correos electrónicos sin descargarlos completamente.
4. El usuario puede leer, mover, eliminar y organizar correos en carpetas sin afectar el almacenamiento local.
5. Los cambios realizados en un dispositivo se reflejan en todos los clientes conectados.

## 4. Comandos y Respuestas IMAP
La comunicación en IMAP se basa en comandos y respuestas. A continuación, se muestra un ejemplo de una sesión típica:

### Conexión con el servidor IMAP
```
S: * OK Servidor IMAP listo
C: A001 LOGIN usuario@dominio.com contraseña
S: A001 OK Autenticación exitosa
```

### Listar los buzones disponibles
```
C: A002 LIST "" "*"
S: * LIST () "/" INBOX
S: * LIST () "/" Sent
S: A002 OK LIST completado
```

### Seleccionar un buzón
```
C: A003 SELECT INBOX
S: * 5 EXISTS
S: * 2 RECENT
S: A003 OK INBOX seleccionado
```

### Recuperar el encabezado de un correo
```
C: A004 FETCH 1 BODY[HEADER]
S: * 1 FETCH (BODY[HEADER] {320}
S: Subject: Prueba IMAP
S: From: remitente@dominio.com
S: To: destinatario@dominio.com
S: )
S: A004 OK FETCH completado
```

### Marcar un mensaje como leído
```
C: A005 STORE 1 +FLAGS (\Seen)
S: A005 OK STORE completado
```

### Eliminar un mensaje
```
C: A006 STORE 1 +FLAGS (\Deleted)
S: A006 OK STORE completado
C: A007 EXPUNGE
S: * 1 EXPUNGE
S: A007 OK EXPUNGE completado
```

### Cierre de sesión
```
C: A008 LOGOUT
S: * BYE Servidor IMAP cerrando conexión
S: A008 OK LOGOUT completado
```

## 5. Seguridad en IMAP
El protocolo IMAP puede mejorarse con medidas de seguridad:
- **IMAPS (IMAP sobre SSL/TLS, puerto 993)**: Cifra la comunicación.
- **Autenticación segura**: Uso de OAuth o autenticación en dos factores.
- **Filtrado y reglas de acceso**: Restricción de acceso basado en IP o listas blancas.

## 6. Ejemplo Práctico con Telnet
Para probar el protocolo IMAP manualmente, se puede usar Telnet:

1. Abrir una terminal y conectarse al servidor IMAP:
   ```
   telnet mail.servidor.com 143
   ```
2. Autenticarse con `LOGIN usuario contraseña`.
3. Listar buzones con `LIST "" "*"`.
4. Seleccionar INBOX con `SELECT INBOX`.
5. Obtener correos con `FETCH` y cerrar sesión con `LOGOUT`.
