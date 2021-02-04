FROM archlinux:latest

RUN pacman -Syu --noconfirm && pacman -S --noconfirm git vim nodejs wget zsh npm python-pip cmake rust jupyter-notebook sudo base-devel  && \
      git config --global user.name "John Doe" && \
      git config --global user.email johndoe@example.com

RUN useradd builduser -m  && \
	passwd -d builduser && \
	printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers && \
	sudo -u builduser bash -c 'cd ~ && curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/evcxr_jupyter.tar.gz && tar -xvf evcxr_jupyter.tar.gz&& \ 
	cd evcxr_jupyter && makepkg -s --noconfirm' && \
	export PATH=$PATH:/root/.cargo/bin && \ 
	cargo install evcxr_jupyter && evcxr_jupyter --install

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

ARG WORKSPACE=/root 
WORKDIR $WORKSPACE

COPY .vimrc ${WORKSPACE}/.vimrc 
COPY plug.vim ${WORKSPACE}/.vim/autoload/plug.vim

RUN vim +PlugInstall +qall 

CMD ["zsh"]
