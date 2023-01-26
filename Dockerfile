# Start with Ubuntu base image
FROM ubuntu:latest

#RUN apt-get update && apt-get install wget -y


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop tightvncserver xrdp p7zip wget dbus-x11 gnome-session-flashback dconf-cli

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install ./google-chrome-stable_current_amd64.deb

RUN mkdir -p /root/intellij && wget https://download.jetbrains.com/idea/ideaIU-2022.3.1.tar.gz -O /tmp/idea.tar.gz && tar -xf /tmp/idea.tar.gz -C /root/intellij && rm -rf /tmp/idea.tar.gz

ENV USER root

RUN printf "password\npassword\nn\n" | vncpasswd

EXPOSE 5901

RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=de_DE.UTF-8

ENV LANG de_DE.UTF-8 

COPY xstartup /root/.vnc/xstartup
#COPY xstartup /etc/X11/Xvnc-session

RUN chmod +x /root/.vnc/xstartup
#RUN chmod +x /etc/X11/Xvnc-session

# Set XDRP to use TightVNC port
RUN sed -i '0,/port=-1/{s/port=-1/port=5901/}' /etc/xrdp/xrdp.ini

# Copy VNC script that handles restarts
CMD rm /tmp/.X1-lock /tmp/.X11-unix/X1| true && vncserver :1 -geometry 1280x800 -depth 24 && tail -F /root/.vnc/*.log
