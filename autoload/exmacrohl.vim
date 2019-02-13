" ======================================================================================
" File         : exmacrohl.vim
" Author       : cpiger@qq.com
" Description  : 
" ======================================================================================
" ------------------------------------------------------------------ 
" Desc: title
" ------------------------------------------------------------------ 
let s:title = "_MacroHL_" 
let s:confirm_at = -1

let s:zoom_in = 0
let s:keymap = {}

let s:help_open = 0
let s:help_text_short = [
            \ '" Press ? for help',
            \ '',
            \ ]
let s:help_text = s:help_text_short

let s:exMH_select_title = "_MacroHLSelect_"
let s:exMH_cur_filename = ''

" ------------------------------------------------------------------ 
" Desc: general
" ------------------------------------------------------------------ 
let s:exMH_define_list = [[],[]] " 0: not define group, 1: define group
let s:exMH_IsEnable = 0
" let s:exMH_Debug = 0
let s:exMH_Debug = 1

" ------------------------------------------------------------------ 
" Desc: select
" ------------------------------------------------------------------ 
let s:exMH_select_idx = 1

" ------------------------------------------------------------------ 
" Desc: predefine patterns
" ------------------------------------------------------------------ 

" the document said \%(\) will not count the groups as a sub-expression(.eg use \1,\2...), this will be a bit fast ( I don't feel )
" ---------------------------------
"let s:if_pattern = '^\s*\%(%:\|#\)\s*\%(if\s\+(*\s*\%(defined\)*\s*(*\s*\%(\s*\S*\s*==\s*\)*\|ifdef\s\+(*\s*\)'
"let s:ifn_pattern = '^\s*\%(%:\|#\)\s*\%(if\s\+!\s*(*\s*\%(defined\)*\s*(*\s*\|if\s\+(*\s*\S*\s*!=\s*\|ifndef\s\+(*\s*\)'
"let s:elif_pattern = '^\s*\%(%:\|#\)\s*\%(elif\s\+(*\s*\%(defined\)*\s*(*\s*\%(\s*\S*\s*==\s*\)*\)'
"let s:elifn_pattern = '^\s*\%(%:\|#\)\s*\%(elif\s\+!\s*\%((*defined\)*\s*(*\s*\|elif\s\+(*\s*\S*\s*!=\s*\)'
" ---------------------------------
" FIXME: if pattern like UNKNOWN_MACRO || DISABLE_MACRO, this will always be false, let this situation unmatch
"let s:if_pattern = '^\s*\%(%:\|#\)\s*\%(if\s\+\%(.*\%(||\|&&\)\s*\)*(*\s*\%(defined\)*\s*(*\s*\%(\s*\S*\s*==\s*\)*\|ifdef\s\+(*\s*\)'
"let s:ifn_pattern = '^\s*\%(%:\|#\)\s*\%(if\s\+\%(.*\%(||\|&&\)\s*\)*!\s*(*\s*\%(defined\)*\s*(*\s*\|if\s\+\%(.*\%(||\|&&\)\s*\)*(*\s*\S*\s*!=\s*\|ifndef\s\+(*\s*\)'
"let s:elif_pattern = '^\s*\%(%:\|#\)\s*\%(elif\s\+\%(.*\%(||\|&&\)\s*\)*(*\s*\%(defined\)*\s*(*\s*\%(\s*\S*\s*==\s*\)*\)'
"let s:elifn_pattern = '^\s*\%(%:\|#\)\s*\%(elif\s\+\%(.*\%(||\|&&\)\s*\)*!\s*\%((*defined\)*\s*(*\s*\|elif\s\+\%(.*\%(||\|&&\)\s*\)*(*\s*\S*\s*!=\s*\)'
" ---------------------------------
let s:if_or_pattern     = '^\s*\%(%:\|#\)\s*\%(if\s\+\%(.*||\s*\)*(*\s*\%(defined\)*\s*(*\s*\%(\s*\S*\s*==\s*\)*\|ifdef\s\+(*\s*\)'
let s:if_and_pattern    = '^\s*\%(%:\|#\)\s*\%(if\s\+\%(.*&&\s*\)*(*\s*\%(defined\)*\s*(*\s*\%(\s*\S*\s*==\s*\)*\|ifdef\s\+(*\s*\)'
let s:ifn_or_pattern    = '^\s*\%(%:\|#\)\s*\%(if\s\+\%(.*||\s*\)*!\s*(*\s*\%(defined\)*\s*(*\s*\|if\s\+\%(.*||\s*\)*(*\s*\S*\s*!=\s*\|ifndef\s\+(*\s*\)'
let s:ifn_and_pattern   = '^\s*\%(%:\|#\)\s*\%(if\s\+\%(.*&&\s*\)*!\s*(*\s*\%(defined\)*\s*(*\s*\|if\s\+\%(.*&&\s*\)*(*\s*\S*\s*!=\s*\|ifndef\s\+(*\s*\)'

