# Configuración de un servidor DHCP

## ¿Qué es Kea?
KEA es un proyecto de software de servidor DHCP (Dynamic Host Configuration Protocol) de código abierto desarrollado por Internet Systems Consortium (ISC). El servidor KEA DHCP es una implementación de servidor DHCP que se utiliza para asignar direcciones IP y configuraciones de red a dispositivos que se conectan a una red. El protocolo DHCP es fundamental en la administración de direcciones IP en redes TCP/IP, ya que permite la asignación automática y dinámica de direcciones IP a dispositivos en una red.

Algunas de las características y capacidades del servidor KEA DHCP incluyen:

  *  **Soporte para IPv4 e IPv6**: KEA DHCP es capaz de manejar tanto la asignación de direcciones IPv4 como IPv6, lo que lo hace adecuado para redes mixtas.

  *  **Flexibilidad de configuración**: KEA DHCP ofrece una configuración flexible y versátil que permite a los administradores de red definir políticas de asignación de direcciones IP, opciones de configuración y clases de clientes de manera altamente personalizada.

  *  **Reservas estáticas**: Puedes definir reservas estáticas para asignar direcciones IP específicas a dispositivos basados en sus direcciones MAC u otros criterios.

  *  **Clases de clientes**: KEA DHCP permite clasificar y tratar de manera diferente a los clientes DHCP en función de ciertas características, como su tipo de dispositivo, hardware, opciones de configuración, etc.

  *  **Alta disponibilidad**: KEA DHCP puede configurarse en un entorno de alta disponibilidad para garantizar la continuidad del servicio DHCP.

  *  **Seguridad**: Ofrece mecanismos de seguridad para proteger contra ataques y garantizar la autenticación y la integridad de las comunicaciones DHCP.

  *  **Registros detallados**: KEA DHCP proporciona registros detallados y herramientas de diagnóstico para ayudar en la administración y resolución de problemas de la red.


## Archivo de configuración
```sh
$ vi /etc/kea/kea-dhcp4.conf
```

El archivo de configuración de KEA DHCP se estructura utilizando un formato JSON.

A continuación, se describen algunos de los elementos clave en este archivo de configuración de ejemplo:

  *  **"Dhcp4" y "Dhcp6":** Estas secciones contienen la configuración específica para el servidor DHCP IPv4 e IPv6, respectivamente. Puedes configurar cada uno por separado.

  *  **"interfaces-config":** En esta sección, se especifican las interfaces de red en las que el servidor DHCP escuchará las solicitudes de los clientes.

  *  **"subnet4" y "subnet6":** Estas secciones definen las subredes que el servidor DHCP debe administrar para IPv4 e IPv6, respectivamente. Cada una contiene información sobre la subred, como las direcciones de las piscinas de direcciones IP, opciones de configuración, etc.

  *  **"option-data":** Aquí puedes especificar las opciones de configuración que se asignarán a los clientes. En el ejemplo, se incluyen las direcciones de servidores DNS como ejemplo.

## Controles
El comando keactrl es una herramienta proporcionada por KEA DHCP (Internet Systems Consortium's Kea DHCP server) que se utiliza para interactuar y controlar el servidor KEA DHCP. A través de keactrl, los administradores pueden realizar diversas tareas de administración y control del servidor. A continuación, se describen algunas de las funcionalidades y tareas comunes que se pueden realizar con el comando keactrl:

   1. Iniciar el servidor KEA DHCP: Puedes utilizar keactrl start o keactrl start -n <nombre-servicio> para iniciar uno o más servicios KEA DHCP. El uso de la opción -n te permite especificar un servicio específico si tienes múltiples servicios KEA DHCP configurados, como DHCPv4 y DHCPv6.

   2. Detener el servidor KEA DHCP: Utiliza keactrl stop o keactrl stop -n <nombre-servicio> para detener uno o más servicios KEA DHCP.

   3. Reiniciar el servidor KEA DHCP: Con keactrl restart o keactrl restart -n <nombre-servicio>, puedes reiniciar uno o más servicios KEA DHCP.

  4.  Recargar la configuración: Puedes recargar la configuración del servidor KEA DHCP sin detenerlo utilizando keactrl reload o keactrl reload -n <nombre-servicio>. Esto es útil después de realizar cambios en el archivo de configuración sin necesidad de reiniciar por completo el servidor.

  5.  Ver el estado del servidor: Utiliza keactrl status o keactrl status -n <nombre-servicio> para obtener información sobre el estado actual del servidor, como si está en ejecución o detenido, y otros detalles de funcionamiento.

  6.  Ejecutar el servidor KEA DHCP en modo interactivo: Puedes iniciar el servidor en modo interactivo para depuración y diagnóstico utilizando keactrl run o keactrl run -n <nombre-servicio>. Esto ejecutará el servidor en primer plano y mostrará información detallada en la terminal para propósitos de diagnóstico.

  8.  Gestión de registros (logs): Puedes configurar el registro de eventos y visualizar los registros generados por el servidor KEA DHCP utilizando keactrl. Esto es útil para supervisar el funcionamiento del servidor y diagnosticar problemas.

  9.  Comprobar la sintaxis de archivos de configuración: keactrl config-test te permite verificar la sintaxis de los archivos de configuración de KEA DHCP sin reiniciar el servidor. Esto es útil para detectar errores en la configuración.
```sh
$ keactrl config-test -t -c /ruta/al/archivo/kea-dhcp4.conf
```





# Configuración Básica; ámbito, pool, puerta de enlace y dns

Configura el servidor KEA para el ámbito 192.168.10.0/24 con el rango 192.168.10.11-192.168.10.200. Asigna la puerta de enlace (gateway) a 192.168.10.1, el servidor de nombres a 192.168.10.2.

```json
{
    "Dhcp4": {
        "interfaces-config": {
            "interfaces": ["eth0"]
        },
        "subnet4": [
            {
                "subnet": "192.168.10.0/24",
                "pools": [
                    { "pool": "192.168.10.11 - 192.168.10.200" }
                ],
                "option-data": [
                    {
                        "name": "routers",
                        "data": "192.168.10.1"
                    },
                    {
                        "name": "domain-name-servers",
                        "data": "192.168.10.2"
                    }
                ]
            }
        ]
    }
}
```



# Reserva de un equipo
Realizar la reserva de un equipo.
```json
{
   "Dhcp4": {
       "reservations": [
           {
               "hw-address": "be:86:c0:cd:95:f4",
               "ip-address": "192.168.10.201"
           }
       ]
   }
}
```
## Reserva de un host indicando un nombre 
```json
{
   "Dhcp4": {
       "reservations": [
                {
                    "hw-address": "08:00:27:15:91:a0",
                    "ip-address": "192.168.10.201",
                    "hostname": "ServidorTEST"
                } 
         ]
   }
}    
```

Comprobamos en el cliente DHCP
```sh
$ hostname
ServidorTEST
```


## Búsquedas directas
Para configurar las busquedas directas 
```json
"option-data": [
    {
                "name": "domain-search",
                "data": "seniatic.org"
    }

]
```
Esto permite en el cliente DHCP realizar por ejemplo un 
```sh
$ ping www  
```
sin tener que especificar el dominio ping www.seniatic.org

# Ámbito que atiende a servidores relay
Configurar un nuevo ámbito para la DMZ que de servicio a través de un server dhcp relay

```json



{
            "subnet": "10.0.1.0/24", //------------------------------------>red DMZ
            "pools": [ { "pool": "10.0.1.100 - 10.0.1.150" } ], //------->POOL
            "option-data": [
                         {
                               // For each IPv4 subnet you most likely need to specify at
                                // least one router.
                             "name": "routers",
                             "data": "10.0.1.1" //------------------------->ROUTER
                         },

                        {
              
                            "name": "domain-name-servers",
                            "data": "8.8.8.8" //----------------------------->DNS
      
                        }
            ],
            "relay":{"ip-addresses":["192.168.10.1"]} //---interfaz DMZ del mikrotik
        }
```

El servido mikrotik se configura como dhcp relay
```sh
$ ip dhcp-relay add name=DMZ-LAN-Relay interface=DMZ dhcp-server=192.168.10.4 local-address=10.0.1.1 disabled=no 
```

## Clases de clientes
(***Falta definir en el proyecto el criterio para clasificar los clientes **) 

~~

En un servidor KEA DHCP, las "clases de clientes" son grupos lógicos que puedes definir para clasificar y tratar de manera diferente a los clientes DHCP basados en ciertas características, como su tipo de dispositivo, su hardware, sus opciones de configuración específicas, su ubicación en la red, etc. Estas clases te permiten aplicar políticas de asignación de direcciones IP y opciones de configuración personalizadas a grupos específicos de clientes. Las clases de clientes son especialmente útiles en entornos donde diferentes tipos de dispositivos o usuarios requieren diferentes configuraciones de red.

Para definir clases de clientes en KEA DHCP, debes especificar las características que deseas utilizar para clasificar a los clientes. Esto se hace en la configuración del servidor DHCP mediante el uso de expresiones y condiciones lógicas que coincidan con las características de los clientes. Algunas características comunes que se utilizan para definir clases de clientes incluyen:

   * Opción de clase de identificación (Option Class Identifier): Puedes utilizar la opción de clase de identificación en el mensaje DHCP del cliente para identificarlo y asignarlo a una clase específica.

   * Dirección MAC (Hardware Address): Puedes utilizar la dirección MAC del cliente para identificar y clasificar dispositivos específicos.

   * Subred de origen: Puedes basarte en la subred de origen desde la cual el cliente realiza la solicitud DHCP.

   * Identificadores de cliente (Client Identifiers): Puedes utilizar otros identificadores específicos proporcionados por el cliente para clasificarlo.

Una vez que hayas definido tus clases de clientes en la configuración KEA DHCP, puedes asignar políticas de asignación de direcciones IP, opciones de configuración y otros parámetros específicos a cada clase. Esto te permite personalizar la forma en que el servidor DHCP responde a diferentes tipos de clientes.

Aquí hay un ejemplo básico de cómo se ve la definición de clases de clientes en la configuración de KEA DHCP:

```json

``
    "Dhcp4": {
        "client-classes": [
            {
                "name": "clase-cliente-1",
                "test": "option[77].text == 'cliente-1'"
            },
            {
                "name": "clase-cliente-2",
                "test": "substring(hardware, 1, 3) == 00:11:22"
            }
        ]
    }
}
```

En este ejemplo, se definen dos clases de clientes ("clase-cliente-1" y "clase-cliente-2") basadas en diferentes criterios, como el valor de la opción de clase de identificación y los primeros tres bytes de la dirección MAC. Luego, puedes asignar políticas y configuraciones específicas a cada clase de cliente en la configuración de reserva o en otras partes de la configuración del servidor KEA DHCP.

