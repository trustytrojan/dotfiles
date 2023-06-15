" Don't expand tabs into spaces
set noexpandtab

" Render tabs as 4 spaces
set tabstop=4
set shiftwidth=4

" Custom highlight colors
highlight Statement ctermfg=133 cterm=bold
highlight Operator ctermfg=15
highlight Function ctermfg=228
highlight Identifier ctermfg=117 cterm=NONE
highlight PreProc ctermfg=105

" vim-plug
call plug#begin()
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()

" coc.nvim
	" Some servers have issues with backup files, see #649
	set nobackup
	set nowritebackup

	" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
	" delays and poor user experience
	set updatetime=300

	" Always show the signcolumn, otherwise it would shift the text each time
	" diagnostics appear/become resolved
	set signcolumn=yes

	" Make <CR> to accept selected completion item or notify coc.nvim to format
	" <C-g>u breaks current undo, please make your own choice
	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
