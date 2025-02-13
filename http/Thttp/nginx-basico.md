En **Nginx**, la configuración se organiza en archivos clave que controlan el comportamiento del servidor. A continuación, te explico cuáles son estos archivos, cómo crear y gestionar nuevos virtual hosts, y cómo cargar nuevos módulos.

---

### **Archivos de configuración clave en Nginx**

1. **`/etc/nginx/nginx.conf`**:
   - Es el archivo de configuración principal de Nginx.
   - Contiene configuraciones globales, como la definición de eventos, usuarios, y la inclusión de otros archivos de configuración.
   - Suele incluir directivas como `worker_processes`, `events`, y `http`.

   Ejemplo:
   ```nginx
   user www-data;
   worker_processes auto;
   pid /run/nginx.pid;

   events {
       worker_connections 1024;
   }

   http {
       include /etc/nginx/mime.types;
       include /etc/nginx/conf.d/*.conf;
       include /etc/nginx/sites-enabled/*;
   }
   ```

2. **`/etc/nginx/conf.d/`**:
   - Este directorio contiene archivos de configuración adicionales.
   - Cada archivo `.conf` en este directorio se incluye automáticamente en la configuración principal.
   - Es útil para separar configuraciones específicas (por ejemplo, configuraciones de proxy, balanceadores de carga, etc.).

3. **`/etc/nginx/sites-available/`**:
   - Contiene archivos de configuración para cada virtual host (sitio web).
   - Estos archivos no se activan automáticamente; son plantillas para los virtual hosts.

4. **`/etc/nginx/sites-enabled/`**:
   - Contiene enlaces simbólicos a los archivos de configuración de `sites-available`.
   - Solo los archivos enlazados aquí se cargan y activan en Nginx.

5. **`/etc/nginx/mime.types`**:
   - Define los tipos MIME para los archivos que Nginx sirve.
   - Asocia extensiones de archivo con tipos de contenido (por ejemplo, `.html` como `text/html`).

6. **`/var/log/nginx/`**:
   - Contiene los archivos de registro de acceso (`access.log`) y errores (`error.log`).

---

### **Cómo crear y gestionar nuevos virtual hosts**

#### **1. Crear un nuevo virtual host**
1. Crea un archivo de configuración en `/etc/nginx/sites-available/`:
   ```bash
   sudo nano /etc/nginx/sites-available/ejemplo.com
   ```
2. Define la configuración del virtual host. Por ejemplo:
   ```nginx
   server {
       listen 80;
       server_name ejemplo.com www.ejemplo.com;

       root /var/www/ejemplo;
       index index.html;

       location / {
           try_files $uri $uri/ =404;
       }

       error_log /var/log/nginx/ejemplo_error.log;
       access_log /var/log/nginx/ejemplo_access.log;
   }
   ```
3. Crea un enlace simbólico en `sites-enabled` para activar el virtual host:
   ```bash
   sudo ln -s /etc/nginx/sites-available/ejemplo.com /etc/nginx/sites-enabled/
   ```

#### **2. Verificar la configuración**
Antes de recargar Nginx, verifica que la configuración sea válida:
```bash
sudo nginx -t
```
Si no hay errores, verás un mensaje como:
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

#### **3. Recargar Nginx**
Para aplicar los cambios, recarga Nginx:
```bash
sudo systemctl reload nginx
```

#### **4. Desactivar un virtual host**
Para desactivar un virtual host, elimina el enlace simbólico en `sites-enabled`:
```bash
sudo rm /etc/nginx/sites-enabled/ejemplo.com
```
Luego, recarga Nginx:
```bash
sudo systemctl reload nginx
```

---

### **Cómo cargar nuevos módulos en Nginx**

#### **Usar módulos dinámicos (Nginx 1.9.11+)**
A partir de la versión 1.9.11, Nginx soporta módulos dinámicos. Para cargar un módulo dinámico:
1. Instala el módulo dinámico (por ejemplo, desde un repositorio o compilándolo).
2. Agrega la directiva `load_module` en el archivo `nginx.conf`:
   ```nginx
   load_module modules/ngx_http_geoip_module.so;
   ```
3. Recarga Nginx:
   ```bash
   sudo systemctl reload nginx
   ```

--