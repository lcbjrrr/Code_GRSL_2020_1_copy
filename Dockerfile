FROM ubuntu:18.04
COPY . / 
RUN apt-get -y update && apt-get -y install octave gnuplot aptitude 
RUN aptitude install fonts-freefont-otf
RUN cd ./Code_matlab/ && octave ./imagem_real_lin_radial_flev.m
