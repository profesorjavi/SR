## Servicio DNS

### 1. Sistemas de Nombres Planos y Jerárquicos
- **Sistemas de Nombres Planos**: Utilizan un único espacio de nombres sin estructura jerárquica. Cada nombre debe ser único en todo el sistema.
- **Sistemas de Nombres Jerárquicos**: Organizan los nombres en una estructura de árbol, donde cada nodo representa un dominio. Ejemplo: `example.com` es un dominio bajo el TLD `.com`.

### 2. Puertos y protocolos involucrados en DNS**:
  - **UDP 53**: Puerto principal para consultas DNS estándar por su baja latencia y menor sobrecarga. La mayoría de las consultas recursivas y respuestas cortas usan UDP.
  - **TCP 53**: Utilizado cuando la respuesta no cabe en UDP (truncamiento, bit TC) o para operaciones que requieren fiabilidad y transferencia completa, como las transferencias de zona (AXFR/IXFR) y algunas consultas DNSSEC. El cliente suele reintentar por TCP si recibe una respuesta truncada por UDP.
  - Nota adicional: Tecnologías modernas como DNS over TLS (DoT) usan **TCP 853** y DNS over HTTPS (DoH) usa **TCP 443**, pero el servicio DNS tradicional sigue principalmente en el puerto 53 sobre UDP/TCP.

### 3. Resolutores de Nombres y Proceso de Resolución de un Nombre de Dominio
- **Resolutores de Nombres**: Son clientes DNS que envían consultas a los servidores DNS para resolver nombres de dominio en direcciones IP.
- **Proceso de Resolución**:
  1. El resolutor envía una consulta al servidor DNS local.
  2. Si el servidor local no tiene la respuesta, consulta a un servidor raíz.
  3. El servidor raíz redirige la consulta a un servidor TLD.
  4. El servidor TLD redirige la consulta al servidor autoritativo del dominio.
  5. El servidor autoritativo responde con la dirección IP correspondiente.

**[Resolutor Ubuntu noble](resolutor.md)**

### 4. Servidores Raíz y Dominios de Primer Nivel y Sucesivos
- **Servidores Raíz**: Son los servidores DNS que contienen la información sobre los servidores TLD.
- **Dominios de Primer Nivel (TLD)**: Son los dominios en el nivel más alto de la jerarquía DNS, como `.com`, `.org`, `.net`.
- **Dominios Sucesivos**: Son los subdominios bajo los TLD, como `example.com`.
**[Amplia sobre servidores Raíz](ns_roots.md)**

### 5. Zonas Primarias y Secundarias. Transferencias de Zona
- **Zonas Primarias**: Contienen la copia maestra de los datos DNS.
- **Zonas Secundarias**: Contienen copias de las zonas primarias para redundancia y carga distribuida.
- **Transferencias de Zona**: Proceso de copiar los datos DNS de una zona primaria a una secundaria.

### 6. Delegación
- **Delegación**: Proceso de asignar la responsabilidad de una subzona a otro servidor DNS. Ejemplo: delegar `sub.example.com` a un servidor diferente.

### 7. Tipos de Registros
- **A (Address)**: Asocia un nombre de dominio con una dirección IPv4.
- **AAAA (IPv6 Address)**: Asocia un nombre de dominio con una dirección IPv6.
- **CNAME (Canonical Name)**: Alias de un nombre de dominio.
- **MX (Mail Exchange)**: Especifica servidores de correo para el dominio.
- **TXT (Text)**: Almacena información de texto.
- **NS (Name Server)**: Especifica los servidores DNS para la zona.

### 8. Servidores de Nombres en Direcciones IP Dinámicas
- **Servidores de Nombres en IP Dinámicas**: Utilizan servicios como DynDNS para actualizar dinámicamente las direcciones IP asociadas a un nombre de dominio.

### 9. Utilización de Reenviadores
- **Reenviadores**: Servidores DNS que reenvían consultas a otros servidores DNS para su resolución. Útil para mejorar la eficiencia y reducir la carga.

### 10. Resolución Inversa
- **Resolución Inversa**: Proceso de resolver una dirección IP en un nombre de dominio. Utiliza registros PTR (Pointer).

### 11. Propagación
- **La propagación** DNS es el proceso mediante el cual los cambios en los registros DNS (como una nueva dirección IP asignada a un dominio o una actualización de los servidores de nombres) se distribuyen y se reflejan en todos los servidores DNS de todo el mundo. Este proceso ocurre cada vez que se realizan modificaciones en los registros DNS de un dominio, como al cambiar de servidor web o cuando se asigna una nueva dirección IP a un dominio.

### 12. Comandos Relativos a la Resolución de Nombres
- **dig**: Herramienta avanzada para consultas DNS.
- **host**: Comando simple para resolver nombres de dominio.
- **nslookup**: Herramienta para consultar servidores DNS.

### 13. Tipos de Servidores DNS: Maestro y Esclavo, y Transferencia de Zona

- **Servidor Maestro (Primary/Master)**: Es el servidor que contiene la copia original y editable de la zona DNS. Todas las modificaciones se realizan en este servidor.
- **Servidor Esclavo (Secondary/Slave)**: Mantiene una copia de solo lectura de la zona DNS, obtenida desde el servidor maestro mediante transferencia de zona.

### 14. Transferencia de Zona

- **Transferencia de Zona AXFR**: Es el método estándar para copiar toda la zona DNS desde el maestro al esclavo. Se configura en el archivo de zona del maestro permitiendo la transferencia al esclavo.
- **Transferencia de Zona IXFR**: Permite transferir solo los cambios incrementales en la zona, optimizando el proceso.

**Ejemplo de configuración en BIND:**

En el servidor maestro (`named.conf`):

```conf
zone "example.com" {
  type master;
  file "/etc/bind/db.example.com";
  allow-transfer { 192.0.2.2; }; # IP del esclavo
}
```

En el servidor esclavo (`named.conf`):

```conf
zone "example.com" {
  type slave;
  masters { 192.0.2.1; }; # IP del maestro
}
```

La transferencia de zona se realiza automáticamente cuando el esclavo detecta cambios en el maestro o manualmente con comandos como `rndc reload` o `rndc transfer`.
