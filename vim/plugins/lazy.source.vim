" deol.nvim ------------------------------
let g:deol#floating_border = "rounded"
let g:deol#enable_ddc_completion = v:true

let g:deol_float_window_col = g:float_window_col
let g:deol_float_window_row = g:float_window_row
let g:deol_float_window_width = g:float_window_width
let g:deol_float_window_height = g:float_window_height

let s:margin_width    = 25 * 2
let s:margin_height   = 30

function! s:get_vim_width() abort
  let l:vim_width = &columns
  let l:width = l:vim_width - s:margin_width
  if l:width < 0
    let l:width = l:vim_width
  endif
  return l:width
endfunction

function! s:get_vim_height() abort
  let l:vim_height = &lines
  let l:height = l:vim_height - s:margin_height
  if l:height < 0
    let l:height = l:vim_height
  endif
  return l:height
endfunction

"let s:width  = system('columns') - 10
let g:my_vim_width = s:get_vim_width()

"let s:width = s:window_width - 10
let g:my_vim_height = s:get_vim_height()

let g:deol#custom_map = {
      \   'edit': 'e',
      \   'start_insert': 'i',
      \   'start_insert_first': 'I',
      \   'start_append': 'a',
      \   'start_append_last': 'A',
      \   'execute_line': '<CR>',
      \   'previous_prompt': '<C-p>',
      \   'next_prompt': '<C-n>',
      \   'paste_prompt': '<C-y>',
      \   'bg': '<C-z>',
      \   'quit': 'q',
      \ }

" 【Ctrl + o】 float windowでターミナルを表示
nnoremap <silent><C-o> :<C-u>execute 'Deol' '-cwd=' . fnamemodify(expand('%'), ':h') . ' -split=floating' . ' -winrow=' . g:deol_float_window_row . ' -wincol=' . g:deol_float_window_col . ' -winwidth=' . g:deol_float_window_width . ' -winheight=' . g:deol_float_window_height . ' -auto-cd=' .v:true<CR>

" 【ESC】 ターミナルモードから抜ける
tnoremap <ESC>   <C-\><C-n>
