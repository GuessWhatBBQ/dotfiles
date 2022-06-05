function! myspacevim#after() abort
    au VimLeave,VimSuspend * set guicursor=a:ver90
endfunction