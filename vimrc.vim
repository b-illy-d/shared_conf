set guifont=Hack:h16
" Hi mom
source $HOME/shared_conf/buftabline_settings.vim
source $HOME/shared_conf/coc_settings.vim
source $HOME/shared_conf/lightline_settings.vim
source $HOME/shared_conf/mergetool_settings.vim
source $HOME/shared_conf/prettier_settings.vim
source $HOME/shared_conf/python.vim
source $HOME/shared_conf/typescript.vim

" haters gonna hate
set hidden

" show line numbers
set number
autocmd BufEnter * :setlocal relativenumber
autocmd BufLeave,FocusLost * :setlocal norelativenumber
autocmd InsertEnter * :setlocal norelativenumber
autocmd InsertLeave * :setlocal relativenumber

function! g:ToggleNuMode()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

map <C-l> :call g:ToggleNuMode()<CR>

set scrolloff=10

set autowrite
if &diff
    set lines=94 columns=200
else
    set lines=94 columns=100
endif
set hlsearch
set history=100
" only affects insert mode
set backspace=indent,eol,start

" by default, the indent is 2 spaces. 
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set smartindent

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
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-flagship'
Plug 'tpope/vim-repeat'
Plug 'svermeulen/vim-subversive'
Plug 'git@github.com:tpope/vim-speeddating'
Plug 'github/copilot.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'https://github.com/adelarsq/vim-matchit'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'lilydjwg/colorizer'
Plug 'vim-scripts/Rainbow-Parenthesis'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'mhinz/vim-grepper'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pangloss/vim-javascript'
Plug 'prettier/vim-prettier', {
    \ 'do': 'npm install' }
Plug 'puremourning/vimspector'
Plug 'purescript-contrib/purescript-vim'
Plug 'ap/vim-buftabline'

" Git
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'preservim/nerdtree' |
    \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'samoshkin/vim-mergetool'

" Node/JS
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mlaursen/vim-react-snippets'

" Python
Plug 'vim-scripts/indentpython.vim'
Plug 'nvie/vim-flake8'

" Go
Plug 'fatih/vim-go'

" Colorschemes
Plug 'sainnhe/everforest'
Plug 'sainnhe/sonokai'
Plug 'sonph/onehalf', { 'rtp': 'vim/' }

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()

map <C-t> :NERDTreeToggle<CR>

let g:VM_maps = {}
let g:VM_maps['Find Under']                  = '<C-n>'
let g:VM_maps['Find Subword Under']          = '<C-n>'
let g:VM_maps["Select All"]                  = '\\A' 
let g:VM_maps["Start Regex Search"]          = '\\/'
let g:VM_maps["Add Cursor Down"]             = '<C-Down>'
let g:VM_maps["Add Cursor Up"]               = '<C-Up>'
let g:VM_maps["Add Cursor At Pos"]           = '\\\'

let g:VM_maps["Visual Regex"]                = '\\/'
let g:VM_maps["Visual All"]                  = '\\A' 
let g:VM_maps["Visual Add"]                  = '\\a'
let g:VM_maps["Visual Find"]                 = '\\f'
let g:VM_maps["Visual Cursors"]              = '\\c'

map <Leader>f :FZF<CR>
let $FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name .git -o -name dist \) -prune -o -print'
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
nnoremap <Leader>t :rightb vertical terminal<CR>

" Vimspector
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver

"shortcut for switching between code and terminal
noremap <C-/> <C-w>j
tnoremap <C-/> <C-w>kerm<CR>

" comment and un-comment lines
vnoremap <Leader>c :Commentary<CR>
nnoremap <Leader>c :Commentary<CR>

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

" theme
if has('termguicolors')
  set termguicolors
endif
set background=dark
" let g:everforest_background = 'hard'
" let g:everforest_enable_italic = 1
" let g:everforest_better_performance = 1
" let g:sonokai_style = 'espresso'
" let g:sonokai_better_performance = 1
" let g:edge_better_performance = 1
" colorscheme everforest
colorscheme onehalfdark

" rainbow parentheses
runtime plugged/RainbowParenthesis/RainbowParenthsis.vim
