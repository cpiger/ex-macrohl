" local settings {{{1

" set buffer no modifiable
silent! setlocal nonumber
" this will help Update symbol relate with it.
" silent! setlocal buftype=
silent! setlocal cursorline

" silent! setlocal buftype=nofile
silent! setlocal bufhidden=hide
silent! setlocal noswapfile
silent! setlocal nobuflisted

silent! setlocal buftype=nofile
" silent! setlocal bufhidden=hide
" silent! setlocal noswapfile
" silent! setlocal nobuflisted

" silent! setlocal cursorline
" silent! setlocal nonumber
silent! setlocal nowrap
silent! setlocal statusline=

" dummy mapping

" autocmd
" au CursorMoved <buffer> :call exUtility#HighlightSelectLine()

" set indent
silent! setlocal cindent
silent! setlocal indentexpr=exmacrohl#getmhindent() " Set the function to do the work.
silent! setlocal indentkeys-=: " To make a colon (:) suggest an indentation other than a goto/swich label,
silent! setlocal indentkeys+=<:> 

" Key Mappings {{{1
call exmacrohl#bind_mappings()
" }}}1

" auto command {{{1
au! VimLeave * call exmacrohl#save_macrohl()
" }}}1

" syntax highlight
syntax match exMH_GroupNameEnable '^.*:\s*'
syntax match exMH_GroupNameDisable '^.*:\s\+\[x\]'
syntax match exMH_MacroEnable '^\s\s\s\zs\*\S\+$'
syntax match exMH_MacroDisable '^\s\s\s\s\zs\S\+$'

" vim:ts=4:sw=4:sts=4 et fdm=marker:
