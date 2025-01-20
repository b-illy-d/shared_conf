let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_path = "/opt/homebrew/bin/prettier"
let g:prettier#config#print_width = 100
let g:prettier#config#tab_width = 2
let g:prettier#config#use_tabs = 0
let g:prettier#config#semi = 'true'
let g:prettier#config#single_quote = 'true' 
let g:prettier#config#trailing_comma = "all"
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#bracket_same_line = 'false' 
let g:prettier#config#jsx_bracket_same_line = 'false' 
let g:prettier#config#arrow_parens = "always"
let g:prettier#config#parser = "typescript"
let g:prettier#config#end_of_line = "lf"
let g:prettier#config#trailing_comma = "all"
let g:prettier#config#quote_props = "as-needed"

nmap <Leader>py <Plug>(Prettier)
