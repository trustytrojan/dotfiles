""" Use 4-space hard tabs
set tabstop=4
set shiftwidth=4
set noexpandtab

""" End here if vim-plug is absent
if ! isdirectory(getenv('HOME') . '/.local/share/nvim/plugged')
	finish
endif

""" vim-plug
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'gmr458/vscode_modern_theme.nvim'
call plug#end()

""" Syntax coloring
colorscheme vscode_modern
hi Normal guibg=#00000000
hi StatusLine guifg=#cccccc guibg=#005555
hi SignColumn guibg=#004040

""" coc.nvim
set signcolumn=yes
set updatetime=300

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
							  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
	endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
