syntax include @javascript syntax/javascript.vim

syntax keyword rlKeyword append block doctype else extends for if include macro of replace yield
syntax region rlText start=/"/ skip=/\\./ end=/"/ contains=rlTextEscape,rlInterpolation
syntax region rlComment start=/#/ end=/$/
syntax region rlCode start=/%/ end=/$/ contains=@javascript
syntax match rlCode /^\(\s*\)do\( .*\|$\)\(\n\(\1\s.*\|$\)\)*/ contains=@javascript
syntax match rlTagName /\<[a-zA-Z0-9-]\+\>/
syntax match rlAttributeName /\<[a-zA-Z0-9-]\+:/
syntax match rlMacroName /\<[a-zA-Z0-9_-]\+(\@=/

syntax match rlTextEscape /\\./ contained
syntax match rlInterpolation /#{.*}/ contained contains=@javascript

highlight link rlKeyword Statement
highlight link rlText String
highlight link rlMacroName Identifier
highlight link rlTagName Constant
highlight link rlAttributeName Type
highlight link rlComment Comment

highlight link rlTextEscape SpecialChar
highlight link rlInterpolation PreProc
