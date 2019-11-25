" Vim syntax file
" Language:	WML
" Maintainer:	Lasana Murray <metasansana@gmail.com> https://trinistorm.org
" Descrption:   WML is a DSL for views in web apps.

" This line is supposed to prevent the syntax from loading > 1
if exists("b:current_syntax")
  finish
endif

" Note: The precendence of the rules specified here are bottom up.
"       That is, the later rules are matched before the ones before it.

" Keywords 
syntax keyword wmlBoolean true false contained
syntax keyword wmlAs as contained
syntax keyword wmlFrom from contained
syntax keyword wmlImport import contained
syntax keyword wmlFun fun contained
syntax keyword wmlEndFun endfun contained
syntax keyword wmlView view contained
syntax keyword wmlFor for contained
syntax keyword wmlEndFor endfor contained
syntax keyword wmlIf if contained
syntax keyword wmlEndIf endif contained
syntax keyword wmlElse else contained
syntax keyword wmlIn in contained
syntax keyword wmlOf of contained
syntax keyword wmlBoolean true false contained

" Identifiers and various punctuation

syntax match wmlEqual "\v\=" contained
syntax match wmlAttributeEqual "\v\=" contained
syntax match wmlComma "\v," contained
syntax match wmlColon "\v:" contained
syntax match wmlParens "\v[()]" contained
syntax match wmlBrace "\v\{\{" contained
syntax match wmlControlStart "\v[{][%]" contained
syntax match wmlControlEnd "\v[%][}]" contained
syntax match wmlStar "\v[*]" contained
syntax match wmlPipe "\v[|]" contained

syntax match wmlIdentifier "\v[a-z_][a-zA-Z_$0-9-]*" contained
syntax match wmlConstructor "\v[A-Z][a-zA-Z_$0-9-]*" contained
syntax match wmlViewName "\v[A-Z][a-zA-Z_$0-9-]*" contained
syntax match wmlWidgetName "\v[A-Z][a-zA-Z_$0-9-]*" contained
syntax match wmlFunName "\v[a-z_][a-zA-Z_$0-9-]*" contained

" Numbers
syntax match wmlNumber 
      \ "\v([-]?[-]?([0]|([1-9]([0-9]+)*))\.([0-9]+)*)|(\.[0-9]+)|([-]?([0]|[1-9]([0-9]+)*))" 
      \ contained

" Strings
syntax region wmlString 
      \ start=/"/ 
      \ skip=/\\"/ 
      \ end=/"/
      \ contains=wmlUnicodeEscape,wmlCharEscape,wmlLineContinuation,
      \ wmlLineContinuationError
      \ contained

