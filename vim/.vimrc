if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Vim-plug
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'wakatime/vim-wakatime'


Plug 'elixir-editors/vim-elixir'

Plug 'pangloss/vim-javascript'

Plug 'hail2u/vim-css3-syntax'
Plug 'cakebaker/scss-syntax.vim'
call plug#end()

set number relativenumber
