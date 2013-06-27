#!/bin/bash
#
# Autor: Mikel Fortuna (@FoRTu) 05/06/2013
#
#  Script para contar cuantos equipos hay en la red
#  con posibilida de de buscar en distintas redes.
#
#  Una vez hechos los calculos el resultado se guarda
#  en una base de datos SQLite.
#
#  Sera necesario tener las siguientes aplicaciones
#  instaladas en el sistema para que el script funcione:
#
#  fping
#  sqlite3
#
#  Para instalarlos en un sistemas Debian con el siguiente
#  comando seria suficiente:
#
#  sudo aptitude install fping sqlite3
#
########


# Ubicacion de la Base de Datos donde almacenar la informacion
BD="/home/usuario/Bases de Datos/Hosts_UP.db"

# Verificar la existencia de la base de datos. En caso de no exista la crea con el path y nombre indicado.
if [ ! -f "$BD" ];
then
        echo "La base de datos indicada no existe."
        echo "Se creara una nueva con el nombre y la ubicacion especificada."
        sqlite3 "$BD" "CREATE TABLE Hosts_UP (id INTEGER PRIMARY KEY AUTOINCREMENT, up INT, fecha DATETIME);"
fi

# Contar los equipos que esten en marcha en cada red.
let net_0=`fping -r 1 -ga "192.168.1.0/24" 2>/dev/null | wc -l`
let net_1=`fping -r 1 -ga "192.168.2.0/24" 2>/dev/null | wc -l`
# let net_X=`fping -r 1 -ga "192.168.X.0/24" 2>/dev/null | wc -l`

# Sumar el resultado de cada red.
let hosts=$net_0+$net_1
# let hosts=$net_0+$net_1+$net_X....

# Guardar la suma de equipos y la fecha actual en la base de datos Sqlite.
sqlite3 "$BD" "INSERT INTO Hosts_UP (fecha,up) VALUES (datetime('now', 'localtime'), '"$hosts"');"

# Hacer una cosnulta SQL a la base de datos para que nos devulva toda la informacion guardada.
sqlite3 "$BD" 'SELECT * FROM Hosts_UP;'


