#!/bin/bash

# Función para mostrar el banner
show_banner() {
    echo "
  #    # # ###### #       #####  ######  ####  #####   ##   #####  #####      ####  #    # 
  #    # # #      #       #    # #      #        #    #  #  #    #   #       #      #    # 
  #    # # #####  # ##### #    # #####   ####    #   #    # #    #   #        ####  ###### 
  # ## # # #      #       #####  #           #   #   ###### #####    #   ###      # #    # 
  ##  ## # #      #       #   #  #      #    #   #   #    # #   #    #   ### #    # #    # 
  #    # # #      #       #    # ######  ####    #   #    # #    #   #   ###  ####  #    # 
                                                                                          
    "
}

# Mostrar el banner
show_banner

# Verificar si el script se ejecuta como root
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, ejecuta este script como root"
    exit
fi

# Detectar todas las interfaces de red disponibles
INTERFACES=$(ls /sys/class/net | tr ' ' '\n')

# Mostrar las interfaces de red como una lista numerada
echo "Interfaces de red disponibles:"
i=1
for INTERFACE in $INTERFACES
do
    echo "$i: $INTERFACE"
    i=$((i+1))
done

# Seleccionar una interfaz de red para operar
read -p "Por favor, introduce el número de la interfaz de red que deseas utilizar: " NUMBER
INTERFACE=$(echo $INTERFACES | cut -d ' ' -f $NUMBER)

# Mostrar un menú de opciones
echo "Por favor, selecciona una opción:"
echo "1. Detener el modo monitor"
echo "2. Reiniciar el servicio de red"
echo "3. Verificar el estado de la interfaz de red"
read -p "Introduce el número de la opción que deseas ejecutar: " OPTION

# Ejecutar la opción seleccionada
case $OPTION in
    1)
        echo "Deteniendo el modo monitor..."
        if sudo airmon-ng stop $INTERFACE; then
            echo "Modo monitor detenido correctamente."
        else
            echo "Hubo un problema al detener el modo monitor. Verifica tu interfaz de red."
            exit 1
        fi
        ;;
    2)
        echo "Reiniciando el servicio de red..."
        if sudo service network-manager restart; then
            echo "Servicio de red reiniciado correctamente."
        else
            echo "Hubo un problema al reiniciar el servicio de red."
            exit 1
        fi
        ;;
    3)
        echo "Verificando el estado de la interfaz de red..."
        ifconfig $INTERFACE
        ;;
    *)
        echo "Opción no válida. Por favor, selecciona una opción del menú."
        ;;
esac
