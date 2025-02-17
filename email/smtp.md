**Protocolo SMTP (Simple Mail Transfer Protocol)**

## 1. Introducción

SMTP (Simple Mail Transfer Protocol) es el protocolo estándar utilizado para el envío de correos electrónicos a través de redes TCP/IP. Su función principal es garantizar la entrega de mensajes desde el cliente de correo hasta el servidor de destino.

## 2. Características Principales

- **Protocolo basado en texto**: Utiliza comandos en texto plano.
- **Opera en el puerto 25 (sin cifrar) y 587/465 (con cifrado SSL/TLS).**
- **Modelo cliente-servidor**: Un cliente SMTP (MUA) se comunica con un servidor SMTP (MTA) para enviar correos.
- **Soporta autenticación** (SMTP AUTH) y cifrado (STARTTLS).
- **Uso de encolado de mensajes** en caso de que el destinatario no esté disponible.

## 3. Funcionamiento del Protocolo SMTP

El proceso de envío de un correo electrónico con SMTP sigue estos pasos:

1. El usuario redacta un correo en su cliente de correo (MUA).
2. El cliente de correo se conecta a un servidor SMTP y envía el mensaje.
3. El servidor SMTP del remitente reenvía el mensaje a través de internet.
4. Si el servidor de destino está disponible, recibe el mensaje; si no, lo reintenta más tarde.
5. El servidor de destino entrega el mensaje al buzón del destinatario.

## 4. Comandos y Respuestas SMTP

La comunicación en SMTP se basa en comandos y respuestas. A continuación, se muestra un ejemplo de comunicación entre cliente y servidor:

### Conexión con el servidor SMTP

```
S: 220 mail.servidor.com ESMTP Server Ready
C: HELO cliente.com
S: 250 mail.servidor.com
```

### Envío del correo

```
C: MAIL FROM:<remitente@cliente.com>
S: 250 Ok
C: RCPT TO:<destinatario@servidor.com>
S: 250 Ok
C: DATA
S: 354 End data with <CRLF>.<CRLF>
C: Subject: Prueba SMTP
C: Hola, este es un mensaje de prueba.
C: .
S: 250 Ok: Message queued
```

### Cierre de sesión

```
C: QUIT
S: 221 Bye
```

## 5. Seguridad en SMTP

El protocolo SMTP en su versión original no incluye mecanismos de seguridad. Para mejorar su seguridad se utilizan:

- **SMTP AUTH**: Requiere autenticación para evitar el envío de spam.
- **STARTTLS**: Habilita cifrado en la conexión SMTP.
- **SPF (Sender Policy Framework)**: Previene la suplantación de identidad.
- **DKIM (DomainKeys Identified Mail)**: Verifica la autenticidad del remitente.
- **DMARC (Domain-based Message Authentication, Reporting & Conformance)**: Política de seguridad para reducir phishing y spam.

## 6. Ejemplo Práctico con Telnet

Para probar el protocolo SMTP manualmente, se puede usar Telnet:

1. Abrir una terminal y conectarse al servidor SMTP:
   ```
   telnet mail.servidor.com 25
   ```
2. Seguir los pasos del ejemplo de comunicación SMTP.
3. Enviar el mensaje y cerrar la conexión.
