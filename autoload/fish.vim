function! fish#Indent()
    let l:shiftwidth = shiftwidth()
    let l:prevlnum = prevnonblank(v:lnum - 1)
    if l:prevlnum ==# 0
        return 0
    endif
    let l:indent = 0
    let l:prevline = getline(l:prevlnum)
    if l:prevline =~# '\v^\s*switch>'
        let l:indent = l:shiftwidth * 2
    elseif l:prevline =~# '\v^\s*%(begin|if|else|while|for|function|case)>'
        let l:indent = l:shiftwidth
    endif
    let l:line = getline(v:lnum)
    if l:line =~# '\v^\s*end>'
        return indent(v:lnum) - (l:indent ==# 0 ? l:shiftwidth : l:indent)
    elseif l:line =~# '\v^\s*%(case|else)>'
        return indent(v:lnum) - l:shiftwidth
    endif
    return indent(l:prevlnum) + l:indent
endfunction

function! fish#Format()
    if mode() =~# '\v^%(i|R)$'
        return 1
    else
        let l:command = v:lnum.','.(v:lnum+v:count-1).'!fish_indent'
        echo l:command
        execute l:command
    endif
endfunction

function! fish#Fold()
    let l:line = getline(v:lnum)
    if l:line =~# '\v^\s*%(begin|if|while|for|function|switch)>'
        return 'a1'
    elseif l:line =~# '\v^\s*end>'
        return 's1'
    else
        return '='
    end
endfunction

function! fish#errorformat()
    return '%Afish: %m,%-G%*\\ ^,%-Z%f (line %l):%s'
endfunction