let s:elif_or_pattern   = '^\s*\%(%:\|#\)\s*\%(elif\s\+\%(.*||\s*\)*(*\s*\%(defined\)*\s*(*\s*\%(\s*\S*\s*==\s*\)*\)'
let s:elif_and_pattern  = '^\s*\%(%:\|#\)\s*\%(elif\s\+\%(.*&&\s*\)*(*\s*\%(defined\)*\s*(*\s*\%(\s*\S*\s*==\s*\)*\)'
let s:elifn_or_pattern  = '^\s*\%(%:\|#\)\s*\%(elif\s\+\%(.*||\s*\)*!\s*(*\s*\%(defined\)*\s*(*\s*\|elif\s\+\%(.*||\s*\)*(*\s*\S*\s*!=\s*\)'
let s:elifn_and_pattern = '^\s*\%(%:\|#\)\s*\%(elif\s\+\%(.*&&\s*\)*!\s*(*\s*\%(defined\)*\s*(*\s*\|elif\s\+\%(.*&&\s*\)*(*\s*\S*\s*!=\s*\)'
" ---------------------------------
" NOTE: the if here fix the bug:
" {{{
"     #if defined (MACRO1) || defined (MACRO1)
" }}}
" which means the code #if not start from the beginning of the line, but the or,and pattern will come from the beginning of the line. 
let s:or_pattern   = 'if\s\+.*||\s*(*\s*\%(defined\)*\s*(*\s*\%(\s*\S*\s*==\s*\)*'
let s:and_pattern  = 'if\s\+.*&&\s*(*\s*\%(defined\)*\s*(*\s*\%(\s*\S*\s*==\s*\)*'
let s:orn_pattern  = 'if\s\+.*||\s*\%(!\s*(*\s*\%(defined\)*\s*(*\s*\|(*\s*\S*\s*!=\s*\)'
let s:andn_pattern = 'if\s\+.*&&\s*\%(!\s*(*\s*\%(defined\)*\s*(*\s*\|(*\s*\S*\s*!=\s*\)'
" ---------------------------------
let s:end_pattern = '\s*)*.*$' " end_pattern used in syntax region define start
let s:end_not_and_pattern = '\s*)*\s*\%(&[^&]\|[^&]\)*$' " the [^&] will stop martch in xxx &, but the &[^&] will let this martch pass until && coming
let s:end_not_or_pattern  = '\s*)*\s*\%(|[^|]\|[^|]\)*$' " same as above
" ---------------------------------
let s:def_macro_pattern = '\%(\%(\%(==\|!=\)\s*\)\@<!\<1\>\)'
let s:undef_macro_pattern = '\%(\%(\%(==\|!=\)\s*\)\@<!\<0\>\)'
" ---------------------------------
let s:if_enable_pattern   = s:if_or_pattern . s:def_macro_pattern . s:end_pattern
let s:if_disable_pattern  = s:if_and_pattern  . s:undef_macro_pattern . s:end_pattern
let s:ifn_enable_pattern  = s:ifn_or_pattern . s:undef_macro_pattern . s:end_pattern
let s:ifn_disable_pattern = s:ifn_and_pattern . s:def_macro_pattern . s:end_pattern

