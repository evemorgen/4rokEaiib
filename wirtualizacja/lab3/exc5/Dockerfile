FROM centos:7
MAINTAINER pgalczynski
RUN yum -y update
RUN yum -y install sudo
ADD sudousers /etc/sudoers
RUN groupadd sudo
RUN useradd -m kinga
RUN echo DockerLab | passwd kinga --stdin
RUN usermod -a -G users kinga
RUN usermod -a -G sudo kinga
RUN useradd -m jan
RUN usermod -a -G users jan
RUN usermod -a -G sudo jan
RUN echo DockerLab | passwd jan --stdin
