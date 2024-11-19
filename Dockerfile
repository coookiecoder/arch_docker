FROM archlinux:base

RUN pacman -Syu --noconfirm

RUN pacman -Sy plasma --noconfirm
RUN pacman -Sy kde-applications --noconfirm

RUN pacman -Sy sudo git base-devel nasm check fuse libfdk-aac ffmpeg imlib2 xorg-drivers fakeroot xorg-xinit sddm dbus --noconfirm

RUN useradd abareux
RUN echo "abareux:abareux" | chpasswd
RUN echo "abareux ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir -p /home/abareux
RUN chown -R "abareux:abareux" /home/abareux
COPY xinitrc /home/abareux/.xinitrc

RUN useradd -m -G wheel -s /bin/bash builder && echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder

USER builder
WORKDIR /home/builder

RUN git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm

RUN rm -rf /home/builder/yay

RUN yay -S --noconfirm xrdp xorgxrdp

USER root

RUN mkdir -p /etc/X11
COPY Xwrapper.config /etc/X11/Xwrapper.config

RUN pacman -Sy git --noconfirm
RUN pacman -Sy vim --noconfirm
#RUN DEBIAN_FRONTEND=noninteractive apt install cargo -y
#RUN DEBIAN_FRONTEND=noninteractive apt install npm -y
#RUN DEBIAN_FRONTEND=noninteractive apt install curl -y
#RUN DEBIAN_FRONTEND=noninteractive apt install wget -y
#RUN DEBIAN_FRONTEND=noninteractive apt install clang -y
#RUN DEBIAN_FRONTEND=noninteractive apt install clangd -y
#RUN DEBIAN_FRONTEND=noninteractive apt install llvm -y
#RUN DEBIAN_FRONTEND=noninteractive apt install cmake -y
#RUN DEBIAN_FRONTEND=noninteractive apt install libglfw3-dev -y
#RUN DEBIAN_FRONTEND=noninteractive apt install libclang-dev -y
#RUN DEBIAN_FRONTEND=noninteractive apt install libclang-cpp-dev -y

COPY ./start.sh /start.sh

RUN chmod 707 /start.sh

ENTRYPOINT [ "bash" , "/start.sh" ]
