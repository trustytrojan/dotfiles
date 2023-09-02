" Use 4-space hard tabs
set tabstop=4
set shiftwidth=4
set noexpandtab

" Custom highlighting
function! RefreshHighlighting()
	if &filetype == 'java'
		hi Identifier ctermfg=123 cterm=none
		hi Function ctermfg=228
		hi Statement ctermfg=210
		hi link PreProc Statement
		hi StorageClass ctermfg=104
		hi javaStorageClass ctermfg=177
		hi Type ctermfg=120
		hi link CocSemClass Type
	endif
endfunction

" vim-plug
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" coc.nvim QOL settings
set updatetime=500
set signcolumn=yes

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
