" Vim syntax file
" Language:		Paskalo
" Maintainer:		Doug Kearns <dougkearns@gmail.com>
" Last Change:		2021 May 20

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case ignore
syn sync lines=250

syn keyword paskalBoolean	vera malvera
syn keyword paskalConditional	se tiam alie
syn keyword paskalConstant	nul maksEnt
syn keyword paskalLabel		okazo al marko markoj
syn keyword paskalOperator	kaj div sube en mod ne el aŭ pakita
syn keyword paskalRepeat	faru por faru ripetu dum supre ĝis
syn keyword paskalStatement	proceduro funkcio
syn keyword paskalStatement	programo starto fino konst var tipo tipoj super
syn keyword paskalStruct	rikordo
syn keyword paskalType		tabelo Bulea signa signaj entjera entjeraj dosiero dosieroj reela reelaj aro aroj
syn keyword paskalType		teksta tekstaj


    " 20010723az: When wanted, highlight the trailing whitespace -- this is
    " based on c_space_errors; to enable, use "paskal_space_errors".
if exists("paskal_space_errors")
  if !exists("paskal_no_trail_space_error")
    syn match paskalSpaceError "\s\+$"
  endif
  if !exists("paskal_no_tab_space_error")
    syn match paskalSpaceError " \+\t"me=e-1
  endif
endif



" String
if !exists("paskal_one_line_string")
  syn region  paskalString matchgroup=paskalString start=+'+ end=+'+ contains=paskalStringEscape
  if exists("paskal_gpc")
    syn region  paskalString matchgroup=paskalString start=+"+ end=+"+ contains=paskalStringEscapeGPC
  else
    syn region  paskalStringError matchgroup=paskalStringError start=+"+ end=+"+ contains=paskalStringEscape
  endif
else
  "wrong strings
  syn region  paskalStringError matchgroup=paskalStringError start=+'+ end=+'+ end=+$+ contains=paskalStringEscape
  if exists("paskal_gpc")
    syn region  paskalStringError matchgroup=paskalStringError start=+"+ end=+"+ end=+$+ contains=paskalStringEscapeGPC
  else
    syn region  paskalStringError matchgroup=paskalStringError start=+"+ end=+"+ end=+$+ contains=paskalStringEscape
  endif

  "right strings
  syn region  paskalString matchgroup=paskalString start=+'+ end=+'+ oneline contains=paskalStringEscape
  " To see the start and end of strings:
  " syn region  paskalString matchgroup=paskalStringError start=+'+ end=+'+ oneline contains=paskalStringEscape
  if exists("paskal_gpc")
    syn region  paskalString matchgroup=paskalString start=+"+ end=+"+ oneline contains=paskalStringEscapeGPC
  else
    syn region  paskalStringError matchgroup=paskalStringError start=+"+ end=+"+ oneline contains=paskalStringEscape
  endif
end
syn match   paskalStringEscape		contained "''"
syn match   paskalStringEscapeGPC	contained '""'


" syn match   paskalIdentifier		"\<[a-zA-Z_][a-zA-Z0-9_]*\>"


if exists("paskal_symbol_operator")
  syn match   paskalSymbolOperator      "[+\-/*=]"
  syn match   paskalSymbolOperator      "[<>]=\="
  syn match   paskalSymbolOperator      "<>"
  syn match   paskalSymbolOperator      ":="
  syn match   paskalSymbolOperator      "[()]"
  syn match   paskalSymbolOperator      "\.\."
  syn match   paskalSymbolOperator       "[\^.]"
  syn match   paskalMatrixDelimiter	"[][]"
  "if you prefer you can highlight the range
  "syn match  paskalMatrixDelimiter	"[\d\+\.\.\d\+]"
endif

syn match  paskalNumber		"-\=\<\d\+\>"
if !exists("paskal_traditional")
  syn match  paskalHexNumber	"\$\x\+\>"
endif
if exists("paskal_fpc")
  syn match	paskalOctNumber "&\o\+\>"
  syn match	paskalBinNumber	"%[01]\+\>"
endif
if exists("paskal_gpc")
  syn match  paskalExtendedNumber	"\%([2-9]\|[12]\d\|3[0-6]\)#[[:alnum:]]\+\>"
endif

syn match  paskalFloat		"-\=\<\d\+\.\d\+\>"
syn match  paskalFloat		"-\=\<\d\+\.\d\+[eE]-\=\d\+\>"

if exists("paskal_no_tabs")
  syn match paskalShowTab "\t"
endif

syn region paskalComment	start="(\*\|{"  end="\*)\|}" contains=paskalTodo,paskalSpaceError


  " array functions
  syn keyword paskalFunction	paku malpaku

  " memory function
  syn keyword paskalFunction	detruu kreu

  " math functions
  syn keyword paskalFunction	abs tanArk kos eksp ln sin kvad rad

  " file functions
  syn keyword paskalFunction	doFin liFin skribu skribuLin
  syn keyword paskalPredefined	enigo eligo

  syn keyword paskalFunction	prenu paĝo metu

  " ordinal functions
  syn keyword paskalFunction	nepara ant sek

  " transfert functions
  syn keyword paskalFunction	sgn nro ronde trunk

    " file functions
    syn keyword paskalFunction  legu leguLin hejmen reskribu

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

hi def link paskalAccess		paskalStatement
hi def link paskalBoolean		Boolean
hi def link paskalComment		Comment
hi def link paskalDocumentation		Comment
hi def link paskalConditional		Conditional
hi def link paskalConstant		Constant
hi def link paskalControlCharacter	Character
hi def link paskalDelimiter		Identifier
hi def link paskalDirective		paskalStatement
hi def link paskalException		Exception
hi def link paskalFloat			Float
hi def link paskalFunction		Function
hi def link paskalLabel			Label
hi def link paskalMatrixDelimiter	Identifier
hi def link paskalModifier		Type
hi def link paskalNumber		Number
hi def link paskalExtendedNumber	Number
hi def link paskalBinNumber		paskalNumber
hi def link paskalHexNumber		paskalNumber
hi def link paskalOctNumber		paskalNumber
hi def link paskalOperator		Operator
hi def link paskalPredefined		paskalStatement
hi def link paskalPreProc		PreProc
hi def link paskalRepeat		Repeat
hi def link paskalSpaceError		Error
hi def link paskalStatement		Statement
hi def link paskalString		String
hi def link paskalStringEscape		Special
hi def link paskalStringEscapeGPC	Special
hi def link paskalStringError		Error
hi def link paskalStruct		paskalStatement
hi def link paskalSymbolOperator	paskalOperator
hi def link paskalTodo			Todo
hi def link paskalType			Type
hi def link paskalUnclassified		paskalStatement
hi def link paskalError			Error
hi def link paskalAsmKey		paskalStatement
hi def link paskalShowTab		Error



let b:current_syntax = "paskalo"

" vim: nowrap sw=2 sts=2 ts=8 noet:
