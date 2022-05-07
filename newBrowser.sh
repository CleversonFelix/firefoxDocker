#!/bin/bash
trap 'echo \nAbortado com CTRL+C;exit 1' 2 
if [[ -z $1 ]] 
then
	echo 'Passe o usuário de PID 1000 para executar o Ambiente gráfico no container (Obrigatorio)'
fi
USER=$1
RUNTIME="/run/user/1000"
DIR="/home/$USER"
echo "$RUNTIME E $DIR" 

if [[ $2 == 'build' ]] 
then
	#####Criando o Dockerfile##########
cat << EOF > Dockerfile
FROM ubuntu:bionic
RUN apt-get update \\
&& apt-get install software-properties-common -y \\
&& add-apt-repository ppa:mozillateam/firefox-next -y \\
&& apt-get update \\
&& apt-get install firefox  -y \\
&& groupadd -g 1000 $USER && useradd -d /home/$USER -s /bin/bash -m $USER -u 1000 -g 1000
RUN \\
    apt-get install\\
        ffmpeg \\
        # The following package is used to send key presses to the X process.
        xdotool -y
USER $USER
ENV HOME /home/$USER
CMD firefox
EOF
docker build -t myfirefox . > MyfirefoxLog 2>&1
fi

#############Criando um novo containner utilizando a imagem criada pelo DockerFile##########3
docker run -d --rm -e DISPLAY -v $DIR/.Xauthority:/home/$USER/.Xauthority --net=host \
	--device /dev/snd \
	        -e PULSE_SERVER=unix:$RUNTIME/pulse/native \
		        -v $RUNTIME/pulse/native:$RUNTIME/pulse/native \
			        --group-add $(getent group audio | cut -d: -f3) \
				myfirefox >MyfirefoxLog 2>&1 &

