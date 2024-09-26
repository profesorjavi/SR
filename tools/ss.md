# El comando `ss`

El comando `ss` (Socket Statistics) es una herramienta para mostrar estadísticas de conexiones y sockets, y se usa principalmente para obtener información sobre conexiones de red activas en un sistema Linux. Si estás utilizando una conexión SSH y quieres usar `ss` para monitorear o depurar conexiones de red, aquí tienes algunos ejemplos útiles:

### 1. Ver todas las conexiones establecidas (incluyendo SSH)
```bash
ss -tuln
```
- `-t`: muestra solo conexiones TCP.
- `-u`: muestra conexiones UDP.
- `-l`: muestra los sockets en estado de escucha (listening).
- `-n`: no resuelve nombres de hosts ni puertos (muestra direcciones IP y números de puerto).

### 2. Ver solo conexiones activas. Ejemlo SSH
```bash
ss -tn src :22
```
Este comando filtra las conexiones establecidas a través del puerto SSH (22).

### 3. Mostrar conexiones SSH activas con detalles de estado
```bash
ss -atp | grep sshd
```
- `-a`: muestra todas las conexiones, incluidas las en espera (listening).
- `-t`: muestra conexiones TCP.
- `-p`: muestra información sobre los procesos que utilizan estas conexiones.

Esto muestra todas las conexiones TCP y filtra las que están asociadas al proceso `sshd`.

### 4. Ver conexiones SSH por IP específica
```bash
ss -nt dst IP_ADDRESS:22
```
Reemplaza `IP_ADDRESS` con la dirección IP específica para ver conexiones SSH hacia esa IP.

### 5. Mostrar todas las conexiones TCP abiertas
```bash
ss -t
```
Este comando muestra todas las conexiones TCP abiertas, incluidas las de SSH, HTTP, FTP, etc.

### 6. Ver estadísticas de conexiones SSH en tiempo real
```bash
watch ss -tn src :22
```
Con `watch`, puedes ver en tiempo real las conexiones SSH (o cualquier otra conexión TCP) cada pocos segundos.

### 7. Mostrar las conexiones con mayor detalle (con puertos y procesos)
```bash
ss -tulnp | grep ssh
```
Este comando muestra conexiones detalladas de todos los sockets abiertos (no solo SSH) con información de puertos y procesos.

Estos ejemplos te ayudarán a monitorear y gestionar las conexiones SSH y de red en general desde una sesión SSH utilizando `ss`.