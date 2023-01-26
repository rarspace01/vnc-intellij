# Start with Ubuntu base image
FROM ubuntu:14.04
MAINTAINER rarspace01

# Install LXDE, VNC server, XRDP and Firefox
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  firefox \
  lxde-core \
  lxterminal \
  tightvncserver \
  xrdp

# Set user for VNC server (USER is only for build)
ENV USER root
# Set default password
COPY password.txt .
RUN echo password | vncpasswd
# Expose VNC port
EXPOSE 5901

# Set XDRP to use TightVNC port
RUN sed -i '0,/port=-1/{s/port=-1/port=5901/}' /etc/xrdp/xrdp.ini

# Copy VNC script that handles restarts
COPY vnc.sh /opt/
CMD ["rm /tmp/.X1-lock /tmp/.X11-unix/X1 && vncserver :1 -geometry 1280x800 -depth 24 && tail -F /root/.vnc/*.log"]
