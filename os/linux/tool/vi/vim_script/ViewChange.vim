command! -nargs=? Vc call s:viewChange(<f-args>)
function! s:viewChange(...)
    if a:0 >= 1 && a:1== "off"
        echo "ViewChange OFF"
        set wrap
        set nolist
        set nonumber
    else
        echo "ViewChange ON"
        set nowrap
        set list
        set number
    endif
endfunction
