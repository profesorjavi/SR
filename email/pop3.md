**Protocolo POP3 (Post Office Protocol v3)**

## 1. Introducción
POP3 (Post Office Protocol versión 3) es un protocolo utilizado para la recepción de correos electrónicos desde un servidor hasta un cliente de correo. Es ampliamente usado en entornos donde se prefiere descargar y almacenar los correos en un dispositivo local en lugar de mantenerlos en el servidor.

## 2. Características Principales
- **Protocolo basado en texto**: Utiliza comandos simples en texto plano.
- **Opera en el puerto 110 (sin cifrado) y 995 (con SSL/TLS).**
- **Modelo cliente-servidor**: El cliente POP3 se conecta al servidor, descarga los correos y luego los elimina del servidor (según configuración).
- **No soporta acceso simultáneo** desde múltiples dispositivos.
- **Opciones de configuración**: Permite dejar los correos en el servidor o eliminarlos después de la descarga.

## 3. Funcionamiento del Protocolo POP3
1. El usuario abre su cliente de correo electrónico (MUA).
2. El cliente se conecta al servidor POP3 en el puerto correspondiente.
3. Se autentica proporcionando usuario y contraseña.
4. Se descargan los correos del buzón del servidor al cliente.
5. Dependiendo de la configuración, los correos pueden ser eliminados del servidor.
6. El cliente cierra la conexión con el servidor.

## 4. Comandos y Respuestas POP3
La comunicación en POP3 se basa en comandos y respuestas. A continuación, se muestra un ejemplo de una sesión típica:

### Conexión con el servidor POP3
```
S: +OK Servidor POP3 listo
C: USER usuario@dominio.com
S: +OK Usuario aceptado
C: PASS contraseña
S: +OK Autenticación exitosa
```

### Listar mensajes en el buzón
```
C: LIST
S: +OK 2 mensajes (3200 bytes)
S: 1 1800
S: 2 1400
S: .
```

### Leer un mensaje específico
```
C: RETR 1
S: +OK 1800 bytes
S: (contenido del mensaje)
S: .
```

### Eliminar un mensaje
```
C: DELE 1
S: +OK Mensaje eliminado
```

### Cierre de sesión
```
C: QUIT
S: +OK Adiós
```

## 5. Seguridad en POP3
El protocolo POP3 original no incluye mecanismos de seguridad. Para mejorar su seguridad se utilizan:
- **POP3S (POP3 sobre SSL/TLS, puerto 995)**: Cifra la comunicación para proteger la autenticidad y privacidad del usuario.
- **Autenticación segura**: Implementación de autenticación mediante APOP (Authenticated Post Office Protocol).
- **Firewall y restricciones de acceso**: Se pueden restringir accesos desde direcciones IP específicas.

## 6. Ejemplo Práctico con Telnet
Para probar el protocolo POP3 manualmente, se puede usar Telnet:

1. Abrir una terminal y conectarse al servidor POP3:
   ```
   telnet mail.servidor.com 110
   ```
2. Autenticarse con `USER` y `PASS`.
3. Listar y recuperar mensajes con `LIST` y `RETR`.
4. Eliminar mensajes con `DELE` si es necesario.
5. Cerrar la sesión con `QUIT`.
