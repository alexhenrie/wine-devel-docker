FROM library/archlinux
ARG WINE_VER=4.19
RUN truncate -s 0 /etc/pacman.d/mirrorlist
RUN echo 'Server = http://bn-i.net/mirrors/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
RUN echo 'Server = http://mirrors.xmission.com/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
RUN perl -0777 -i -pe "s/^#\[multilib\]\n#Include = \/etc\/pacman.d\/mirrorlist$/[multilib]\nInclude = \/etc\/pacman.d\/mirrorlist/m" /etc/pacman.conf
RUN yes | pacman -Syu --needed gcc-libs-multilib
RUN pacman -Syu --noconfirm base-devel git pacman-contrib wine
RUN pacman -S --needed --noconfirm --asdeps $(pactree -l wine) #install all of Wine's optional dependencies
RUN cd /root && mkdir wine32 wine64
RUN git clone git://source.winehq.org/git/wine.git /root/wine
RUN cd /root/wine && git reset --hard wine-$WINE_VER #reset the master branch to the last release
RUN cd /root/wine64 && ../wine/configure --enable-win64 && make -sw -j`nproc`
RUN cd /root/wine32 && ../wine/configure --with-wine64=../wine64 && make -sw -j`nproc`
CMD cd /root && /usr/bin/bash