syntax match wmlUnicodeEscape "\v\\u[0-9a-fA-F]{4}" contained
syntax match wmlCharEscape "\v\\["\\bfnrtv]" contained 
syntax match wmlLineContinuation +\v[\\]\n[^"]*+ contained 
syntax match wmlLineContinuationError +\v\n[^"]*+ contained 

" Records
syntax region wmlRecord 
      \ start="\v\{"
      \ end="\v\}"
      \ contains=wmlPropertyName
      \ contained

syntax match wmlPropertyName "\v[a-z$_][a-zA-Z$0-9_-]*:"
      \ nextgroup=@wmlExpression
      \ skipwhite
      \ skipempty
      \ contained

" Arrays
syntax region wmlArray 
      \ start="\v\["
      \ end="\v\]" 
      \ contains=@wmlExpression,wmlComma
      \ contained

" Imports

syntax match wmlMember "\v[a-z_A-Z][a-zA-Z_$0-9-]*" contained

syntax match wmlAggMember "\v[*]\s*as\s*[a-z_][a-zA-Z_$0-9-]*" 
      \ contains=wmlStar,wmlAs,wmlMember
      \ contained

syntax match wmlAliasMemberI
      \ "\v[a-z_][a-zA-Z_$0-9-]*\s+as\s+[a-z_][a-zA-Z_$0-9-]*" 
      \ contains=wmlMember,wmlAs
      \ contained

syntax match wmlAliasMemberC
      \ "\v[A-Z][a-zA-Z_$0-9-]*\s+as\s+[A-Z][a-zA-Z_$0-9-]*" 
      \ contains=wmlMember,wmlAs
      \ contained

syntax region wmlCompMember 
      \ start="\v\("
      \ end=")"
      \ contains=wmlParens,wmlMember,wmlAliasMemberI,
      \          wmlAliasMemberC
      \ contained
      \ keepend

syntax region wmlImportStatement
      \ start="\v[{][%]\s*import"
      \ end="%}"
      \ contains=wmlControlStart,wmlImport,wmlAggMember,wmlCompMember,wmlFrom,
      \          wmlString,wmlControlEnd
      \ keepend

" Operators that can be used in expressions
syntax match wmlOperator "\v\+" contained
syntax match wmlOperator "\v-" contained
syntax match wmlOperator "\v\*" contained
syntax match wmlOperator "\v[/]" contained
syntax match wmlOperator "\v!" contained
syntax match wmlOperator "\v[?]" contained
syntax match wmlOperator "\v^" contained
syntax match wmlOperator "\v\<\=" contained
syntax match wmlOperator "\v\&\&" contained
syntax match wmlOperator "\v\|\|" contained
syntax match wmlOperator "\v\=\=" contained
syntax match wmlOperator "\v!\=" contained
syntax match wmlOperator "\v\>\=" contained
syntax match wmlOperator "\v\.{3}" contained

syntax cluster wmlExpression
      \ contains=wmlNumber,wmlBoolean,wmlOperator,wmlIdentifier,
      \          wmlAltString,wmlContextVariable,wmlContextProperty,
      \          wmlAnonFunc,wmlParens,wmlArray

syntax region wmlArguments 
      \ start="\v\("
      \ end="\v\)"
      \ contains=wmlComma,@wmlExpression
      \ contained

syntax region wmlParameters
      \ matchgroup=wmlParens
      \ start="\v\("
      \ end="\v\)"
      \ contains=wmlComma,wmlParameter
      \ contained

syntax region wmlParameter 
      \ start="\v[a-z$_][a-zA-Z$0-9_]*"
      \ matchgroup=wmlColon
      \ end="\v:"
      \ nextgroup=wmlParameterType
      \ skipwhite
      \ contained

syntax match wmlParameterType "\v[A-Z][a-zA-Z$0-9_]*"
      \ nextgroup=wmlGenericArguments
      \ skipwhite
      \ contained

syntax region wmlGenericArguments
      \ matchgroup=wmlBrace
      \ start="\v\["
      \ contains=wmlParameterType,wmlComma,wmlColon
      \ end="\v\]"
      \ contained 

syntax region wmlAnonFunc
      \ start="\v\\"
      \ end="\v-\>"
      \ contains=wmlParameter,wmlComma
      \ nextgroup=@wmlExpression
      \ skipwhite
      \ skipempty
      \ contained

syntax region wmlTypeParameters
      \ matchgroup=wmlParens
      \ start="\v\["
      \ end="\v\]"
      \ contains=wmlComma,wmlColon,wmlParameterType
      \ contained

syntax region wmlFunStatementStart
      \ start="\v[{][%]\s*fun\s*"
      \ end="\v\%\}"
      \ contains=wmlControlStart,wmlFun,wmlFunName,wmlTypeParameters,
      \          wmlParameters,wmlControlEnd
      \ nextgroup=@wmlChildren,@wmlEnd
      \ skipwhite
      \ skipnl
      \ keepend

syntax match wmlFunStatementEnd "\v\{\%\s*endfun\s*\%\}"
      \ contains=wmlControlStart,wmlEndFun,wmlControlEnd

syntax region wmlCharacters 
      \ start="\v[^<{](\s*(\{|\<))@!"
      \ end="\v[^<]\s*(\{)@="
      \ end="\v[^<]\s*(\<)@="
      \ nextgroup=@wmlChildren,@wmlEnd
      \ skipwhite
      \ skipempty
      \ contained 

syntax region wmlHTMLTagStart
      \ start="\v\<[a-z][a-z-]*(\.)@!"
      \ end="\v/\>"
      \ end="\v\>"
      \ contains=wmlAttribute
      \ nextgroup=@wmlChildren,@wmlEnd
      \ skipwhite
      \ skipempty
      \ contained

syntax match wmlAttribute "\v[a-z][a-zA-Z$0-9_-]*[=]"
      \ contains=wmlAttributeEqual
      \ nextgroup=@wmlAttributeValue
      \ skipwhite
      \ skipnl
      \ contained

syntax region wmlAttributeNS 
      \ start="\v[a-z][a-z]*(:)@="
      \ end=":"
      \ nextgroup=@wmlAttribute
      \ skipwhite
      \ skipnl
      \ contained

syntax cluster wmlAttributeValue 
      \ contains=wmlString,wmlNumber,wmlBoolean,wmlAttributeInterpolation

syntax match wmlHTMLTagEnd "\v\</[a-z][a-z-]*\>" 
      \ nextgroup=@wmlChildren,@wmlEnd
      \ skipwhite
      \ skipempty
      \ contained

syntax region wmlWidgetTagStart
      \ start="\v\<(([a-z$_][a-zA-Z0-9$_-]*\.)?([A-Z]))@="
      \ end="\v/\>"
      \ end="\v\>"
      \ contains=wmlWidgetName,wmlAttributeNS,wmlAttribute
      \ nextgroup=@wmlChildren,@wmlEnd
      \ skipwhite
      \ skipempty
      \ contained

syntax match wmlWidgetTagEnd "\v\</(([a-z$_][a-zA-Z0-9$_-]*)\.)?[A-Z][A-Za-z0-9$_-]*\>" 
      \ contains=wmlWidgetName
      \ nextgroup=@wmlChildren,@wmlEnd
      \ skipwhite
      \ skipempty
      \ contained

syntax region wmlAttributeInterpolation
      \ start="\v\{\{"
      \ end="\v\}\}"
      \ contains=wmlFilters,@wmlExpression
      \ keepend
      \ skipwhite
      \ skipempty
      \ contained

syntax region wmlInterpolation
      \ start="\v\{\{"
      \ end="\v\}\}"
      \ nextgroup=@wmlChildren,@wmlEnd
      \ contains=wmlFilters,@wmlExpression,wmlFunApplication,wmlViewConstruction
      \ keepend
      \ skipwhite
      \ skipempty
      \ contained

syntax region wmlFilters
      \ start="\v\|"
      \ end="\v\}\}"
      \ contains=wmlPipe,wmlFilter,wmlArguments
      \ contained

syntax match wmlFilter "\v[a-z$_][$_a-zA-Z0-9]*" contained

syntax region wmlFunApplication
      \ start="\v\<"
      \ end="\v\>"
      \ contains=wmlIdentifier,wmlArguments
      \ skipwhite
      \ skipempty
      \ contained

syntax region wmlViewConstruction
      \ start="\v\<\s*[A-Z][A-Za-z$_]*"
      \ end="\v\>"
      \ contains=wmlViewName,wmlArguments
      \ skipwhite
      \ skipempty
      \ contained

syntax region wmlAltString 
      \ start=/'/ 
      \ skip=/\\'/ 
      \ end=/'/
      \ contains=wmlUnicodeEscape,wmlCharEscape,wmlLineContinuation,
      \          wmlLineContinuationError
      \ contained

syntax match wmlContextVariable "\v\@" 
      \ contained

syntax match wmlContextProperty "\v\@[a-zA-Z$-][a-zA-Z_$0-9-]*" 
      \ contains=wmlContextVariable,wmlIdentifier
      \ contained

syntax match wmlPropertyExpression "\v[@a-zA-Z_$a](\.[a-zA-Z_$0-9-])+" 
      \ contains=wmlDot
      \ skipwhite 

syntax region wmlIfStatement
      \ start="\v\{\%\s*if\s*"
      \ end="\v\%\}"
      \ contains=wmlControlStart,wmlIf,@wmlExpression,wmlControlEnd
      \ nextgroup=@wmlChildren,wmlElseStatement,wmlElseIfStatement,
      \           wmlEndIfStatement
      \ skipwhite
      \ skipempty
      \ keepend

syntax match wmlEndIfStatement "\v\{\%\s*endif\s*\%\}"
      \ contains=wmlControlStart,wmlEndIf,wmlControlEnd
      \ nextgroup=@wmlChildren,@wmlEnd
      \ skipwhite
      \ skipempty

syntax match wmlElseStatement "\v\{\%\s*else\s*\%\}"
      \ contains=wmlControlStart,wmlElse,wmlControlEnd
      \ nextgroup=@wmlChildren,wmlElseStatement,wmlElseIfStatement,
      \           wmlEndIfStatement
      \ skipwhite
      \ skipempty

syntax region wmlElseIfStatement
      \ start="\v\{\%\s*else\s*if\s*"
      \ matchgroup=wmlControlEnd
      \ end="\v\%\}"
      \ contains=wmlControlStart,wmlElse,wmlIf,@wmlExpression
      \ nextgroup=@wmlChildren,wmlElseStatement,wmlElseIfStatement,
      \           wmlEndIfStatement
      \ skipwhite
      \ skipempty

syntax region wmlForStatement
      \ start="\v\{\%\s*for\s*"
      \ matchgroup=wmlControlEnd
      \ end="\v\%\}"
      \ contains=wmlControlStart,wmlFor,wmlIn,wmlOf,@wmlExpression
      \ nextgroup=@wmlChildren,wmlElseStatement,@wmlEndForStatement
      \ skipwhite
      \ skipempty
      \ keepend

syntax match wmlEndForStatement "\v\{\%\s*endfor\s*\%\}"
      \ contains=wmlControlStart,wmlEndFor,wmlControlEnd
      \ nextgroup=@wmlChildren,@wmlEnd
      \ skipwhite
      \ skipempty

syntax region wmlNestedComment 
      \ start="\v\<\!\-\-"
      \ end="\v--\>"
      \ nextgroup=@wmlChildren,@wmlEnd
      \ skipwhite
      \ skipempty

syntax cluster wmlChildren
      \ contains=wmlHTMLTagStart,wmlWidgetTagStart,wmlInterpolation,
      \          wmlIfStatement,wmlForStatement,wmlNestedComment,wmlCharacters

syntax cluster wmlEnd
      \ contains=wmlHTMLTagEnd,wmlWidgetTagEnd,wmlEndIfStatement,
      \         wmlEndForStatement,wmlFunStatementEnd

syntax region wmlViewContext
      \ matchgroup=wmlParens
      \ start="\v\("
      \ contains=wmlParameterType
      \ end="\v\)"
      \ contained

syntax region wmlViewStatement
      \ start="\v[{][%]\s*view\s*"
      \ end="\v\%\}"
      \ contains=wmlControlStart,wmlView,wmlViewName,wmlViewContext,
      \          wmlTypeParameters,wmlControlEnd
      \ nextgroup=@wmlChildren
      \ skipwhite
      \ skipempty
      \ keepend

syntax region wmlComment 
      \ start="\v\<\!\-\-"
      \ end="\v--\>"
      
" Hilighting
highlight default link wmlParens Delimiter
highlight default link wmlPipe Delimiter
highlight default link wmlBrace Delimiter
highlight default link wmlControlStart Delimiter
highlight default link wmlControlEnd Delimiter
highlight default link wmlImport Include
highlight default link wmlFrom Include
highlight default link wmlAs Include
highlight default link wmlFun Macro
highlight default link wmlEndFun Macro
highlight default link wmlView Macro
highlight default link wmlFor Macro
highlight default link wmlEndFor Macro
highlight default link wmlIf Macro
highlight default link wmlEndIf Macro
highlight default link wmlElse Macro
highlight default link wmlIn Macro
highlight default link wmlOf Macro
highlight default link wmlStar Macro
highlight default link wmlEqual Operator
highlight default link wmlAttributeEqual Statement
highlight default link wmlComma Operator
highlight default link wmlColon Delimiter
highlight default link wmlOperator Operator
highlight default link wmlBoolean Boolean
highlight default link wmlNumber Number
highlight default link wmlString String
highlight default link wmlArray Delimiter
highlight default link wmlRecord Delimiter
highlight default link wmlIdentifier Identifier
highlight default link wmlAltString Constant
highlight default link wmlContextVariable Constant
highlight default link wmlFunName None
highlight default link wmlViewName None
highlight default link wmlType Type
highlight default link wmlHTMLTagStart Statement
highlight default link wmlHTMLTagEnd Statement
highlight default link wmlWidgetTagStart Statement
highlight default link wmlWidgetTagEnd Statement
highlight default link wmlAttribute Type
highlight default link wmlInterpolation Delimiter
highlight default link wmlAttributeInterpolation Delimiter
highlight default link wmlFilters Delimiter
highlight default link wmlFilter Identifier
highlight default link wmlArguments Delimiter
highlight default link wmlCharacters Special
highlight default link wmlParameterType Type
highlight default link wmlAttributeNS Statement
highlight default link wmlAnonFunc Constant
highlight default link wmlFunApplication Delimiter
highlight default link wmlViewConstruction Delimiter
highlight default link wmlComment Comment
highlight default link wmlNestedComment Comment
