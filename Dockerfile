#Escuela Politécnica Nacional
#Tema: Servicios de Red Basado en Contenedores
#Autor: Andrés Lenin Yazán Endara
#Servicio: DHCPv4
#Archivo: Dockerfile

## Imagen Base
# El servicio dhcpd se implementara sobre una imagen base Alpine Linux
# versión 3.14
FROM alpine:3.14

## Etiqueta
LABEL authors="Yazán Endara Andrés Lenin" 
LABEL build-date="19/01/2023"
LABEL version="1.0"
LABEL description="Servidor DHCPv4 ISC sobre Contenedor Docker"

## Instalación de dependencias
#Actualizamos el repositorio de Alpine mediante apk update
#Instalamos el servidor dhcp mediante apk add dhcp
RUN apk update; apk add dhcp 



## Archivos de Configuración
RUN touch ./var/lib/dhcp/dhcpd.leases
RUN chown -R root:root ./var/lib/dhcp/dhcpd.leases

## Copiar Archivo de Configuración dhcpd.conf
COPY dhcpd.conf ./etc/dhcp/

## Directorio de Trabajo
#Establecemos el directorio de trabajo en el direcotrio raiz /
WORKDIR ./

## Puertos de Escucha de Contenedor
# Exponemos los puertos requeridos para las respuestas del servidor dhcp 
# y las solicitudes de los clientes dhcp
# Puertos DHCPv4 servidor-cliente y DHCPv6 servidor-cliente
EXPOSE 67/udp 68/udp 547/tcp 547/udp 546/tcp 546/udp

## Variables de Entorno
ENV IFDHCP="eth0"

## Comando de Ejecución
# Configuramos comandos para el despligue del servicio dhcpd en el contenedor

#Ejecutar servicio dhcpd
#/usr/sbin/dhcpd
# Opciones de Ejcución:
#-4: DHCP con direccionamiento IPv4
#-6: DHCP con direccionamiento IPv6
#-f: Ejcutar dhcpd como Proceso de Primer plano (Foreground) (Background Default)
#-p: Puerto UDP DHCP (67/udp Default)
#-d: Registro de standar errors
#-cf: Archivo de configuración DHCP alternativo (dhcpd.conf)
#-lf: Archivo de arrendamiento DHCP alternativo (dhcpd.leases)
#-pf: Archivo de proceso DHCP alternativo (dhcpd.pid)
#-q: Omitir mensaje de inicio DHCP
#-T: Pueba de base de datos de arrendamientos
#-play: 

#DHCPv4
##ENTRYPOINT
ENTRYPOINT ["/usr/sbin/dhcpd"]
#ENTRYPOINT /usr/sbin/dhcpd eth0 (No funciona)
#ENTRYPOINT /usr/sbin/dhcpd ${IFDHCP}
#ENTRYPOINT ["/usr/sbin/dhcpd",${IFDHCP}]
##CMD
CMD ["-4","-f","-d","-cf","/etc/dhcp/dhcpd.conf","-lf","/var/lib/dhcp/dhcpd.leases","-user","root","-group","root","eth0"]
