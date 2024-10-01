Las conexiones SSH (Secure Shell) y los **sockets** están estrechamente relacionados, ya que SSH utiliza sockets para establecer y gestionar la comunicación entre un cliente y un servidor a través de una red. A continuación, te explico cómo se relacionan:

### 1. **Socket como punto de conexión**
   Un **socket** es el punto final de una conexión de red entre dos dispositivos. En el contexto de **SSH**, el socket se utiliza para conectar al cliente SSH con el servidor SSH. Cada vez que inicias una sesión SSH, se crea un socket tanto en el cliente como en el servidor para gestionar la comunicación.

### 2. **Protocolo TCP y SSH**
   SSH utiliza el protocolo **TCP (Transmission Control Protocol)**, que es un protocolo orientado a la conexión y fiable. El socket que usa SSH es un **socket de flujo (stream socket)**, el cual se basa en TCP. Esto significa que:
   - Antes de que se transfieran datos, se establece una conexión fiable a través de TCP.
   - Una vez establecida la conexión, el socket se utiliza para intercambiar datos cifrados entre el cliente y el servidor.

### 3. **Puertos y direcciones IP**
   - Cada socket está asociado con una **dirección IP** y un **puerto**. En el caso de SSH, el servidor generalmente escucha en el **puerto 22** (a menos que se configure de otra manera) y el cliente se conecta a esa dirección IP y puerto específicos. 
   - Un socket SSH se representa con una combinación de la dirección IP del servidor y el puerto de escucha, por ejemplo, `192.168.1.10:22`.

### 4. **Relación entre conexiones SSH y sockets**
   - **Cada conexión SSH** implica la creación de un **socket** tanto en el cliente como en el servidor. 
   - Cuando un cliente se conecta al servidor SSH, se crea un **socket en el servidor**, que es el que escucha en el puerto 22. 
   - Una vez que la conexión se establece, se crea un **socket único** para esa conexión específica (cliente-servidor). Cada nueva conexión SSH abrirá un **nuevo socket** en el servidor, aunque usen el mismo puerto.

   Esto significa que el servidor SSH puede manejar múltiples conexiones SSH simultáneas, y cada una estará asociada a un socket diferente. Estos sockets mantienen la comunicación entre el cliente y el servidor durante la sesión SSH.

### 5. **Límites de conexiones y sockets**
   - Las directivas `MaxSessions` y `MaxStartups`, controlan indirectamente cuántos sockets activos puede manejar el servidor para las conexiones SSH. Si el número de conexiones excede el límite configurado, el servidor dejará de aceptar nuevas conexiones, ya que no podrá abrir nuevos sockets.
   
   - Además, el sistema operativo también impone un límite en el número total de sockets abiertos que puede manejar simultáneamente (lo que se conoce como **descriptores de archivos**), y esto puede influir en cuántas conexiones SSH se pueden manejar en paralelo.


En términos simples, un socket es el canal a través del cual se transportan los datos de una sesión SSH.


Para ver los **sockets abiertos** en un servidor, incluyendo las conexiones **SSH** activas, puedes usar el comando `ss`. Este comando es una herramienta moderna y eficiente para examinar sockets y conexiones de red.

### Comando básico para ver los sockets SSH abiertos

Para listar los sockets asociados a conexiones SSH (que generalmente utilizan el puerto **22**), puedes usar el siguiente comando:

```bash
ss -tna | grep :22
```

Este comando hace lo siguiente:
- `-t`: Muestra solo sockets TCP.
- `-n`: Muestra las direcciones de forma numérica (sin resolución de nombres de host).
- `-a`: Muestra todos los sockets, incluyendo los que están en escucha.
- `grep :22`: Filtra la salida para mostrar solo las conexiones relacionadas con el puerto 22, que es el puerto SSH por defecto.

### Detalles de la salida

La salida será algo similar a esto:

```
ESTAB  0  0  192.168.1.100:22  192.168.1.101:51174
ESTAB  0  0  192.168.1.100:22  192.168.1.102:51432
LISTEN 0  128 *:22              *:*
```

