if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" syntax highlight

syntax match ex_mh_help #^".*# contains=ex_mh_help_key
syntax match ex_mh_help_key '^" \S\+:'hs=s+2,he=e-1 contained contains=ex_mh_help_comma
syntax match ex_mh_help_comma ':' contained

syntax region ex_mh_header start="^----------" end="----------"
syntax region ex_mh_filename start="^[^"][^:]*" end=":" oneline
syntax match ex_mh_linenr '\d\+:'


hi default link ex_mh_help Comment
hi default link ex_mh_help_key Label
hi default link ex_mh_help_comma Special

hi default link ex_mh_header SpecialKey
hi default link ex_mh_filename Directory
hi default link ex_mh_linenr Special

let b:current_syntax = "exmacrohl"

" vim:ts=4:sw=4:sts=4 et fdm=marker:
