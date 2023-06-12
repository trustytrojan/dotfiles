" Configure tab behavior
set noexpandtab
set tabstop=4
set shiftwidth=4

set scroll=1

call plug#begin()
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()

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

autocmd ColorScheme * hi CocUnusedHighlight ctermbg=NONE guibg=NONE guifg=#808080

highlight CocSemType cterm=bold ctermfg=156
highlight CocSemEnumMember cterm=bold ctermfg=194
highlight CocSemVariable ctermfg=123
highlight CocSemFunction ctermfg=228
highlight CocSemMacro ctermfg=21

