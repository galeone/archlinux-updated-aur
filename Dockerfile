FROM base/archlinux
MAINTAINER Paolo Galeone <nessuno@nerdz.eu>

RUN pacman -Sy haveged archlinux-keyring --noconfirm && haveged -w 1024 -v 1 && \
    pacman-key --init && pacman-key --populate archlinux && pacman -Syy && \
    pacman -Su base-devel yajl wget ca-certificates openssl \
    git subversion nodejs npm gcc-libs --noconfirm && pacman-db-upgrade

RUN useradd -m -s /bin/bash aur && echo "aur ALL = NOPASSWD: /usr/bin/pacman" >> /etc/sudoers

USER aur
ENV PATH /usr/bin/core_perl:$PATH

RUN cd /tmp && curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/cower-git.tar.gz && \
    tar zxvf cower-git.tar.gz && cd cower-git && makepkg

RUN cd /tmp && curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/expac-git.tar.gz && \
    tar zxvf expac-git.tar.gz && cd expac-git && makepkg

USER root
RUN pacman -U /tmp/cower-git/*.xz /tmp/expac-git/*.xz --noconfirm

USER aur
RUN cd /tmp && curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz && \
    tar zxvf pacaur.tar.gz && cd pacaur && makepkg

RUN sudo pacman -U /tmp/pacaur/*.xz --noconfirm && rm -rf /tmp/*
