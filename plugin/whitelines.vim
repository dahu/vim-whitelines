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


function! s:positions_to_visual_selection(spos, epos)
  return a:spos[1] . 'G0' . a:spos[2] . '|' . 'o' . a:epos[1] . 'G0' . a:epos[2] . '|'
endfunction

function! s:get_positions(spat, epat)
  let curpos = getpos('.')
  call search(a:spat, 'bcW')
  let spos = getpos('.')
  call setpos('.', curpos)
  call search(a:epat, 'ceW')
  let epos = getpos('.')
  return [spos, epos]
endfunction

function! s:get_region(in, spat, epat)
  if call(a:in, [])
    let [spos, epos] = s:get_positions(a:spat, a:epat)
    return s:positions_to_visual_selection(spos, epos)
  else
    return "\<c-\>\<c-n>"
  endif
endfunction

function! s:in_white()
  return getline('.')[col('.')-1] =~ '^\s\?$'
endfunction

function! s:VAWS()
  return s:get_region('s:in_white', '\S\zs\_s', '\_s\S\@=')
endfunction

function! s:VIWS()
  return s:get_region('s:in_white', '\S\(\s*\n\)\=\zs\ze\_s*\%#', '\(\_s*\n\ze\s*\S\)\|\s*\ze\S')
endfunction

vnoremap <expr> <Plug>AllWhitespace    <SID>VAWS()
vnoremap <expr> <Plug>InnerWhitespace  <SID>VIWS()

if !hasmapto('<Plug>AllWhitespace')
  vmap     <unique><silent> az <Plug>AllWhitespace
  onoremap <unique><silent> az :normal vaz<CR>
endif

if !hasmapto('<Plug>InnerWhitespace')
  vmap     <unique><silent> iz <Plug>InnerWhitespace
  onoremap <unique><silent> iz :normal viz<CR>
endif

let &cpo = s:save_cpo
unlet s:save_cpo
