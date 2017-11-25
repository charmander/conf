syntax clear

runtime syntax/html.vim
unlet b:current_syntax

syntax include @templetorPython syntax/python.vim

syntax region templetorCode matchgroup=templetorCodeStart start=/^\s*\$\(:\?[{([]\)\@!/ end=/$/ keepend contains=@templetorPython containedin=ALLBUT,templetorCodeBlock,templetorInterpolation,templetorRawInterpolation
syntax region templetorCodeBlock start=/^\s*\$code:\n\z(\s\+\)/ end=/^\(\z1\)\@!.\@=/ keepend contains=@templetorPython containedin=ALL
syntax region templetorInterpolation start=/\${/ end=/}/ contains=@templetorPython containedin=ALLBUT,templetorCodeBlock,templetorCode
syntax region templetorInterpolation start=/\$(/ end=/)/ contains=@templetorPython containedin=ALLBUT,templetorCodeBlock,templetorCode
syntax region templetorInterpolation start=/\$\[/ end=/]/ contains=@templetorPython containedin=ALLBUT,templetorCodeBlock,templetorCode
syntax region templetorRawInterpolation start=/\$:{/ end=/}/ contains=@templetorPython containedin=ALLBUT,templetorCodeBlock,templetorCode
syntax region templetorRawInterpolation start=/\$:(/ end=/)/ contains=@templetorPython containedin=ALLBUT,templetorCodeBlock,templetorCode
syntax region templetorRawInterpolation start=/\$:\[/ end=/]/ contains=@templetorPython containedin=ALLBUT,templetorCodeBlock,templetorCode

highlight link templetorCodeStart PreProc
highlight link templetorCode Normal
highlight link templetorCodeBlock PreProc
highlight link templetorInterpolation PreProc
highlight link templetorRawInterpolation Special

let b:current_syntax = 'templetor'