Aquí te explico qué significa cada columna:
1. **ESTAB (o LISTEN)**: Estado de la conexión. `ESTAB` indica que la conexión está establecida. `LISTEN` indica que el servidor está escuchando en el puerto.
2. **0  0**: Son los contadores de cola (no usados generalmente en conexiones establecidas).
3. **192.168.1.100:22**: La dirección IP del servidor y el puerto SSH (22).
4. **192.168.1.101:51174**: La dirección IP y puerto del cliente que está conectado a través de SSH.

### Otras opciones útiles con `ss`

1. **Ver más detalles de las conexiones SSH**:
   Si quieres ver más detalles sobre las conexiones, como los nombres de los procesos que están utilizando los sockets SSH, puedes agregar la opción `-p`:

   ```bash
   ss -tnap | grep :22
   ```

   Esto agregará una columna adicional que muestra los **PIDs** y los nombres de los procesos que están manejando las conexiones. La salida incluiría líneas como:

   ```
   ESTAB  0  0  192.168.1.100:22  192.168.1.101:51174  users:(("sshd",pid=1234,fd=3))
   ```

   Aquí, puedes ver que el proceso que maneja la conexión es `sshd`, con el **PID** 1234.

2. **Ver conexiones SSH activas y su estado**:
   Si quieres ver el estado general de las conexiones, puedes usar:

   ```bash
   ss -o state established '( sport = :22 )'
   ```

   Esto mostrará solo las conexiones SSH que están **establecidas** y proporcionará más detalles sobre ellas, como tiempos de espera y duración de las conexiones.


Recuerda que aunque las **conexiones entrantes al servidor SSH** usan el puerto **22** del servidor, cada conexión entrante es gestionada a través de un **socket único**. La idea clave es que, aunque todas las conexiones SSH al servidor usen el puerto 22 en el lado del servidor, cada conexión está asociada a un socket único que tiene una combinación de:
- La **dirección IP y puerto del servidor** (que será el puerto 22 en este caso).
- La **dirección IP y puerto del cliente** (que varían para cada conexión entrante).

En este ejemplo listado en un servidor:

```bash
LISTEN 0      128          0.0.0.0:22         0.0.0.0:*           
ESTAB  0      0       172.29.0.254:22    10.185.0.158:44904       
ESTAB  0      0       172.29.0.254:22    192.168.4.99:48314       
ESTAB  0      0       172.29.0.254:22    10.185.0.158:54442       
LISTEN 0      128             [::]:22            [::]:*  
```

- Las líneas que dicen **`LISTEN`** indican que el servidor está escuchando en el **puerto 22** para aceptar conexiones desde cualquier dirección IP (`0.0.0.0:22` y `[::]:22`).
- Las líneas que dicen **`ESTAB`** (establecidas) muestran conexiones SSH ya abiertas:
  - **172.29.0.254:22**: Es la IP del servidor (puerto 22).
  - **10.185.0.158:44904**: Es la IP del cliente (puerto 44904).
  - **192.168.4.99:48314**: Otro cliente, en este caso con la IP `192.168.4.99` y puerto `48314`.

### Detalles clave:
- **El servidor escucha en el puerto 22**, pero cada conexión establecida tiene un **socket único**, que está definido por:
  - **La IP y puerto del servidor** (siempre el puerto 22, pero la IP puede variar según la interfaz de red).
  - **La IP y puerto del cliente**, que cambia en cada conexión.
  
Esto significa que, aunque todas las conexiones SSH en tu servidor tienen el **puerto 22** como destino en el servidor, la combinación única de **IP:Puerto Cliente ↔ IP:Puerto Servidor** crea un socket independiente para cada conexión. 

Por ejemplo:
- La conexión **172.29.0.254:22 ↔ 10.185.0.158:44904** es distinta de **172.29.0.254:22 ↔ 192.168.4.99:48314** porque tienen diferentes IPs y puertos de origen en el cliente, aunque en ambos casos el servidor use el puerto 22.

