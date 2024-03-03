# Instalar ROS noetic
FROM ros:noetic-ros-base-buster

# Añadir un usuario llamado tknika con el id 1000
ARG USERNAME=tknika
ARG USERID=1000
RUN groupadd --gid $USERID $USERNAME && \
    useradd --uid $USERID --gid $USERID -ms /bin/bash $USERNAME && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Instalar paquetes de linux de manera desatendida
RUN apt-get update && apt-get install -y \
    nano \
    terminator \
    wget \
    unzip

RUN apt-get install python3-pip -y
RUN pip3 install pynput

# Instalar el paquete cv-camera de ros
RUN apt-get install ros-noetic-cv-camera -y

# Instalar el paquete rqt de ros
RUN apt-get install -y ros-noetic-rqt ros-noetic-rqt-common-plugins -y

# Instalar un paquete para control de la posición (no probado)
RUN apt-get install ros-noetic-move-base -y

# Instalar los paquetes de controladores para el Jetbot (no probado)
RUN apt-get install ros-noetic-joint-state-controller ros-noetic-velocity-controllers ros-noetic-joint-trajectory-controller ros-noetic-diff-drive-controller ros-noetic-xacro ros-noetic-amcl ros-noetic-rviz ros-noetic-map-server wget -y

# Instalar el paquetes de gazebo11
RUN apt-get install gazebo11 ros-noetic-gazebo-ros-control ros-noetic-gazebo-plugins -y

# Instalar la versión 4.1.0.25 de OpenCV
RUN pip3 install opencv-python==4.1.0.25

# Eliminar los paquetes de la cache
RUN apt-get -y clean

# Liminar los archivos de configuración de los paquetes
RUN apt-get -y purge

# Crear una carpeta en /home/.gazebo
RUN mkdir /home/${USERNAME}/.gazebo

# Descomprimir mundos y modelos para gazebo
ADD gazebo_resources.tar.xz /home/${USERNAME}/.gazebo/

# Crear el workspace
ARG INIT_WORKDIR_FOLDER=/init_workspace
ARG WORKDIR_FOLDER=/workspace
RUN mkdir -p ${INIT_WORKDIR_FOLDER}/src
RUN mkdir -p ${WORKDIR_FOLDER}
WORKDIR ${INIT_WORKDIR_FOLDER}
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd ${INIT_WORKDIR_FOLDER}; catkin_make'

# Descomprimir modelos navegación jetbot y lo configuramos
ADD jetbot_ws.zip ${INIT_WORKDIR_FOLDER}/src
RUN unzip ${INIT_WORKDIR_FOLDER}/src/jetbot_ws.zip -d ${INIT_WORKDIR_FOLDER}/src
RUN mv ${INIT_WORKDIR_FOLDER}/src/jetbot_diff_drive/jetbot_navigation /tmp/
COPY catkin_workspace.cmake /opt/ros/noetic/share/catkin/cmake/
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd ${INIT_WORKDIR_FOLDER}; catkin_make'
RUN mv /tmp/jetbot_navigation ${INIT_WORKDIR_FOLDER}/src/jetbot_diff_drive/

# Cambiar el propietario de las carpetas ${INIT_WORKDIR_FOLDER}, ${WORKDIR_FOLDER}
# y /home/${USERNAME}/.gazebo a $USERNAME
RUN chown -R ${USERNAME}:${USERNAME} ${INIT_WORKDIR_FOLDER}
RUN chown -R ${USERNAME}:${USERNAME} ${WORKDIR_FOLDER}
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.gazebo

# Añadir el usuario $USERNAME al grupo video
RUN addgroup ${USERNAME} video

# Copiar script de sincronización
ADD workspace-sync.sh /app/workspace-sync.sh
RUN chown ${USERNAME}:${USERNAME} /app/workspace-sync.sh
RUN chmod 755 /app/workspace-sync.sh

# Cambiar el usuario a $USERNAME
USER ${USERNAME}

# Cambiar el directorio de trabajo a ${WORKDIR_FOLDER}
WORKDIR ${WORKDIR_FOLDER}

# Ejecutar el script de sincronización al iniciar el contenedor
ENTRYPOINT [ "/app/workspace-sync.sh" ]