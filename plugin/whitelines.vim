" Vim global plugin file
" Description:	Multiline Whitespace Text Objects - aw & iw
" Maintainer:	Barry Arthur
" Version:	0.1
" Last Change:	2012-03-18
" License:	Vim License (see :help license)
" Location:	plugin/whitelines.vim

" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_whitelines")
      \ || &compatible
  let &cpo = s:save_cpo
  finish
endif
let g:loaded_whitelines = 1

function! s:VAW()
  let vcmd = "\<C-\>\<C-n>\<Esc>"
  if search('^\s*\%#\s*$', 'cn')
    call search('\(\%^\|\S\_s\)\zs\_s*\%#\s*$', 'bW')
    let vcmd = getpos('.')[1] . "Go"
    call search('\_s*\(\%$\n\|\ze\S\)', 'eW')
    let vcmd .= getpos('.')[1] . "G"
  endif
  return vcmd
endfunction

function! s:VIW()
  let vaw = s:VAW()
  if vaw !~ '\m[\x1b]' " If the result contains an <Esc>, not in our TO
    if vaw =~ '\(\d\+\)\D*\1'          " same line number
      let vaw = "\<c-\>\<c-n>\<esc>"   " so do nothing
    else
      let vaw .= 'k'
    endif
  endif
  return vaw
endfunction

vnoremap <expr> <Plug>AllWhitelines   <SID>VAW()
vnoremap <expr> <Plug>InnerWhitelines <SID>VIW()

if !hasmapto('<Plug>AllWhitelines')
  vmap     <unique><silent> aw <Plug>AllWhitelines
  onoremap <unique><silent> aw :normal vaw<CR>
endif

if !hasmapto('<Plug>InnerWhitelines')
  vmap     <unique><silent> iw <Plug>InnerWhitelines
  onoremap <unique><silent> iw :normal viw<CR>
endif




let &cpo = s:save_cpo
unlet s:save_cpo
