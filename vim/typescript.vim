" set tsc to makeprg
augroup TypeScriptProject
  autocmd!
  autocmd BufEnter,BufRead *.ts,*.tsx call SetupTSC()
augroup END

function! SetupTSC()
  if filereadable(findfile("tsconfig.json", ".;"))
    let &makeprg = "npx tsc --noEmit --resolveJsonModule"
  endif
endfunction
