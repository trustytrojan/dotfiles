" Use 4-space hard tabs
set tabstop=4
set shiftwidth=4
set noexpandtab

" Colors
hi Identifier ctermfg=117
hi Function ctermfg=228
hi SignColumn ctermbg=0

" vim-plug
call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
call plug#end()

" coc.nvim
set updatetime=300
set signcolumn=yes
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
	endif
endfunction

lua <<EOF
-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
	highlight = { enable = true },
	rainbow = { enable = true, extended_mode = true }
}

-- nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require'nvim-tree'.setup {}
