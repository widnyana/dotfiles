function GetSessionFileName() abort
    if len(argv()) > 0
    return substitute(fnamemodify(argv()[0], ':p:h'), "/", "_", "g")
    endif
    return substitute(fnamemodify(getcwd(), ':p:h'), "/", "_", "g")
endfunction!

let g:session_path = join(['~/.config/nvim/sessions/', GetSessionFileName(), '.vim'], '')

" Save session on quitting Vim
autocmd VimLeave * NERDTreeClose
autocmd VimLeave * execute 'mksession!' g:session_path

" Restore session function
function RestoreSession() abort
    execute 'source' g:session_path
    autocmd VimEnter * NERDTree
endfunction!

map <leader>r  :call RestoreSession()<CR>

