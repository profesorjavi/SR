### **Equivalencias de directivas comunes (actualizado)**

| **Apache2**                     | **Nginx**                          | **Explicación**                                                                 |
|----------------------------------|-------------------------------------|---------------------------------------------------------------------------------|
| `DocumentRoot`                  | `root`                             | Especifica el directorio raíz donde se encuentran los archivos del sitio web.   |
| `DirectoryIndex`                | `index`                            | Define los archivos que se deben buscar como índice (por ejemplo, `index.html`).|
| `ErrorLog`                      | `error_log`                        | Especifica la ubicación del archivo de registro de errores.                     |
| `CustomLog`                     | `access_log`                       | Define la ubicación del archivo de registro de acceso.                          |
| `Listen`                        | `listen`                           | Especifica el puerto y la dirección IP en la que el servidor escucha.           |
| `ServerName`                    | `server_name`                      | Define el nombre del servidor (dominio o subdominio).                           |
| `Alias`                         | `location` + `alias`               | Crea una ruta alias para acceder a un directorio específico.                    |
| `Redirect`                      | `return` o `rewrite`               | Redirige una URL a otra.                                                       |
| `RewriteRule`                   | `rewrite`                          | Permite reescribir URLs usando expresiones regulares.                          |
| `Require`                       | `allow`, `deny`                    | Controla el acceso a recursos basado en direcciones IP o autenticación.        |
| `SSLEngine`                     | `ssl`                              | Habilita el soporte para SSL/TLS.                                              |
| `SSLCertificateFile`            | `ssl_certificate`                  | Especifica la ubicación del certificado SSL.                                   |
| `SSLCertificateKeyFile`         | `ssl_certificate_key`              | Especifica la ubicación de la clave privada del certificado SSL.               |
| `Include`                       | `include`                          | Incluye archivos de configuración adicionales.                                 |
| `LoadModule`                    | No tiene equivalente directo       | En Nginx, los módulos se compilan directamente en el binario o se cargan dinámicamente. |
| `SetEnv`                        | `fastcgi_param` o `proxy_set_header` | Define variables de entorno para aplicaciones backend (PHP, proxys, etc.).     |

---

### **Explicación de la directiva `Require` en Apache 2.4**

En Apache 2.4, la directiva `Require` reemplaza a las antiguas `Allow` y `Deny`. Se utiliza para controlar el acceso a recursos basado en reglas de autorización.

#### **Ejemplo de `Require` en Apache 2.4**:
```apache
<Directory /var/www/html>
    Require all granted  # Permite el acceso a todos.
</Directory>

<Directory /var/www/private>
    Require ip 192.168.1.0/24  # Permite el acceso solo desde la red 192.168.1.0/24.
    Require valid-user         # Requiere autenticación de usuario.
</Directory>
```

#### **Equivalente en Nginx**:
En Nginx, el control de acceso se realiza con las directivas `allow` y `deny`:
```nginx
location /private {
    allow 192.168.1.0/24;  # Permite el acceso desde la red 192.168.1.0/24.
    deny all;              # Deniega el acceso a todos los demás.
}
```

---

### **Ejemplo de Virtual Host en Apache y Nginx**

#### **1. Virtual Host en Apache**
```apache
<VirtualHost *:80>
    ServerName ejemplo.com
    DocumentRoot /var/www/ejemplo

    <Directory /var/www/ejemplo>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

#### **2. Virtual Host en Nginx**
```nginx
server {
    listen 80;
    server_name ejemplo.com;

    root /var/www/ejemplo;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    error_log /var/log/nginx/ejemplo_error.log;
    access_log /var/log/nginx/ejemplo_access.log;
}
```

---

### **Explicación de los ejemplos de Virtual Host**

#### **Apache**
- **`<VirtualHost *:80>`**: Define un virtual host que escucha en el puerto 80.
- **`ServerName`**: Especifica el nombre del dominio (en este caso, `ejemplo.com`).
- **`DocumentRoot`**: Define la raíz del sitio web (`/var/www/ejemplo`).
- **`<Directory>`**: Configura permisos y opciones para el directorio.
- **`Require all granted`**: Permite el acceso a todos los usuarios.
- **`ErrorLog` y `CustomLog`**: Especifican los archivos de registro de errores y acceso.

#### **Nginx**
- **`server`**: Define un bloque de servidor.
- **`listen 80`**: Escucha en el puerto 80.
- **`server_name`**: Especifica el nombre del dominio (`ejemplo.com`).
- **`root`**: Define la raíz del sitio web (`/var/www/ejemplo`).
- **`index`**: Especifica los archivos de índice.
- **`location /`**: Configura cómo se manejan las solicitudes.
- **`error_log` y `access_log`**: Especifican los archivos de registro de errores y acceso.
