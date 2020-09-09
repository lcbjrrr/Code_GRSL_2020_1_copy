FROM ubuntu:18.04
COPY . / 
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && apt-get -y install bash octave gnuplot aptitude --no-install-recommends
RUN aptitude install fonts-freefont-otf
RUN cd ./Code_matlab/ && octave ./imagem_real_lin_radial_flev.m
ENTRYPOINT [ "octave" ]
CMD ["/svd.m"]