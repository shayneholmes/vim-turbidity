scriptencoding utf-8

if &cp || !has("conceal") || exists("g:turbidity_loaded")
  finish
endif
let g:turbidity_loaded = 1

let s:default_character='0-9a-zA-Z_'
let s:default_show_first=0
let s:default_show_last=0

function! s:TurbidityObscure()
  if exists("b:turbidity_obscured")
    return
  endif

  let l:character=get(b:, "turbidity_character",
        \ get(g:, "turbidity_character", s:default_character))

  let l:show_first = get(b:, "turbidity_show_first",
        \ get(g:, "turbidity_show_first", s:default_show_first))
  let l:show_last = get(b:, "turbidity_show_last",
        \ get(g:, "turbidity_show_last", s:default_show_last))
  let l:min_match_size = 1 + l:show_first + l:show_last

  let b:turbidity_obscured=1
  let b:turbidity_saved_syntax=&l:syntax
  let b:turbidity_saved_conceallevel=&l:conceallevel
  let b:turbidity_saved_concealcursor=&l:concealcursor
  setlocal syntax=text
  setlocal conceallevel=1
  setlocal concealcursor=nvic
  exec "syntax match TurbidityWord"
        \ "'[" . l:character . "]\\{" . l:min_match_size . ",\\}'" .
        \ "ms=s+" . l:show_first .
        \ ",me=e-" . l:show_last
        \ "contains=TurbidityChar"
        \ "oneline"
  syntax match TurbidityChar contained '.' conceal
  syntax cluster Turbidity contains=TurbidityWord,TurbidityChar
endf

function! s:TurbidityElucidate()
  if !exists("b:turbidity_obscured")
    return
  endif
  unlet b:turbidity_obscured
  let &l:syntax=b:turbidity_saved_syntax
  let &l:conceallevel=b:turbidity_saved_conceallevel
  let &l:concealcursor=b:turbidity_saved_concealcursor
  unlet b:turbidity_saved_syntax
  unlet b:turbidity_saved_conceallevel
  unlet b:turbidity_saved_concealcursor
  syntax clear Turbidity
endf

function! s:TurbidityToggle()
  if exists("b:turbidity_obscured")
    call <SID>TurbidityElucidate()
  else
    call <SID>TurbidityObscure()
  endif
endf

command! Turbidity call <SID>TurbidityToggle()
noremap <script> <silent> <Plug>Turbidity :Turbidity<CR>

" vim: et ts=2 sts=0 sw=0
