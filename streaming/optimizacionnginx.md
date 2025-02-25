# Optimización de Nginx para Streaming con RTMP

Nginx es un servidor web y proxy inverso ampliamente utilizado que, con el módulo RTMP, puede funcionar como un servidor de streaming en vivo. Para garantizar un rendimiento óptimo, es importante ajustar ciertos parámetros de configuración en Nginx. A continuación, se explica en detalle cómo optimizar Nginx para streaming con RTMP, centrándose en los parámetros `worker_processes`, `worker_connections`, y `keepalive_timeout`.

## 1. **worker_processes**

Este parámetro define el número de procesos de trabajo que Nginx utilizará. Un valor adecuado puede mejorar significativamente el rendimiento, especialmente en servidores con múltiples núcleos de CPU.

### Ejemplo:

```nginx
worker_processes auto;
```

- **auto**: Nginx detectará automáticamente el número de núcleos de CPU disponibles y ajustará el número de procesos de trabajo en consecuencia.
- **Valor numérico**: Puedes especificar un número fijo de procesos de trabajo. Por ejemplo, `worker_processes 4;` para un servidor con 4 núcleos.

### Consideraciones:

- **Núcleos de CPU**: Asegúrate de que el número de `worker_processes` no exceda el número de núcleos de CPU disponibles.
- **Carga del sistema**: Monitorea la carga del sistema para ajustar este parámetro según sea necesario.

## 2. **worker_connections**

Este parámetro define el número máximo de conexiones simultáneas que cada proceso de trabajo puede manejar.

### Ejemplo:

```nginx
events {
    worker_connections 1024;
}
```

- **1024**: Cada proceso de trabajo puede manejar hasta 1024 conexiones simultáneas.

### Consideraciones:

- **Límite del sistema**: Verifica el límite máximo de archivos abiertos en tu sistema (`ulimit -n`) y asegúrate de que `worker_connections` no exceda este límite.
- **Memoria**: Cada conexión consume memoria, por lo que un valor muy alto puede agotar la memoria disponible.

## 3. **keepalive_timeout**

Este parámetro define el tiempo que una conexión keepalive permanece abierta. Las conexiones keepalive permiten reutilizar una conexión TCP para múltiples solicitudes, lo que reduce la sobrecarga de establecer nuevas conexiones.

### Ejemplo:

```nginx
http {
    keepalive_timeout 65;
}
```

- **65**: La conexión keepalive permanece abierta durante 65 segundos.

### Consideraciones:

- **Latencia**: Un valor demasiado alto puede mantener conexiones abiertas innecesariamente, consumiendo recursos.
- **Rendimiento**: Un valor demasiado bajo puede aumentar la sobrecarga de establecer nuevas conexiones frecuentemente.

## Ejemplo Completo de Configuración de Nginx con RTMP

A continuación, se muestra un ejemplo completo de configuración de Nginx con el módulo RTMP, optimizado para streaming en vivo:

```nginx
worker_processes auto;

events {
    worker_connections 1024;
}

rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            record off;

            # Configuración adicional para HLS (opcional)
            hls on;
            hls_path /tmp/hls;
            hls_fragment 3;
            hls_playlist_length 60;
        }
    }
}

http {
    keepalive_timeout 65;

    server {
        listen 80;

        location /hls {
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            root /tmp;
            add_header Cache-Control no-cache;
        }
    }
}
```

### Explicación de la Configuración:

- **worker_processes auto;**: Nginx ajusta automáticamente el número de procesos de trabajo según los núcleos de CPU disponibles.
- **worker_connections 1024;**: Cada proceso de trabajo puede manejar hasta 1024 conexiones simultáneas.
- **keepalive_timeout 65;**: Las conexiones keepalive permanecen abiertas durante 65 segundos.
- **rtmp { ... }**: Configuración del módulo RTMP para streaming en vivo.
  - **listen 1935;**: Nginx escucha en el puerto 1935 para conexiones RTMP.
  - **chunk_size 4096;**: Tamaño de los fragmentos de datos RTMP.
  - **application live { ... }**: Define una aplicación RTMP llamada "live".
    - **live on;**: Habilita el streaming en vivo.
    - **record off;**: Deshabilita la grabación de streams.
    - **hls on;**: Habilita HLS (HTTP Live Streaming) para compatibilidad con dispositivos que no soportan RTMP.
    - **hls_path /tmp/hls;**: Ruta donde se almacenan los fragmentos HLS.
    - **hls_fragment 3;**: Duración de cada fragmento HLS en segundos.
    - **hls_playlist_length 60;**: Duración total de la lista de reproducción HLS en segundos.
- **http { ... }**: Configuración del servidor HTTP para servir fragmentos HLS.
  - **location /hls { ... }**: Define una ubicación para servir fragmentos HLS.
    - **types { ... }**: Define los tipos MIME para archivos HLS.
    - **root /tmp;**: Ruta raíz para los archivos HLS.
    - **add_header Cache-Control no-cache;**: Deshabilita el almacenamiento en caché para fragmentos HLS.


Optimizar Nginx para streaming con RTMP implica ajustar parámetros clave como `worker_processes`, `worker_connections`, y `keepalive_timeout` para mejorar el rendimiento y la escalabilidad. La configuración proporcionada es un punto de partida que puede ajustarse según las necesidades específicas de tu entorno y la carga esperada. Monitorea el rendimiento del servidor y realiza ajustes adicionales según sea necesario para garantizar un streaming en vivo fluido y confiable.