## Servicio DNS

### 1. Sistemas de Nombres Planos y Jerárquicos
- **Sistemas de Nombres Planos**: Utilizan un único espacio de nombres sin estructura jerárquica. Cada nombre debe ser único en todo el sistema.
- **Sistemas de Nombres Jerárquicos**: Organizan los nombres en una estructura de árbol, donde cada nodo representa un dominio. Ejemplo: `example.com` es un dominio bajo el TLD `.com`.

### 2. Resolutores de Nombres y Proceso de Resolución de un Nombre de Dominio
- **Resolutores de Nombres**: Son clientes DNS que envían consultas a los servidores DNS para resolver nombres de dominio en direcciones IP.
- **Proceso de Resolución**:
  1. El resolutor envía una consulta al servidor DNS local.
  2. Si el servidor local no tiene la respuesta, consulta a un servidor raíz.
  3. El servidor raíz redirige la consulta a un servidor TLD.
  4. El servidor TLD redirige la consulta al servidor autoritativo del dominio.
  5. El servidor autoritativo responde con la dirección IP correspondiente.

**[Resolutor Ubuntu noble](resolutor.md)**

### 3. Servidores Raíz y Dominios de Primer Nivel y Sucesivos
- **Servidores Raíz**: Son los servidores DNS que contienen la información sobre los servidores TLD.
- **Dominios de Primer Nivel (TLD)**: Son los dominios en el nivel más alto de la jerarquía DNS, como `.com`, `.org`, `.net`.
- **Dominios Sucesivos**: Son los subdominios bajo los TLD, como `example.com`.
**[Amplia sobre servidores Raíz](ns_roots.md)**

### 4. Zonas Primarias y Secundarias. Transferencias de Zona
- **Zonas Primarias**: Contienen la copia maestra de los datos DNS.
- **Zonas Secundarias**: Contienen copias de las zonas primarias para redundancia y carga distribuida.
- **Transferencias de Zona**: Proceso de copiar los datos DNS de una zona primaria a una secundaria.

### 5. Delegación
- **Delegación**: Proceso de asignar la responsabilidad de una subzona a otro servidor DNS. Ejemplo: delegar `sub.example.com` a un servidor diferente.

### 6. Tipos de Registros
- **A (Address)**: Asocia un nombre de dominio con una dirección IPv4.
- **AAAA (IPv6 Address)**: Asocia un nombre de dominio con una dirección IPv6.
- **CNAME (Canonical Name)**: Alias de un nombre de dominio.
- **MX (Mail Exchange)**: Especifica servidores de correo para el dominio.
- **TXT (Text)**: Almacena información de texto.
- **NS (Name Server)**: Especifica los servidores DNS para la zona.

### 7. Servidores de Nombres en Direcciones IP Dinámicas
- **Servidores de Nombres en IP Dinámicas**: Utilizan servicios como DynDNS para actualizar dinámicamente las direcciones IP asociadas a un nombre de dominio.

### 8. Utilización de Reenviadores
- **Reenviadores**: Servidores DNS que reenvían consultas a otros servidores DNS para su resolución. Útil para mejorar la eficiencia y reducir la carga.

### 9. Resolución Inversa
- **Resolución Inversa**: Proceso de resolver una dirección IP en un nombre de dominio. Utiliza registros PTR (Pointer).

### 10. Propagación
- **La propagación** DNS es el proceso mediante el cual los cambios en los registros DNS (como una nueva dirección IP asignada a un dominio o una actualización de los servidores de nombres) se distribuyen y se reflejan en todos los servidores DNS de todo el mundo. Este proceso ocurre cada vez que se realizan modificaciones en los registros DNS de un dominio, como al cambiar de servidor web o cuando se asigna una nueva dirección IP a un dominio.

### 11. Comandos Relativos a la Resolución de Nombres
- **nslookup**: Herramienta para consultar servidores DNS.
- **dig**: Herramienta avanzada para consultas DNS.
- **host**: Comando simple para resolver nombres de dominio.

### 12. El Cliente del Servicio de Nombres de Dominio. Configuración
- **Configuración del Cliente DNS**: Configuración de resolutores en sistemas operativos para utilizar servidores DNS específicos.

### 13. El Servidor de Nombres de Dominio. Configuración
- **Configuración del Servidor DNS**: Instalación y configuración de software DNS como BIND, configurando zonas y registros.

### 14. Herramientas Gráficas de Configuración
- **Herramientas Gráficas**: Interfaces como Webmin para la administración de servidores DNS.