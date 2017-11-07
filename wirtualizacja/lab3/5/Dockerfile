FROM centos:7
MAINTAINER pgalczynski
RUN useradd -ms kinga -p DockerLab -G users sudo
RUN useradd -ms jan -p DockerLab -G users sudo
RUN yum -y update
RUN yum -y install sudo
ADD sudousers /etc/sudoers

