" Hi mom
runtime coc_settings.vim
runtime buftabline_settings.vim
runtime mergetool_settings.vim
set guifont=Jetbrains\ Mono:h16
colorscheme slate
set nu rnu
set scrolloff=10
set tabstop=4 softtabstop=4 expandtab smartindent
set autowrite
" opening a new buffer keeps the current one open but hides it
set hidden
if &diff
    set lines=94 columns=180
else
    set lines=94 columns=100
endif
set hlsearch
set history=100
set backspace=indent,eol,start

" by default, the indent is 2 spaces. 
set shiftwidth=2
set softtabstop=2
set tabstop=2

" for html/rb files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab

set nocompatible              " be iMproved, required

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'ap/vim-buftabline'
Plug 'github/copilot.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'https://github.com/adelarsq/vim-matchit'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'leafgarland/typescript-vim'
Plug 'lilydjwg/colorizer'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mhinz/vim-grepper'
Plug 'mlaursen/vim-react-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pangloss/vim-javascript'
Plug 'preservim/nerdtree' |
    \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'prettier/vim-prettier', {
    \ 'do': 'yarn install --frozen-lockfile --production' }
Plug 'samoshkin/vim-mergetool'

map <C-n> :NERDTreeToggle<CR>

map <Leader>f :FZF<CR>

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()

runtime prettier_settings.vim
runtime lightline_settings.vim

let g:fzf_layout = { 'down': '50%' }

" Replace
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>d :/\<<C-r><C-w>\> =<Return>n<S-*><S-n>
nnoremap <Leader>r yiwea={}<Esc>Pl
nnoremap gb :ls<CR>:b<Space>
nnoremap <C-j> :bprev<CR>
nnoremap <C-k> :bnext<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap ]Q :clast<CR>
nnoremap [Q :cfirst<CR>
nnoremap <Leader>b :bufdo

" List contents of all registers (that typically contain pasteable text).
nnoremap <silent> "" :registers "0123456789*+.:%#-/=_<CR>
nnoremap <Leader>t :below term<CR>

"shortcut for switching between code and terminal
noremap <C-/> <C-w>j
tnoremap <C-/> <C-w>kerm<CR>

" comment and un-comment lines
command! -range Comment :execute "'<,'>normal! I// <Esc>"
command! -range UnComment :execute "'<,'>normal! ^3x"
vnoremap <Leader>c :Comment<CR>
vnoremap <Leader>C :UnComment<CR>
nnoremap <Leader>c V:Comment<CR>
nnoremap <Leader>C V:UnComment<CR>

" vim-grepper
nnoremap <Leader>g mQ:Grepper -tool rg<CR>
nnoremap <Leader>x :cclose<CR>`Q
nnoremap <leader>G :Grepper -tool rg -open -switch -cword -noprompt<cr>

" Github copilot
imap <D-]> <M-]>
imap <D-[> <M-[>

" diff navigation
nmap <expr> <Tab> &diff ? ']c' : '<Tab>'
nmap <expr> <S-Tab> &diff ? '[c' : '<S-Tab>'

" I always type these too quick
command! W :w
command! WQ :w
command! QW :w
command! Q :w

" NERDTreeGit
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'*',
                \ 'Staged'    :'+',
                \ 'Untracked' :'∆',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'—',
                \ 'Deleted'   :'✗',
                \ 'Dirty'     :'>',
                \ 'Ignored'   :'ø',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }
let g:NERDTreeGitStatusConcealBrackets = 1 " default: 0

" diff
if &diff
    set diffopt+=iwhite
    set cursorline
endif
