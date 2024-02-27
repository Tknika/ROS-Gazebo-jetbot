# ROS Gazebo Jetbot 

Gazebon ROS bidez Jetbot robota simulatzeko irudia eta kontainerra sortuko dugu 

## Imagina sortu

Dockerfile bat denez lehendabizi "Dockerfile" karpeta bat sortu behar da eta bertan errepositorio oso hau sartu behar da.

Ondoren terminaletik dockerfile karpetan sartu eta docker irudiaren izena erabaki ondoren (nik ros_gazebo_jetbot deitu diot), agindu honen bitartez irudia sortu. Kontuz azken puntua ez ahazten!! (Dockerfile karpetan gaudelako . jartzen da bestela ruta jarri beharko genioke):
```bash
docker build -t ros_gazebo_jetbot .
```
Ondoren docker irudia sortu dela egiaztatzen dugu, agindu hau idatziz:
```bash
docker images
```
## Kontainerra sortu

Irudia dugula, kontenedorea sortu beharra dugu baina hori egin aurretik zenbait azalpen:
* Nire ekipoan curso_ros izeneko karpeta bat dut HOME barnean.
* Nire kontenedorearen izena rosGazeboJebotNET izango da
* Kontenedoreak nire ekipoaren komunikazio guztiak irekiak izango ditu
* Lehen sortu dugun imaginaren izena ros_gazebo_jetbot da

Hori dena kontutan izanda horrela sortuko dugu:
```bash
docker run --name rosGazeboJebotNET -it \
-e DISPLAY=$DISPLAY \
--device=/dev/dri:/dev/dri \
--device=/dev/snd:/dev/snd \
--privileged -v /dev/bus/usb:/dev/bus/usb \
-v $HOME/curso_ros/:/tmp/curso_ros/:rw \
-v /tmp/.X11-unix:/tmp/.X11-unix \
--net=host \
--env="QT_X11_NO_MITSHM=1" \
ros_gazebo_jetbot /bin/bash
```


## Kontainerraren erabilera

Garapen kontainerra erabiltzeko piztu beharra dago:
```bash
docker start rosGazeboJebotNET
```
Garapen kontainerrera sartzeko (tknika erabiltzailearekin):
```bash
docker exec -it --user tknika rosGazeboJebotNET /bin/bash
```

## Credits

Dev Containerra egitea lortzen dudanean eguneratuko dut.