let s:elif_enable_pattern   = s:elif_or_pattern . s:def_macro_pattern . s:end_pattern
let s:elif_disable_pattern  = s:elif_and_pattern . s:undef_macro_pattern . s:end_pattern
let s:elifn_enable_pattern  = s:elifn_or_pattern . s:undef_macro_pattern . s:end_pattern
let s:elifn_disable_pattern = s:elifn_and_pattern . s:def_macro_pattern . s:end_pattern

"/////////////////////////////////////////////////////////////////////////////
" function defines
"/////////////////////////////////////////////////////////////////////////////

" ======================================================== 
" general functions
" ======================================================== 

" functions {{{1
" exmacrohl#bind_mappings {{{2
function exmacrohl#bind_mappings()
    call ex#keymap#bind( s:keymap )
endfunction

" exmacrohl#register_hotkey {{{2
function exmacrohl#register_hotkey( priority, local, key, action, desc )
    " echomsg "Macro Higlight hotkey"
    call ex#keymap#register( s:keymap, a:priority, a:local, a:key, a:action, a:desc )
endfunction

" exmacrohl#toggle_help {{{2
" s:update_help_text {{{2
function s:update_help_text()
    if s:help_open
        let s:help_text = ex#keymap#helptext(s:keymap)
    else
        let s:help_text = s:help_text_short
    endif
endfunction

function exmacrohl#toggle_help()
    if !g:ex_macrohl_enable_help
        return
    endif

    let s:help_open = !s:help_open
    silent exec '1,' . len(s:help_text) . 'd _'
    call s:update_help_text()
    silent call append ( 0, s:help_text )
    silent keepjumps normal! gg
    call ex#hl#clear_confirm()
endfunction

" exmacrohl#open_window {{{2

function exmacrohl#init_buffer()
    set filetype=exmacrohl
    augroup exmacrohl
        au! BufWinLeave <buffer> call <SID>on_close()
    augroup END

    if line('$') <= 1 && g:ex_macrohl_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d _'
    endif
endfunction

function s:on_close()
    let s:zoom_in = 0
    let s:help_open = 0

    if fnamemodify( bufname("%"), ":p:t" ) ==# fnamemodify( s:exMH_cur_filename, ":p:t" )
        " call ex#warning('save w')
        silent exec "w!"
    endif
    " go back to edit buffer
    call ex#window#goto_edit_window()
    call ex#hl#clear_target()
endfunction

function exmacrohl#open_window()

    if exists('g:exmacrohl_filename')
        if s:exMH_cur_filename != g:exmacrohl_filename
            " call exmacrohl#initmacrolist(g:exvim_folder.'/'.g:exmacrohl_filename)
            call exmacrohl#initmacrolist(g:exmacrohl_filename)
        endif
    else
        call ex#warning('macro file not found, please create one in vimentry')
        " call exmacrohl#initmacrolist(s:exMH_select_title)
        call exmacrohl#initmacrolist(g:exmacrohl_filename)
    endif

    let winnr = winnr()
    if ex#window#check_if_autoclose(winnr)
        call ex#window#close(winnr)
    endif
    call ex#window#goto_edit_window()

    let winnr = bufwinnr(s:title)
    if winnr == -1
        call ex#window#open( 
                    \ s:title, 
                    \ g:ex_macrohl_winsize,
                    \ g:ex_macrohl_winpos,
                    \ 1,
                    \ 1,
                    \ function('exmacrohl#init_buffer')
                    \ )
        if s:confirm_at != -1
            call ex#hl#confirm_line(s:confirm_at)
        endif
    else
        exe winnr . 'wincmd w'
    endif
endfunction

" exmacrohl#toggle_window {{{2
function exmacrohl#toggle_window()
    let result = exmacrohl#close_window()
    if result == 0
        call exmacrohl#open_window()
    endif
