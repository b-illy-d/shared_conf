au BufNewFile,BufRead *.py
    \ setlocal tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ textwidth=88
    \ expandtab
    \ autoindent
    \ fileformat=unix

augroup badws
  autocmd!
  autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
augroup END

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

