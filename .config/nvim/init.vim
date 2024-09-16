" Use 4-space hard tabs
set tabstop=4
set shiftwidth=4
set noexpandtab

" End here if vim-plug is absent
if ! filereadable(getenv('HOME') . '/.local/share/nvim/site/autoload/plug.vim')
	finish
endif

""" vim-plug
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'gmr458/vscode_modern_theme.nvim'
Plug 'nvim-tree/nvim-web-devicons' " requires Hack Nerd Font
Plug 'nvim-tree/nvim-tree.lua'
call plug#end()

""" Colors
colorscheme vscode_modern
hi Normal guibg=Transparent
hi NvimTreeNormal guibg=Transparent
hi NvimTreeCursorLine guibg=#005555
hi link CocSemNamespace Type
hi StatusLine guifg=#cccccc guibg=#005555
hi SignColumn guibg=#004040

""" coc.nvim
set signcolumn=yes
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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
nnoremap RN <Plug>(coc-rename)

lua <<EOF
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- open tree on startup
require("nvim-tree.api").tree.toggle()