endfunction

" exmacrohl#close_window {{{2
function exmacrohl#close_window()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        call ex#window#close(winnr)
        return 1
    endif
    return 0
endfunction

" exmacrohl#toggle_zoom {{{2
function exmacrohl#toggle_zoom()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        if s:zoom_in == 0
            let s:zoom_in = 1
            call ex#window#resize( winnr, g:ex_macrohl_winpos, g:ex_macrohl_winsize_zoom )
        else
            let s:zoom_in = 0
            call ex#window#resize( winnr, g:ex_macrohl_winpos, g:ex_macrohl_winsize )
        endif
    endif
endfunction

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 
function exmacrohl#initmacrolist(macrofile_name) " <<<
    " init file name and read the file into line_list
    let s:exMH_cur_filename = a:macrofile_name
    let line_list = []
    if filereadable(s:exMH_cur_filename) == 1
        let line_list = readfile(s:exMH_cur_filename)
    endif
    let s:exMH_IsEnable = 1

    " update macro list
    call s:update_macrolist(line_list,0)

    " define syntax
    call s:definesyntax()

    " for debug highlight link
    if s:exMH_Debug == 1
        " inside pattern
        hi link exMacroDisable      Comment
        hi link exCppSkip           exMacroDisable
        " hi link exMacroInside       Normal
        hi link exPreCondit         cPreProc

        " else disable/enable
        hi link exElseDisable       exMacroDisable
        " hi link exElseEnable        Normal

        " logic 
        " hi link exAndEnable         Normal
        " hi link exAndnotEnable      Normal
        hi link exOrDisable         exMacroDisable
        hi link exOrnotDisable      exMacroDisable

        " if/ifn eanble
        hi link exIfEnableStart     cPreProc
        " hi link exIfEnable          Normal
        hi link exIfnEnableStart    cPreProc
        " hi link exIfnEnable         Normal

        " if/ifn disable
        hi link exIfDisable         exMacroDisable
        hi link exIfDisableStart    exMacroDisable
        hi link exIfnDisable        exMacroDisable
        hi link exIfnDisableStart   exMacroDisable

        " elif/elifn enable
        hi link exElifEnableStart   cPreProc
        " hi link exElifEnable        Normal
        hi link exElifnEnableStart  cPreProc
        " hi link exElifnEnable       Normal

        " elif/elifn disable
        hi link exElifDisableStart  exMacroDisable 
        hi link exElifDisable       exMacroDisable 
        hi link exElifnDisableStart exMacroDisable 
        hi link exElifnDisable      exMacroDisable 
    endif

    " define autocmd for update syntax
    autocmd BufEnter *.c,*.C,*.c++,*.cc,*.cp,*.cpp,*.cxx,*.h,*.H,*.h++,*.hh,*.hp,*.hpp,*.hxx,*.inl,*.ipp call s:updatesyntax()
    autocmd BufEnter *.i,*.swg call s:updatesyntax()
    " DISABLE: autocmd BufEnter *.cs call s:updatesyntax()
    " TODO: the shader still have problem
    autocmd BufEnter *.hlsl,*.fx,*.fxh,*.cg,*.vsh,*.psh,*.shd,*.glsl call s:updatesyntax()

endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:update_macrolist(line_list,save_file) " <<<
    " clear the macro list and define list first
    if !empty(s:exMH_define_list)
        if !empty(s:exMH_define_list[0])
            call remove(s:exMH_define_list[0],0,-1)
        endif
        if !empty(s:exMH_define_list[1])
            call remove(s:exMH_define_list[1],0,-1)
        endif
        call remove(s:exMH_define_list,0,-1)
    endif
    let s:exMH_define_list = [[],[]]

    " init group index and group item index
    let skip_group = 0
    
    " loop the line_list
    for line in a:line_list
        " skip empty line
        if line == ''
            continue
        endif

        " skip empty line 2
        if match( line, "\s\+" ) != -1
            continue
        endif

        " get group mark
        if line =~# ":"
            if line =~# ': \[x\]'
                let skip_group = 1
            else
                let skip_group = 0
            endif
            continue
        endif

        " put macro item to the group 
        if skip_group == 0
            if line =~# '   .\S.*'
                let macro = substitute( line, " ", "", "g" ) " skip whitespace
                let is_define = (macro =~# '\*')
                if is_define
                    call add( s:exMH_define_list[is_define], strpart(macro,1) )
                else
                    call add( s:exMH_define_list[is_define], macro )
                endif
            endif
        endif
    endfor

    " save the macro file if needed
    " if a:save_file && (s:exMH_cur_filename !=# s:exMH_select_title)
    " echomsg 's:exMH_cur_filename '.s:exMH_cur_filename
    " echomsg 'g: 'g:exvim_folder.'/'.g:exmacrohl_filename
    " if a:save_file && (s:exMH_cur_filename !=# g:exvim_folder.'/'.g:exmacrohl_filename)
    " if (s:exMH_cur_filename !=# g:exvim_folder.'/'.g:exmacrohl_filename)
    " if !a:save_file
        " call ex#warning('bufname '.fnamemodify( bufname("%"), ":p:t" ))
        " call ex#warning('bufname '.fnamemodify( s:exMH_cur_filename, ":p:t" ))
        if fnamemodify( bufname("%"), ":p:t" ) ==# fnamemodify( s:exMH_cur_filename, ":p:t" )
            " call ex#warning('save w')
            silent exec "w!"
        endif
    " endif

    " update the macro patterns
    call s:update_macropattern()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:update_macropattern() " <<<
    " update def macro pattern
    let s:def_macro_pattern = '\%(\%(\%(==\|!=\)\s*\)\@<!\<1\>'
    for def_macro in s:exMH_define_list[1]
        let s:def_macro_pattern .= '\|\<\C' . def_macro . '\>'
    endfor
    let s:def_macro_pattern .= '\)'

    " update ndef macro pattern
    " the \(==\|!=\)\$<! pattern will stop parseing the 0 as == 0. this will fix the bug like #if ( EX_NOT_IN_MACRO_FILE == 0 ) become match
    let s:undef_macro_pattern = '\%(\%(\%(==\|!=\)\s*\)\@<!\<0\>'
    for undef_macro in s:exMH_define_list[0]
        let s:undef_macro_pattern .= '\|\<\C' . undef_macro . '\>'
    endfor
    let s:undef_macro_pattern .= '\)'

    " define enable/disable start pattern
    let s:if_enable_pattern   = s:if_or_pattern . s:def_macro_pattern . s:end_pattern
    let s:if_disable_pattern  = s:if_and_pattern  . s:undef_macro_pattern . s:end_pattern
    let s:ifn_enable_pattern  = s:ifn_or_pattern . s:undef_macro_pattern . s:end_pattern
    let s:ifn_disable_pattern = s:ifn_and_pattern . s:def_macro_pattern . s:end_pattern

    let s:elif_enable_pattern   = s:elif_or_pattern . s:def_macro_pattern . s:end_pattern
    let s:elif_disable_pattern  = s:elif_and_pattern . s:undef_macro_pattern . s:end_pattern
    let s:elifn_enable_pattern  = s:elifn_or_pattern . s:undef_macro_pattern . s:end_pattern
    let s:elifn_disable_pattern = s:elifn_and_pattern . s:def_macro_pattern . s:end_pattern
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:definesyntax() " <<<
    " ------------ simple document -------------

    "  exIfEnable/exIfnEnable
    " keepend: the exIfEnable/exIfnEnable share the end with exElseDisable, use keepend to tell exElseDisable always inside the exIfEnable/exIfnEnable 
    " entend: in exIfEnable( Paren ( ... ) ) the end Paren will always show error cause the keepend also endup Paren check. the extend tell cParen it will continue
    " skip: in exIfEnable( /* #if enable #endif */ ), the skip tell the exIfEnable to find the end by skip the skip_pattern

    " --------------- exLogicPatterns ---------------
    " exec 'syn region exAndEnable contained extend keepend matchgroup=cPreProc start=' . '"' . s:and_pattern . s:def_macro_pattern . s:end_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exElseDisable,@exEnableContainedGroup'
    " exec 'syn region exAndnotEnable contained extend keepend matchgroup=cPreProc start=' . '"' . s:andn_pattern . s:undef_macro_pattern . s:end_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exElseDisable,@exEnableContainedGroup'
    exec 'syn region exOrDisable contained extend keepend start=' . '"' . s:or_pattern . s:undef_macro_pattern . s:end_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exCppSkip,exElseEnable,exElifEnableStart,exElifnEnableStart'
    exec 'syn region exOrnotDisable contained extend keepend start=' . '"' . s:orn_pattern . s:def_macro_pattern . s:end_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exCppSkip,exElseEnable,exElifEnableStart,exElifnEnableStart'

    " --------------- exIfEnable ---------------
    " if enable(def_macro) else disable
    " exec 'syn region exIfEnableStart start=' . '"' . s:if_enable_pattern . '"' . ' end=".\@=\|$" contains=exIfEnable,exAndEnable,exAndnotEnable'
    " NOTE: add if_or_pattern fix bug that #if MACRO_DISABLE || MACRO_ENABLE || MACRO_DISABLE ". NOTE: I not sure if it have any side-effect
    " exec 'syn region exIfEnable contained extend keepend matchgroup=cPreProc start=' . '"' . s:if_or_pattern . s:def_macro_pattern . s:end_not_and_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exElseDisable,@exEnableContainedGroup'

    " --------------- exElifEnable ---------------
    " elif enable(def_macro) else disable
    " exec 'syn region exElifEnableStart contained start=' . '"' . s:elif_enable_pattern . '"' . ' end=".\@=\|$" contains=exElifEnable,exAndEnable,exAndnotEnable'
    " add elif_or_pattern will fix a bug that #elif MACRO_ENABLE && !MACRO_ENABLE
    " exec 'syn region exElifEnable contained matchgroup=cPreProc start=' . '"' . s:elif_or_pattern . s:def_macro_pattern . s:end_not_and_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exElseDisable,@exEnableContainedGroup'

    " --------------- exIfnEnable ---------------
    " ifn enable(undef_macro) else disable
    " exec 'syn region exIfnEnableStart start=' . '"' . s:ifn_enable_pattern . '"' . ' end=".\@=\|$" contains=exIfnEnable,exAndEnable,exAndnotEnable'
    " NOTE: add ifn_or_pattern fix a bug that #if !MACRO_DISABLE || !MACRO_DISABLE || !MACRO_DISABLE ", NOTE: I not sure if it have any side-effect
    " exec 'syn region exIfnEnable contained extend keepend matchgroup=cPreProc start=' . '"' . s:ifn_or_pattern . s:undef_macro_pattern . s:end_not_and_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exElseDisable,@exEnableContainedGroup'

    " --------------- exElifnEnable ---------------
    " elifn enable(def_macro) else disable
    " exec 'syn region exElifnEnableStart contained start=' . '"' . s:elifn_enable_pattern . '"' . ' end=".\@=\|$" contains=exElifnEnable,exAndEnable,exAndnotEnable'
    " add elifn_or_pattern will fix a bug that #elif !MACRO_ENABLE && MACRO_ENABLE
    " exec 'syn region exElifnEnable contained matchgroup=cPreProc start=' . '"' . s:elifn_or_pattern . s:undef_macro_pattern . s:end_not_and_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exElseDisable,@exEnableContainedGroup'

    " --------------- exIfDisable ---------------
    " if disable(undef_macro) else define
    " to contains exIfEnable,exIfnEnable to avoid bugs that #if DISABLE || ENABLE, cause the DISABLE syntax is define after ENABLE, so it have the priority
    exec 'syn region exIfDisableStart start=' . '"' . s:if_disable_pattern . '"' . ' end=".\@=\|$" contains=exIfDisable,exOrDisable,exOrnotDisable,exIfEnable,exIfnEnable'
    exec 'syn region exIfDisable contained extend keepend start=' . '"' . s:undef_macro_pattern . s:end_not_or_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exCppSkip,exElseEnable,exElifEnableStart,exElifnEnableStart'

    " --------------- exElifDisable ---------------
    " elif disable(undef_macro) else define
    exec 'syn region exElifDisableStart contained start=' . '"' . s:elif_disable_pattern . '"' . ' end=".\@=\|$" contains=exElifDisable,exOrDisable,exOrnotDisable,exElifEnable,exElifnEnable'
    exec 'syn region exElifDisable contained start=' . '"' . s:undef_macro_pattern . s:end_not_or_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exCppSkip,exElseDisable,exElifEnableStart,exElifnEnableStart'

    " --------------- exIfnDisable ---------------
    " ifn disable(def_macro) else define
    exec 'syn region exIfnDisableStart start=' . '"' . s:ifn_disable_pattern . '"' . ' end=".\@=\|$" contains=exIfnDisable,exOrDisable,exOrnotDisable,exIfEnable,exIfnEnable'
    exec 'syn region exIfnDisable contained extend keepend start=' . '"' . s:def_macro_pattern . s:end_not_or_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exCppSkip,exElseEnable,exElifEnableStart,exElifnEnableStart'

    " --------------- exElifnDisable ---------------
    " elif disable(undef_macro) else define
    exec 'syn region exElifnDisableStart contained start=' . '"' . s:elifn_disable_pattern . '"' . ' end=".\@=\|$" contains=exElifnDisable,exOrDisable,exOrnotDisable,exElifEnable,exElifnEnable'
    exec 'syn region exElifnDisable contained start=' . '"' . s:def_macro_pattern . s:end_not_or_pattern . '"' . ' skip="#endif\>\_[^\%(\/\*\)]*\*\/" end="^\s*\%(%:\|#\)\s*\%(endif\>\)" contains=exCppSkip,exElseDisable,exElifEnableStart,exElifnEnableStart'
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function s:updatesyntax() " <<<
    " clear syntax group for re-define
    syntax clear exAndEnable exAndnotEnable exOrDisable exOrnotDisable
    syntax clear exIfEnableStart exIfEnable exIfnEnableStart exIfnEnable
    syntax clear exIfDisableStart exIfDisable exIfnDisableStart exIfnDisable 
    syntax clear exElifEnableStart exElifEnable exElifnEnableStart exElifnEnable
    syntax clear exElifDisableStart exElifDisable exElifnDisableStart exElifnDisable

    " if enable syntax
    if s:exMH_IsEnable == 1
        " re-define syntax
        call s:definesyntax() 
    endif
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exmacrohl#getmhindent() " <<<
    let cur_line = getline(v:lnum)
    " indent group
    if cur_line =~# ":"
        return 0
    endif
    return 4
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: 
" ------------------------------------------------------------------ 

function exmacrohl#syntaxhl(b_enable) " <<<
    let s:exMH_IsEnable = a:b_enable
    if s:exMH_IsEnable == 1
        echomsg "Macro Higlight: ON "
    else
        echomsg "Macro Higlight: OFF "
    endif
    call s:updatesyntax()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: Update exMacroHighlight window
" ------------------------------------------------------------------ 

function exmacrohl#update_selectwindow() " <<<
    " call cursor( s:exMH_select_idx, 1)
    " call exUtility#HighlightConfirmLine()
endfunction " >>>

" ------------------------------------------------------------------ 
" Desc: confirm selected macro
" ------------------------------------------------------------------ 

function exmacrohl#confirm_select() " <<<
    let line = getline(".")

    " if this is a group title
    if line =~# ':\s*$'
        let group = getline('.')
        let on_to_off = substitute( group, ':', ': \[x\]', "g" ) 
        silent call setline( '.', on_to_off )

        " ------------------------------------------------------
        " directly update the macro list
        call s:update_macrolist(getline(1,'$'),0)

        " update syntax immediately
        call ex#window#goto_edit_window()
        call ex#window#switch_window()
        return
    elseif line =~# ': \[x\]'
        let group = getline('.')
        let off_to_on = substitute( group, ': \[x\]', ':', "g" ) 
        silent call setline( '.', off_to_on )

        " ------------------------------------------------------
        " directly update the macro list
        call s:update_macrolist(getline(1,'$'),0)

        " update syntax immediately
        call ex#window#goto_edit_window()
        call ex#window#switch_window()
        return
    endif

    " if this is a empty line 
    if substitute(line, ' ', "", "g" ) == ''
        call ex#warning("Can't select an empty line")
        return
    endif

    " if this is a selected macor, disable the macro
    if line =~# '\*'
        let macro = getline('.')
        let on_to_off = substitute( macro, ' \|\*', "", "g" ) " skip whitespace and '*'
        silent call setline( '.', "    ".on_to_off )

        " ------------------------------------------------------
        " directly update the macro list
        call s:update_macrolist(getline(1,'$'),0)

        " update syntax immediately
        call ex#window#goto_edit_window()
        call ex#window#switch_window()
        return
    endif

    " save current postion
    let cur_cursor = getpos(".")

    " get the line of current group title and next group title
    let [next_group_line, dummy_col] = searchpos( '^.*:', 'nW' ) 
    let [cur_group_line, dummy_col] = searchpos( '^.*:', 'bW' ) 
    let [enable_macro_line, dummy_col] = searchpos( '\*', 'nW' ) 

    " init change macro
    let on_to_off = ''
    let off_to_on = ''

    " if not any enable macro in this group
    if enable_macro_line == 0
        " off to on
        silent call setpos( '.', cur_cursor )
        let macro = getline('.')
        let off_to_on = substitute( macro, ' ', "", "g" ) " skip whitespace and '*'
        silent call setline( '.', '   *' . off_to_on )
    elseif next_group_line == 0 || (enable_macro_line < next_group_line)
        " on to off
        let macro = getline(enable_macro_line)
        let on_to_off = substitute( macro, ' \|\*', "", "g" ) " skip whitespace and '*'
        silent call setline( enable_macro_line, "    ".on_to_off )

        " off to on
        silent call setpos( '.', cur_cursor )
        let macro = getline('.')
        let off_to_on = substitute( macro, ' ', "", "g" ) " skip whitespace and '*'
        silent call setline( '.', '   *' . off_to_on )
    else
        " off to on
        silent call setpos( '.', cur_cursor )
        let macro = getline('.')
        let off_to_on = substitute( macro, ' ', "", "g" ) " skip whitespace and '*'
        silent call setline( '.', '   *' . off_to_on )
    endif

    " ------------------------------------------------------
    " directly update the macro list
    call s:update_macrolist(getline(1,'$'),0)
    " ------------------------------------------------------
    "" update define list on to off
    "if on_to_off != '' 
    "    call add( s:exMH_define_list[0], on_to_off ) " add to off
    "    " remove from to on
    "    let idx = index( s:exMH_define_list[1], on_to_off )
    "    if idx >= 0
    "        call remove( s:exMH_define_list[1], idx ) 
    "    endif
    "endif
    "" update define list off to on
    "if off_to_on != '' 
    "    call add( s:exMH_define_list[1], off_to_on ) " add to off
    "    " remove from to on
    "    let idx = index( s:exMH_define_list[0], off_to_on )
    "    if idx >= 0
    "        call remove( s:exMH_define_list[0], idx ) 
    "    endif
    "endif
    "" update macro patterns
    "call s:update_macropattern()
    " ------------------------------------------------------

    " update syntax immediately
    call ex#window#goto_edit_window()
    call ex#window#switch_window()

endfunction " >>>

function exmacrohl#smartpaste() " <<<
    call append('.', getreg())
    normal j
    normal ==
endfunction " >>>

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

finish
" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
