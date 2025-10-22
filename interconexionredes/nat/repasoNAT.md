## **Batería de Ejercicios para consolidar: Source NAT**

### Objetivo general

Comprender el funcionamiento, configuración y utilidad del **Source NAT (SNAT)** en redes informáticas, así como diferenciarlo de otros tipos de NAT.

---

## **1. Ejercicios de comprensión teórica**

**1.1. Concepto básico**
Explica con tus palabras qué es una **Source NAT** y cuál es su principal finalidad en una red.

**1.2. Comparación de tipos de NAT**
Completa la tabla:

| Tipo de NAT     | Dirección IP modificada | Ejemplo de uso típico |
| --------------- | ----------------------- | --------------------- |
| Source NAT      | ?                       | ?                     |
| Destination NAT | ?                       | ?                     |
| Static NAT      | ?                       | ?                     |
| Masquerade      | ?                       | ?                     |

**1.3. Analiza esta afirmación:**

> “El Source NAT permite que múltiples hosts de una red privada accedan a Internet usando una única IP pública.”
> Explica por qué es cierta y qué mecanismo lo hace posible.

**1.4. Pregunta de reflexión:**
¿Qué pasaría si no se aplicara SNAT en una red local conectada a Internet a través de un router?

---

## **2. Ejercicios de aplicación práctica**

**2.1. Mikrotik / RouterOS – NAT básico**
Tienes la siguiente topología:

* LAN: `192.168.10.0/24`
* WAN: IP pública dinámica (asignada por ISP)
* Router Mikrotik

**Tarea:**
Indica el comando o configuración necesaria para permitir que los equipos de la LAN naveguen por Internet usando *masquerade*.

*(Ayuda: `/ip firewall nat add ...`)*

---

**2.2. Servidor Linux (iptables)**
Configura una regla de **SNAT** para que todas las conexiones salientes de `192.168.20.0/24` se traduzcan a la IP pública `203.0.113.25`.

*(Indica el comando iptables exacto y explica cada parámetro.)*

---

**2.3. Análisis de tráfico**
Tienes el siguiente escenario de conexión:

| Host origen | IP origen    | IP destino | IP pública router | IP destino final |
| ----------- | ------------ | ---------- | ----------------- | ---------------- |
| PC1         | 192.168.1.10 | 8.8.8.8    | 203.0.113.5       | 8.8.8.8          |

Describe cómo cambian las direcciones IP **antes y después del SNAT** al salir hacia Internet.

---

**2.4. KEA DHCP + SNAT**
Imagina que en un servidor Linux con **Kea DHCP** los clientes reciben IPs privadas del rango `10.0.0.0/24`.
Explica qué configuración NAT necesitarías en el firewall para que los clientes puedan acceder a Internet.

---

## 🔍 **3. Ejercicios de análisis y resolución de problemas**

**3.1. Diagnóstico**
Los equipos de la LAN (`192.168.0.0/24`) pueden hacer ping al router, pero no a 8.8.8.8.

* El router sí tiene acceso a Internet.
* Hay una regla de SNAT configurada, pero usa `src-address=192.168.1.0/24`.

**Pregunta:**
¿Cuál es el error y cómo lo corregirías?

---

**3.2. Captura de paquetes**
Analiza la siguiente captura (simplificada):

| Tiempo | IP Origen    | IP Destino    | Puerto Origen | Puerto Destino |
| ------ | ------------ | ------------- | ------------- | -------------- |
| 0.1s   | 192.168.1.10 | 172.217.3.110 | 34567         | 80             |
| 0.2s   | 203.0.113.8  | 172.217.3.110 | 62001         | 80             |

**Preguntas:**

* ¿Qué está ocurriendo entre la primera y la segunda línea?
* ¿Qué tipo de NAT se aplica?

---

**4. Laboratorio virtual**
Diseña una práctica en GNS3 que demuestre el funcionamiento de Source NAT.
Incluye:

* Topología
* Direccionamiento
* Configuración NAT
* Comandos de prueba

