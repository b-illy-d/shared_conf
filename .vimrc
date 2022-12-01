" Hi mom
runtime vimrc_zon.vim
runtime coc_settings.vim
set guifont=Jet\ Brains\ Mono\ NL\ 12
colorscheme slate
set nu rnu
set so=10
set tabstop=4 softtabstop=4 expandtab smartindent
set autowrite
" opening a new buffer keeps the current one open but hides it
set hidden
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>d :/\<<C-r><C-w>\> =<Return>n<S-*><S-n>
nnoremap <Leader>r yiwea={}<Esc>Pl
nnoremap gb :ls<CR>:b<Space>
nnoremap <C-j> :bprev<CR>
nnoremap <C-k> :bnext<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap ]Q :clast<CR>
nnoremap [q :cfirst<CR>
nnoremap <Leader>b :bufdo 
" List contents of all registers (that typically contain pasteable text).
nnoremap <silent> "" :registers "0123456789*+.:%#-/=_<CR>

set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Bundle 'geoffharcourt/vim-matchit'
Plugin 'pangloss/vim-javascript'
Plugin 'leafgarland/typescript-vim'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'mlaursen/vim-react-snippets'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-surround'
Plugin 'kaicataldo/material.vim', { 'branch': 'main' }
Plugin 'lilydjwg/colorizer'
Plugin 'puremourning/vimspector'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
if filereadable(expand("~/vundle.vim"))
    source ~/vundle.vim
endif
map <C-n> :NERDTreeToggle<CR>
call vundle#end()
filetype plugin indent on

let g:material_theme_style='ocean'
let g:material_terminal_italics=1
colorscheme material

