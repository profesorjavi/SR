## Uso de FFmpeg para Streaming con Protocolo RTMP

## Introducción

FFmpeg es una herramienta de línea de comandos extremadamente potente y versátil que permite manipular audio y video. Entre sus muchas funcionalidades, se encuentra la capacidad de realizar streaming en vivo utilizando el protocolo RTMP (Real-Time Messaging Protocol). Este documento está dirigido a alumnos de ciclo superior de informática y tiene como objetivo proporcionar una guía práctica para utilizar FFmpeg en la realización de streaming con RTMP.

## Requisitos Previos

- **FFmpeg instalado**: Asegúrate de tener FFmpeg instalado en tu sistema. Puedes descargarlo desde [https://ffmpeg.org/](https://ffmpeg.org/).
- **Servidor RTMP**: Necesitarás un servidor que soporte RTMP, como Nginx con el módulo RTMP, Wowza, o servicios en la nube como YouTube Live, Twitch, o Facebook Live.
- **Archivo de video o fuente de video en vivo**: Puede ser un archivo de video preexistente o una fuente de video en vivo desde una cámara.

### Comandos Básicos de FFmpeg

- **ffmpeg**: Comando principal para ejecutar FFmpeg.
- **-i**: Especifica el archivo de entrada.
- **-c**: Especifica el códec a utilizar.
- **-f**: Especifica el formato de salida.
- **-b**: Define el bitrate.
- **-r**: Define la tasa de frames por segundo (fps).

## Ejemplos Prácticos

### 1. Streaming de un Archivo de Video a un Servidor RTMP

Supongamos que tienes un archivo de video llamado `video.mp4` y deseas transmitirlo a un servidor RTMP.

```bash
ffmpeg -re -i video.mp4 -c:v libx264 -preset veryfast -maxrate 1000k -bufsize 2000k -vf "scale=1280:720" -c:a aac -b:a 128k -f flv rtmp://tuserver.com/live/mystream
```

#### Explicación de los Parámetros:

- **-re**: Lee el archivo de entrada a la velocidad nativa (útil para streaming).
- **-i video.mp4**: Especifica el archivo de entrada.
- **-c:v libx264**: Usa el códec H.264 para video.
- **-preset veryfast**: Ajusta la velocidad de codificación.
- **-maxrate 1000k**: Establece el bitrate máximo de video a 1000 kbps.
- **-bufsize 2000k**: Establece el tamaño del buffer de video.
- **-vf "scale=1280:720"**: Escala el video a 1280x720 (720p).
- **-c:a aac**: Usa el códec AAC para audio.
- **-b:a 128k**: Establece el bitrate de audio a 128 kbps.
- **-f flv**: Especifica el formato de salida como FLV (compatible con RTMP).
- **rtmp://tuserver.com/live/mystream**: URL del servidor RTMP y nombre del stream.

### 2. Streaming desde una Cámara Web

Si deseas transmitir video en vivo desde una cámara web, puedes usar el siguiente comando:

```bash
ffmpeg -f v4l2 -i /dev/video0 -c:v libx264 -preset veryfast -maxrate 1000k -bufsize 2000k -vf "scale=1280:720" -c:a aac -b:a 128k -f flv rtmp://tuserver.com/live/mystream
```

#### Explicación de los Parámetros:

- **-f v4l2**: Especifica el formato de entrada como Video4Linux2 (para cámaras web en Linux).
- **-i /dev/video0**: Especifica el dispositivo de la cámara web.

### 3. Streaming con Overlay de Texto

Si deseas añadir un overlay de texto en tu stream, puedes usar el siguiente comando:

```bash
ffmpeg -re -i video.mp4 -c:v libx264 -preset veryfast -maxrate 1000k -bufsize 2000k -vf "scale=1280:720, drawtext=text='Streaming Live':fontcolor=white:fontsize=24:x=(w-text_w)/2:y=(h-text_h)/2" -c:a aac -b:a 128k -f flv rtmp://tuserver.com/live/mystream
```

#### Explicación de los Parámetros:

- **drawtext**: Añade un overlay de texto.
  - **text='Streaming Live'**: Texto a mostrar.
  - **fontcolor=white**: Color del texto.
  - **fontsize=24**: Tamaño de la fuente.
  - **x=(w-text_w)/2:y=(h-text_h)/2**: Posición del texto en el centro del video.

### 4. Streaming con Audio y Video Separados

Si tienes archivos de audio y video separados y deseas combinarlos en un solo stream:

```bash
ffmpeg -re -i video.mp4 -i audio.wav -c:v libx264 -preset veryfast -maxrate 1000k -bufsize 2000k -vf "scale=1280:720" -c:a aac -b:a 128k -f flv rtmp://tuserver.com/live/mystream
```

#### Explicación de los Parámetros:

- **-i audio.wav**: Especifica el archivo de audio.

### 5. Streaming con Transcodificación

Si necesitas transcodificar el video a un códec diferente antes de transmitirlo:

```bash
ffmpeg -re -i video.mp4 -c:v mpeg2video -preset veryfast -maxrate 1000k -bufsize 2000k -vf "scale=1280:720" -c:a mp2 -b:a 128k -f flv rtmp://tuserver.com/live/mystream
```

#### Explicación de los Parámetros:

- **-c:v mpeg2video**: Usa el códec MPEG-2 para video.
- **-c:a mp2**: Usa el códec MP2 para audio.


## Recursos Adicionales

- [Documentación Oficial de FFmpeg](https://ffmpeg.org/documentation.html)
- [Guía de Configuración de Nginx con RTMP](https://github.com/arut/nginx-rtmp-module)

