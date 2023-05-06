if (has("termguicolors") && $TERM_PROGRAM ==# 'iTerm.app')
    set termguicolors
endif

set cursorline
set background=dark

autocmd vimenter * ++nested colorscheme gruvbox

hi Error        ctermfg=204 ctermbg=NONE guifg=#ff5f87 guibg=NONE
hi Warning      ctermfg=178 ctermbg=NONE guifg=#D7AF00 guibg=NONE
hi Folded       ctermfg=grey guifg=grey ctermbg=NONE guibg=NONE
hi Normal       ctermbg=NONE guibg=NONE
hi SignColumn   ctermbg=235 guibg=#262626
hi LineNr       ctermfg=grey guifg=grey ctermbg=NONE guibg=NONE
hi CursorLineNr ctermbg=NONE guibg=NONE ctermfg=178 guifg=#d7af00

hi LspDiagnosticsDefaultError   ctermfg=204 ctermbg=NONE guifg=#ff5f87 guibg=NONE
hi LspDiagnosticsDefaultWarning ctermfg=178 ctermbg=NONE guifg=#D7AF00 guibg=NONE

let g:gitgutter_set_sign_backgrounds = 0

"-- Whitespace highlight --
hi ExtraWhitespace ctermbg=204 guibg=#ff5f87
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"-- Vimwiki color --
"-- this using palenight color scheme --
hi VimwikiHeader1 ctermbg=NONE guibg=NONE ctermfg=180 guifg=#ffcb6b
hi VimwikiHeader2 ctermbg=NONE guibg=NONE ctermfg=39 guifg=#82b1ff
hi VimwikiHeader3 ctermbg=NONE guibg=NONE ctermfg=38 guifg=#89ddff
hi VimwikiHeader4 ctermbg=NONE guibg=NONE ctermfg=38 guifg=#89ddff
hi VimwikiHeader5 ctermbg=NONE guibg=NONE ctermfg=38 guifg=#89ddff
hi VimwikiHeader6 ctermbg=NONE guibg=NONE ctermfg=38 guifg=#89ddff

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#fugitive#enabled = 1
let g:airline#extensions#coc#enabled = 0

let NERDTreeShowHidden = 1
