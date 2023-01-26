if g:is_enable_my_debug
  echo "begin /plugins/ddc.vim load"
endif

call ddc#custom#patch_global('ui', 'pum')
" Customize global settings
" Use around source.
" https://github.com/Shougo/ddc-around
let s:sources = [
      \   'around',
      \   'buffer',
      \   'cmdline-history',
      \   'dictionary',
      \   'file',
      \   'nvim-lsp',
      \   'shell-history',
      \   'vsnip',
      \ ]

if has('win32')
  let s:sources = add(s:sources, 'windows-clipboard-history')
endif
call ddc#custom#patch_global('sources', s:sources)

call ddc#custom#patch_global('cmdlineSources', {
      \   ':': ['cmdline-history', 'cmdline', 'around'],
      \   '@': ['cmdline-history', 'input', 'file', 'around'],
      \   '>': ['cmdline-history', 'input', 'file', 'around'],
      \   '/': ['around', 'line'],
      \   '?': ['around', 'line'],
      \   '-': ['around', 'line'],
      \   '=': ['input'],
      \ })

" Use matcher_head and sorter_rank.
" https://github.com/Shougo/ddc-matcher_head
" https://github.com/Shougo/ddc-sorter_rank
let s:source_options = {
      \   "_": #{
      \     mark: '  ',
      \     ignoreCase: v:true,
      \     matchers: ['matcher_fuzzy'],
      \     sorters: ['sorter_fuzzy'],
      \     converters: ['converter_fuzzy'],
      \   },
      \   "around": #{
      \     mark: '  '
      \   },
      \   "nvim-lsp": #{
      \     mark: '  ',
      \     forceCompletionPattern: '\.\w*|:\w*|->\w*',
      \     minKeywordLength: 1,
      \     maxKeywordLength: 50,
      \   },
      \   "cmdline-history": #{
      \     mark: '  ',
      \     minKeywordLength: 1,
      \     maxKeywordLength: 50,
      \   },
      \   "shell-history": #{
      \     mark: '  ',
      \     minKeywordLength: 1,
      \     maxKeywordLength: 50,
      \   },
      \   'vsnip': #{
      \     mark: '  ',
      \     matchers: ['matcher_head', 'matcher_fuzzy'],
      \     sorters: ['sorter_rank', 'sorter_fuzzy'],
      \     minKeywordLength: 1,
      \     maxKeywordLength: 50,
      \   },
      \   'buffer': #{
      \     mark: '  ',
      \     matchers: ['matcher_head', 'matcher_fuzzy'],
      \     sorters: ['sorter_rank', 'sorter_fuzzy'],
      \     minKeywordLength: 1,
      \     maxKeywordLength: 50,
      \   },
      \   'file': #{
      \     mark: '  ',
      \     matchers: ['matcher_fuzzy'],
      \     sorters: ['sorter_fuzzy'],
      \     converters: ['converter_fuzzy'],
      \     maxCandidates: 16, 
      \     minKeywordLength: 1,
      \     maxKeywordLength: 50,
      \   },
      \   'dictionary': #{
      \     mark: '  ',
      \     matchers: ['matcher_fuzzy'],
      \     sorters: ['sorter_fuzzy'],
      \     converters: ['converter_fuzzy'],
      \     maxCandidates: 16, 
      \     minKeywordLength: 1,
      \     maxKeywordLength: 50,
      \   },
      \ }

if has('win32')
  let s:source_options["windows-clipboard-history"] = #{ mark: '', }
endif
call ddc#custom#patch_global('sourceOptions', s:source_options)

let s:source_params = {
    \   '_': {
    \     'maxSize': 100,
    \   },
    \   'around': {
    \     'maxSize': 100
    \   },
    \   'vim-lsp': {
    \     'maxSize': 100,
    \   },
    \   'buffer': {
    \     'maxSize': 100,
    \     'requireSameFiletype': v:false,
    \     'limitBytes': 5000000,
    \     'fromAltBuf': v:true,
    \     'forceCollect': v:true,
    \   },
    \   'dictionary': {
    \     'maxSize': 100,
    \     'dictPaths': ['/usr/share/dict/words'],
    \     'smartCase': v:true,
    \     'showMenu': v:false
    \   },
    \ }
if has('win32')
  let s:source_params["windows-clipboard-history"] = #{ maxAbbrWidth: 100 }
endif

call ddc#custom#patch_global('sourceParms', s:source_params)

" Add matching patterns
call ddc#custom#patch_global('keywordPattern', '[a-zA-Z_:]\w*')


" Mappings

" Use pum.vim
call ddc#custom#patch_global('autoCompleteEvents', [
      \   'InsertEnter',
      \   'TextChangedI',
      \   'TextChangedP',
      \   'CmdlineEnter',
      \   'CmdlineChanged',
      \   'TermOutput',
      \ ])
call ddc#custom#patch_global('completionMenu', 'pum.vim')

" For insert mode completion
inoremap <silent><expr> <TAB>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<TAB>' : ddc#map#manual_complete()
inoremap <silent><expr> <C-n>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : '<C-n>'

inoremap <silent><expr> <CR>
      \ pum#visible() ? ddc#map#manual_complete() : '<CR>'

inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>

inoremap <silent><expr> <C-l>   ddc#map#extend()
inoremap <silent><expr> <C-x><C-f> ddc#map#manual_complete('path')

" Use ddc.
call ddc#enable()


if g:is_enable_my_debug
  echo "end /plugins/ddc.vim load"
endif

