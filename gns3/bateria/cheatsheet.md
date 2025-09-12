## 1. **Configurar Interfaces**

### Ver interfaces disponibles

```bash
/interface print
```

### Configurar una interfaz (ejemplo: cambiar nombre y habilitar)

```bash
/interface set [find default-name=ether1] name=wan1 disabled=no
```

### Asignar IP a una interfaz

```bash
/ip address add address=192.168.1.1/24 interface=ether2
```

---

## 2. **Configurar IP**

### Listar IPs asignadas

```bash
/ip address print
```

### Agregar una IP a una interfaz

```bash
/ip address add address=10.0.0.1/24 interface=ether3
```

### Eliminar IP

```bash
/ip address remove [find address=10.0.0.1/24]
```

---

## 3. **Configurar NAT (Masquerade para salida a Internet)**

### Crear regla NAT Masquerade para salida por interfaz WAN (ejemplo ether1)

```bash
/ip firewall nat add chain=srcnat out-interface=ether1 action=masquerade
```

---

## 4. **Configurar DHCP Client (para obtener IP automáticamente)**

```bash
/ip dhcp-client add interface=ether1 disabled=no
```

---

## 5. **Configurar DHCP Server**

### Crear pool de IPs para asignar a clientes

```bash
/ip pool add name=dhcp_pool ranges=192.168.88.10-192.168.88.100
```

### Crear DHCP Server en interfaz bridge (o ether2)

```bash
/ip dhcp-server add name=dhcp1 interface=bridge1 address-pool=dhcp_pool disabled=no
```

### Configurar red DHCP

```bash
/ip dhcp-server network add address=192.168.88.0/24 gateway=192.168.88.1 dns-server=8.8.8.8
```

---

## 6. **Agregar una ruta estática**

```bash
/ip route add dst-address=0.0.0.0/0 gateway=192.168.1.254
```

---

## 7. **Ver reglas de firewall**

```bash
/ip firewall filter print
```

---

## 8. **Ejemplo completo de configuración básica:**

```bash
# Cambiar nombre interfaz WAN
/interface set [find default-name=ether1] name=wan1 disabled=no

# Asignar IP fija a LAN
/ip address add address=192.168.10.1/24 interface=ether2

# Configurar NAT masquerade para salida a Internet
/ip firewall nat add chain=srcnat out-interface=wan1 action=masquerade

# Crear pool DHCP
/ip pool add name=dhcp_pool ranges=192.168.10.10-192.168.10.50

# Crear DHCP Server en LAN
/ip dhcp-server add name=dhcp1 interface=ether2 address-pool=dhcp_pool disabled=no

# Configurar red DHCP
/ip dhcp-server network add address=192.168.10.0/24 gateway=192.168.10.1 dns-server=8.8.8.8

# Agregar ruta por defecto
/ip route add dst-address=0.0.0.0/0 gateway=192.168.1.254
```

