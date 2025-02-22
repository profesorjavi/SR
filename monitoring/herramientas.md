### Documentación: Monitorización de Servidores y Contenedores Docker con Prometheus, cAdvisor, Node Exporter y Grafana

#### Introducción
En entornos de servidores, especialmente aquellos que utilizan contenedores Docker, es fundamental monitorizar el rendimiento y la salud del sistema. Esta documentación explica las herramientas comunes utilizadas para la monitorización de servidores y contenedores Docker, centrándose en **Prometheus**, **cAdvisor**, **Node Exporter** y **Grafana**.

---

### 1. **Herramientas de Monitorización**

#### 1.1. **Prometheus**
- **¿Qué es?**: Prometheus es un sistema de monitorización y alerta de código abierto diseñado para recolectar y almacenar métricas de sistemas y servicios.
- **¿Para qué sirve?**: Recolecta métricas de diferentes fuentes (como Node Exporter y cAdvisor), las almacena en una base de datos de series temporales y permite consultarlas y analizarlas.
- **Características principales**:
  - Recolección de métricas en tiempo real.
  - Lenguaje de consulta flexible (PromQL).
  - Integración con sistemas de alerta.

#### 1.2. **cAdvisor (Container Advisor)**
- **¿Qué es?**: cAdvisor es una herramienta desarrollada por Google para monitorizar contenedores Docker.
- **¿Para qué sirve?**: Recolecta métricas específicas de los contenedores, como uso de CPU, memoria, red y disco.
- **Características principales**:
  - Monitorización en tiempo real de contenedores.
  - Integración nativa con Docker.
  - Exportación de métricas a Prometheus.

#### 1.3. **Node Exporter**
- **¿Qué es?**: Node Exporter es un agente que recolecta métricas del sistema operativo donde se ejecuta.
- **¿Para qué sirve?**: Proporciona métricas del servidor, como uso de CPU, memoria, disco, red y estado del sistema.
- **Características principales**:
  - Recolección de métricas a nivel de sistema operativo.
  - Exportación de métricas a Prometheus.
  - Fácil de instalar y configurar.

#### 1.4. **Grafana**
- **¿Qué es?**: Grafana es una herramienta de visualización de datos de código abierto.
- **¿Para qué sirve?**: Permite crear dashboards interactivos y gráficos basados en las métricas recolectadas por Prometheus.
- **Características principales**:
  - Soporte para múltiples fuentes de datos (Prometheus, MySQL, etc.).
  - Creación de dashboards personalizados.
  - Alertas basadas en métricas.

---

### 2. **Arquitectura de Monitorización**

#### 2.1. **Flujo de Datos**
1. **Node Exporter** recolecta métricas del sistema operativo.
2. **cAdvisor** recolecta métricas de los contenedores Docker.
3. **Prometheus** recolecta las métricas de Node Exporter y cAdvisor, y las almacena en su base de datos.
4. **Grafana** se conecta a Prometheus para visualizar las métricas en dashboards.

#### 2.2. **Diagrama de Arquitectura**
![esquema](img/grafana.png)
fuente: https://nontster.medium.com/line-notify-gateway-2-f117c20c6f62
---

### 3. **Uso Práctico**

#### 3.1. **Visualización de Métricas en Grafana**
- Crea un dashboard en Grafana para visualizar métricas como:
  - Uso de CPU y memoria del servidor (Node Exporter).
  - Uso de recursos de contenedores Docker (cAdvisor).
  - Tráfico de red y uso de disco.

#### 3.2. **Alertas en Prometheus**
- Configura alertas en Prometheus para notificarte si:
  - El uso de CPU supera el 90%.
  - Un contenedor consume más memoria de la esperada.
  - El disco está cerca de llenarse.
