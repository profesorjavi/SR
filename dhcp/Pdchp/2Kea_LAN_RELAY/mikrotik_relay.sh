-----------DHCP RELAY (https://wiki.mikrotik.com/wiki/Manual:IP/DHCP_Relay)
Nuestro servidor DHCP Kea funcionara como dchp local y ademas atendera las peticiones del mikrotik(relay) para la zona DMZ
ip dhcp-relay add name=DMZ-LAN-Relay interface=DMZ dhcp-server=192.168.10.4 local-address=10.0.1.1 disabled=no 