au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" --- virtualenv autodetect (.venv in project root) ---
function! UseVenvIfPresent() abort
  let l:root = finddir('.venv', expand('%:p:h').';')
  if !empty(l:root)
    let l:python = fnamemodify(l:root, ':p') . '/bin/python'
    if filereadable(l:python)
      let g:python3_host_prog = l:python
      let $VIRTUAL_ENV = fnamemodify(l:root, ':p')
    endif
  endif
endfunction
autocmd BufEnter,BufReadPost *.py call UseVenvIfPresent()

let g:python_highlight_all = 1

