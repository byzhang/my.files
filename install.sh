#!/usr/env sh

INSTALLDIR=${INSTALLDIR:-"$PWD/my.files"}
create_symlinks () {
    if [ ! -f ~/.vim ]; then
        echo "Now, we will create ~/.vim and ~/.vimrc files to configure Vim."
        ln -sfn $INSTALLDIR/vim ~/.vim
    fi

    if [ ! -f ~/.vimrc ]; then
        ln -sfn $INSTALLDIR/vim/vimrc ~/.vimrc
    fi

    if [ ! -f ~/.tmux ]; then
        echo "Now, we will create ~/.tmux and ~/.tmux.conf files to configure tmux."
        ln -sfn $INSTALLDIR/tmux ~/.tmux
    fi

    if [ ! -f ~/.tmux.conf ]; then
        ln -sfn $INSTALLDIR/tmux/tmux.conf ~/.tmux.conf
    fi

    if [ -d ~/.zprezto ]; then
        echo "Now, we will configure zprezto."
        ln -sfn $INSTALLDIR/zprezto/bin ~/.zprezto/bin
        ln -sfn $INSTALLDIR/zprezto/zsh ~/.zprezto/zsh
        cp -Rf $INSTALLDIR/zprezto/modules ~/.zprezto/modules
        cp -Rf $INSTALLDIR/zprezto/runcoms ~/.zprezto/runcoms
    fi
  }

which git > /dev/null
if [ "$?" != "0" ]; then
  echo "You need git installed to install"
  exit 1
fi

which vim > /dev/null
if [ "$?" != "0" ]; then
  echo "You need vim installed to install"
  exit 1
fi

if [ ! -d "$INSTALLDIR" ]; then
    echo "As we can't find my.files in the current directory, we will create it."
    git clone git://github.com/byzhang/my.files.git $INSTALLDIR
    create_symlinks
    cd $INSTALLDIR

else
    echo "Seems like you already are one of ours, so let's update Vimified to be as awesome as possible."
    cd $INSTALLDIR
    #git pull origin master
    create_symlinks
fi

if [ ! -d "vim/bundle" ]; then
    echo "Now, we will create a separate directory to store the bundles Vim will use."
    mkdir vim/bundle
    mkdir -p vim/tmp/backup vim/tmp/swap vim/tmp/undo
fi

if [ ! -d "vim/bundle/vundle" ]; then
    echo "Then, we install Vundle (https://github.com/gmarik/vundle)."
    git clone https://github.com/gmarik/vundle.git vim/bundle/vundle
fi

if [ ! -d "vim/sessions" ]; then
    echo "Now, we will create a separate directory to store the sessions"
    mkdir vim/sessions
fi

echo "Enjoy!"

vim +BundleInstall +qall 2>/dev/null

