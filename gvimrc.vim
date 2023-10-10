set guioptions=Aci

" OneDark
let g:onedark_hide_endofbuffer=1
let g:onedark_color_overrides = {
\ "background": {"gui": "#1A1C21", "cterm": "235", "cterm16": "0" },
\}

" Material
let g:material_theme_style='ocean-community'
let g:material_terminal_italics=1

syntax on
colorscheme onedark

hi DiffAdd      guifg=#aaff88  guibg=#003300  gui=none
hi DiffChange   guifg=NONE     guibg=NONE     gui=none
hi DiffDelete   guifg=#ffaa88  guibg=#330000  gui=none
hi DiffText     guifg=#00aaff  guibg=#444444  gui=bold
hi TablineSel   guifg=#00aaff  guibg=#444444  gui=bold
hi Tabline      guifg=#444444  guibg=NONE     gui=none
hi Pmenu        guifg=#dddddd  guibg=#333333  gui=none  
