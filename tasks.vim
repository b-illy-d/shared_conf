function! MoveTaskToTasks()
  let today = strftime("- %m/%d")
  let task = getline(".")

  " Open tasks.txt
  execute "edit tasks.txt"

  " Search for today's date; if not found, add it at the bottom
  if search('^' . today, 'w') == 0
    call append(line('$'), today)
  endif

  " Find today's date again and insert the task below it
  call search('^' . today, 'w')
  call append(line('.') + 1, '  ... ' . task[2:])  " Change `- ` to `... `

  " Save tasks.txt
  write

  " Return to todo.txt and delete the task
  execute "edit todo.txt"
  execute "normal! dd"
  write
endfunction

" Map this function to <leader>m
augroup TodoTasks
  autocmd!
  autocmd BufRead,BufNewFile todo.txt,tasks.txt nnoremap <buffer> <leader>d :s/^- /+ /<CR>
  autocmd BufRead,BufNewFile todo.txt,tasks.txt nnoremap <buffer> <leader>p :s/^- /... /<CR>
  autocmd BufRead,BufNewFile tasks.txt nnoremap <buffer> <leader>td :put =strftime("- %m/%d")<CR>
  autocmd BufRead,BufNewFile todo.txt nnoremap <buffer> <leader>m :call MoveTaskToTasks()<CR>
augroup END

