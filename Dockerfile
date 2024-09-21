FROM archlinux:base

RUN pacman -Syu --noconfirm

RUN pacman -Sy plasma --noconfirm
RUN pacman -Sy kde-applications --noconfirm

RUN pacman -Sy sudo git base-devel nasm check fuse libfdk-aac ffmpeg imlib2 xorg-drivers --noconfirm

#FUCK YOU MAKEPKG

RUN useradd abareux
RUN echo "abareux:abareux" | chpasswd
RUN echo "abareux ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER abareux

WORKDIR /home/abareux
RUN git clone https://aur.archlinux.org/xrdp.git
RUN chown -R abareux /home/abareux
WORKDIR xrdp
RUN yes Y | makepkg -si

#END FUCK YOU MAKEPKG

USER root

WORKDIR /home/abareux
RUN rm -rf xrdp

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
