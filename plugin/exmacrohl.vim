" default configuration {{{1
if !exists('g:ex_macrohl_winsize')
    let g:ex_macrohl_winsize = 20
endif

if !exists('g:ex_macrohl_winsize_zoom')
    let g:ex_macrohl_winsize_zoom = 25
endif

" bottom or top
if !exists('g:ex_macrohl_winpos')
    let g:ex_macrohl_winpos = 'bottom'
endif

if !exists('g:ex_macrohl_ignore_case')
    let g:ex_macrohl_ignore_case = 1
endif

if !exists('g:ex_macrohl_engine')
    let g:ex_macrohl_engine = "ag"
endif

if !exists('g:ex_macrohl_enable_sort')
    let g:ex_macrohl_enable_sort = 1
endif

" will not sort the result if result lines more than x 
if !exists('g:ex_macrohl_sort_lines_threshold')
    let g:ex_macrohl_sort_lines_threshold = 100
endif

if !exists('g:ex_macrohl_enable_help')
    let g:ex_macrohl_enable_help = 1
endif
let g:exmacrohl_filename = '-MacroHL-'

"}}}

" commands {{{1

command! EXMHToggle call exmacrohl#toggle_window()
command! EXMHOpen call exmacrohl#open_window()
command! EXMHClose call exmacrohl#close_window()
command -narg=? EXMH call exmacrohl#initmacrolist('<args>')
" command ExmhSelectToggle call s:exMH_ToggleWindow('Select')
" command ExmhToggle call s:exMH_ToggleWindow('')
" command -narg=? ExmhHL call exmacrohl#initmacrolist('<args>')
"}}}

" default key mappings {{{1
call exmacrohl#register_hotkey( 1  , 1, '?'               , ":call exmacrohl#toggle_help()<CR>"           , 'Toggle help.' )
if has('gui_running')
call exmacrohl#register_hotkey( 2  , 1, '<ESC>'           , ":EXMHClose<CR>"                         , 'Close window.' )
else
call exmacrohl#register_hotkey( 2  , 1, '<leader><ESC>'   , ":EXMHClose<CR>"                         , 'Close window.' )
endif
call exmacrohl#register_hotkey( 3  , 1, 'z'               , ":call exmacrohl#toggle_zoom()<CR>"           , 'Zoom in/out project window.' )
call exmacrohl#register_hotkey( 4  , 1, '<CR>'            , ":call exmacrohl#confirm_select()<CR>"      , 'Go to the search result.' )
call exmacrohl#register_hotkey( 5  , 1, '<2-LeftMouse>'   , ":call exmacrohl#confirm_select()<CR>"      , 'Go to the search result.' )
call exgsearch#register_hotkey( 100, 0, '<leader>hs', ":EXMHToggle<CR>", 'Toggle MacroHighlight window.' )
"}}}

call ex#register_plugin( 'exmacrohl', { 'actions': ['autoclose'] } )

" vim:ts=4:sw=4:sts=4 et fdm=marker:
