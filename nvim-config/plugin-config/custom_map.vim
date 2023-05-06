" from https://dery.dev/posts/july-vim-setup/
map <leader>`  :NERDTreeToggle<CR>
map <leader>~  :NERDTreeFind<CR>

nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <silent> <C-W><Up>     :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <C-W><Down>   :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent> <C-W><Left>   :exe "vert resize " . (winwidth(0) * 2/3)<CR>
nnoremap <silent> <C-W><Right>  :exe "vert resize " . (winwidth(0) * 3/2)<CR>