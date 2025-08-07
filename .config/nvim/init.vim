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
call plug#end()

""" Colors
colorscheme vscode_modern
hi Normal guibg=Transparent
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

" Improved version that comments all selected lines
function! CommentVisual() range
    " Get the comment string for the current filetype
    let comment_string = ''
    if &filetype == 'python' || &filetype == 'sh' || &filetype == 'ruby' || &filetype == 'perl' || &filetype == 'yaml'
        let comment_string = '# '
    elseif &filetype == 'javascript' || &filetype == 'typescript' || &filetype == 'java' || &filetype == 'c' || &filetype == 'cpp' || &filetype == 'go'
        let comment_string = '// '
    elseif &filetype == 'vim'
        let comment_string = '" '
    elseif &filetype == 'lua'
        let comment_string = '-- '
    elseif &filetype == 'html' || &filetype == 'xml'
        let comment_string = '<!-- '
        let comment_end = ' -->'
    elseif &filetype == 'css' || &filetype == 'scss'
        let comment_string = '/* '
        let comment_end = ' */'
    else
        " Default to # if no specific comment string is found
        let comment_string = '# '
    endif

    " Save the current register and cursor position
    let save_reg = @"
    let save_pos = getpos(".")

    " For line-wise visual mode (V)
    if mode() == 'V'
        if exists('comment_end')
            execute "'<,'>s/^/" . comment_string . "/"
            execute "'<,'>s/$/" . comment_end . "/"
        else
            execute "'<,'>s/^/" . comment_string . "/"
        endif
    else
        " For character-wise visual mode (v)
        let lines = getline("'<", "'>")
        let new_lines = []
        
        if exists('comment_end')
            for line in lines
                if line ==# lines[0] && line ==# lines[-1]
                    " Single line selection
                    call add(new_lines, comment_string . line . comment_end)
                elseif line ==# lines[0]
                    " First line of multi-line selection
                    call add(new_lines, comment_string . line)
                elseif line ==# lines[-1]
                    " Last line of multi-line selection
                    call add(new_lines, line . comment_end)
                else
                    " Middle lines
                    call add(new_lines, line)
                endif
            endfor
        else
            for line in lines
                call add(new_lines, comment_string . line)
            endfor
        endif
        
        call setline("'<", new_lines)
    endif

    " Restore register and cursor position
    call setpos('.', save_pos)
    let @" = save_reg
endfunction

" Map the function to Ctrl-/ in visual mode
vnoremap <C-/> :call CommentVisual()<CR>

" Symbol renaming
nnoremap RN <Plug>(coc-rename)
