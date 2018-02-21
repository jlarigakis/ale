" Author: Jason Larigakis
" Description: Detect compilation errors in elixir files

function! ale_linters#elixir#compile#Handle(buffer, lines) abort
    " Matches patterns line the following:
    "
    " ** (CompileError) lib/lint.ex:16: undefined function world/0
    let l:pattern = '\v\(CompileError\) (.+):(\d+): (.+)$'
    let l:output = []
    let l:type = 'E'

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        if bufname(a:buffer) == l:match[1]
            call add(l:output, {
            \   'bufnr': a:buffer,
            \   'lnum': l:match[2] + 0,
            \   'col': 0,
            \   'type': l:type,
            \   'text': l:match[3],
            \})
        endif
    endfor

    return l:output
endfunction

call ale#linter#Define('elixir', {
\   'name': 'compile',
\   'executable': 'mix',
\   'command': 'mix compile',
\   'callback': 'ale_linters#elixir#compile#Handle',
\})
