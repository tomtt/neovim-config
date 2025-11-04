""" Coloring
syntax on
set termguicolors

""" Other Configurations
filetype plugin indent on
set incsearch ignorecase smartcase hlsearch
set ruler laststatus=2 showcmd showmode
set fillchars+=vert:\ 
set nowrap
set encoding=utf-8
set number
set numberwidth=3
set title
set autoread
set updatetime=500

augroup AutoRead
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI,TermClose,TermLeave *
        \ if mode() !=# 'c' | silent! checktime | endif
  autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk → buffer reloaded" | echohl None
augroup END

augroup RubyKeywords
  autocmd!
  autocmd FileType ruby,eruby,rake,rspec setlocal iskeyword+=?,!,=
augroup END

" Map K to LSP hover when a server attaches (buffer-local)
augroup LspHoverDocs
  autocmd!
  autocmd LspAttach * nnoremap <silent><buffer> <leader>fd <cmd>lua vim.lsp.buf.hover()<CR>
augroup END

""" Plugin Configurations

" NERDTree
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'
let g:NERDTreeIgnore = ['^node_modules$', '^.git$']
let NERDTreeMouseMode = 3 " Single mouseclick

""" Filetype-Specific Configurations
let g:no_ruby_maps = 1

""" Custom Mappings
let mapleader="\<Space>"
nmap \ <leader>q

nnoremap <leader>s :w<cr>
map <leader>n :NERDTreeToggle<CR>
map <leader>N :NERDTreeFind<CR>
map <leader>B :TagbarToggle<CR>

" map leader f to search
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=false<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
" List methods in the current buffer via LSP and jump
nnoremap <silent> <leader>fm <cmd>Telescope lsp_document_symbols symbols=method,function<CR>
" List functions/methods from the syntax tree
nnoremap <silent> <leader>ft <cmd>Telescope treesitter<CR>
" List lsp references
nnoremap <silent> <leader>fr <cmd>Telescope lsp_references<CR>
nnoremap <leader>fj <cmd>Telescope jumplist<CR>
nnoremap <leader>fc :cclose<cr>
"  <leader>fy is defined in lua/config.lua for finding yanks

noremap <Leader>de O(require('pry'); binding.pry)<ESC>+
autocmd FileType javascript noremap <Leader>de Oeval(require('pryjs').it);<ESC>+

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

set colorcolumn=131
set textwidth=130
set formatoptions=croqj
" <C-w>c sets width window to textwidth (value >130 because of line number column)
nnoremap <C-w>c 136<C-w>\|

" augroup KeepBuiltinGq
"   autocmd!
"   " When any LSP client attaches, restore builtin gq behavior
"   autocmd LspAttach * setlocal formatexpr= | setlocal formatprg=
" augroup END

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" use ,, to trigger emmet
let g:user_emmet_leader_key=','

" copy buffer path to clipboard and echo it
function! CopyBufferPath(expand_arg)
  let @+ = expand(a:expand_arg)
  echo @+
endfunction

" hands-on-home-row escape
inoremap kj <esc>
" ,k is already an emmet command, but I often want to add a comma and esc
inoremap ,kj ,<esc>
vnoremap kj <esc>

"""""""""""""""""""""""""
" Copy buffer paths <leader>c "
"""""""""""""""""""""""""
" relative path
nnoremap <leader>cb :call CopyBufferPath('%')<CR>
" full path
nnoremap <leader>cf :call CopyBufferPath('%:p')<CR>
" relative path with line number
nnoremap <leader>cB :let @+ = expand('%:.') . ':' . line('.') <Bar> echo @+<CR>
" command to run line as test
nnoremap <leader>cl :let @+ = 'br test ' . expand('%:.') . ':' . line('.') <Bar> echo @+<CR>

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=100 " keep 100 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching

" Disable mouse except when in command mode or on help pages
set mouse=ch

set smarttab
set autoindent
set copyindent " copy previous indentation on autoindenting
set showmatch " show matching parenthesis

" Don't show `-- INSERT --` below the statusbar since it's in the statusbar
set noshowmode

" Softtabs, 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set expandtab
set lazyredraw  " prevent redraws while executing

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" line move mappings
" ∆=A-j
nnoremap ∆ :m .+1<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
nnoremap \\ej :m .+1<CR>==
inoremap \\ej <Esc>:m .+1<CR>==gi
vnoremap \\ej :m '>+1<CR>gv=gv
" ˚=A-k
nnoremap ˚ :m .-2<CR>==
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ˚ :m '<-2<CR>gv=gv
nnoremap \\ek :m .-2<CR>==
inoremap \\ek <Esc>:m .-2<CR>==gi
vnoremap \\ek :m '<-2<CR>gv=gv

" Move cursor to first non-blank column of the line
set nostartofline

" Extentions to look for when using `gf`
set suffixesadd+=.tsx,.ts,.js,.jsx,.scss,.css,.json

" Enable copying from vim to the system-clipboard
set clipboard=unnamedplus

" Make <CR> its own undo step (so one undo removes just the newline)
inoremap <CR> <C-g>u<CR>
" <leader>Enter: undo the last insert action (typically that newline) and stay in Insert
inoremap <leader><CR> <C-o>u

cabbrev kp keeppatterns

" Vim-plug 
call plug#begin()
    Plug 'tomtom/tcomment_vim'
    Plug 'slim-template/vim-slim'
    Plug 'nvim-telescope/telescope.nvim'
    " Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'nvim-telescope/telescope-ui-select.nvim'
    Plug 'nvim-telescope/telescope-file-browser.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'vim-ruby/vim-ruby'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-rails'
    Plug 'tpope/vim-projectionist'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-scriptease'
    " Plug 'ervandew/supertab'
    Plug 'neovim/nvim-lspconfig'
    Plug 'preservim/nerdtree'
    Plug 'vim-airline/vim-airline'
    Plug 'Shougo/neosnippet.vim'
    Plug 'Shougo/neosnippet-snippets'
    Plug 'wsdjeg/vim-fetch'
    Plug 'folke/which-key.nvim'
    Plug 'psliwka/vim-smoothie'
    Plug 'chrisgrieser/nvim-various-textobjs'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'ggandor/leap.nvim'
    Plug 'antoinemadec/FixCursorHold.nvim'
    Plug 'nvim-neotest/nvim-nio'
    Plug 'nvim-neotest/neotest'
    Plug 'zidhuss/neotest-minitest'
    Plug 'Wansmer/treesj'
    Plug 'AndrewRadev/switch.vim'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'gbprod/yanky.nvim'
    Plug 'martineausimon/nvim-lilypond-suite'

    " Themes
    Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
    Plug 'rebelot/kanagawa.nvim'
    Plug 'lifepillar/vim-solarized8'
    Plug 'morhetz/gruvbox'
    Plug 'sainnhe/gruvbox-material'
    Plug 'sainnhe/sonokai'
    Plug 'tpope/vim-vividchalk' " accentuates rails.vim extensions
    Plug 'jpo/vim-railscasts-theme'
call plug#end()

lua require('config')
lua require('completion')

" Automatically place a git "=fix" line under the line with the matching sha
" This macro is now hopefully obsolete due to the s:FixupMove() method
let @f = '/=fix3w"ayiw"bdd/^pick a"bp0:s/^pick/fixup/2wr>zz/^fixup'

" Move a '=fix' commit line below its target commit and mark it '>fix'.
" Safe: prints a message if no =fix line or target pick is found.
function! s:FixupMove() abort
  " 1. Find the first line containing '=fix <sha>'
  let l:fixlnum = search('^pick\s\+\S\+\s\+=fix', 'n')
  if l:fixlnum == 0
    echo "No '=fix' line found"
    return
  endif

  " 2. Extract the full line and the target SHA
  let l:fixline = getline(l:fixlnum)
  let l:fields = split(l:fixline)
  if len(l:fields) < 4
    echo "Malformed '=fix' line: " .. l:fixline
    return
  endif
  let l:fixsha = l:fields[1]
  let l:targetsha = l:fields[4]

  " 3. Find the matching 'pick <targetsha>' line
  let l:targetlnum = search('^pick\s\+' . l:targetsha, 'n')
  if l:targetlnum == 0
    echo "No 'pick " . l:targetsha . "' found for " . l:fixsha
    return
  endif

  " 4. Construct new line: change 'pick' → 'fixup' and '=fix' → '>fix'
  let l:newline = substitute(l:fixline, '^pick', 'fixup', '')
  let l:newline = substitute(l:newline, '=fix', '>fix', '')

  " 5. Delete original =fix line
  call deletebufline('%', l:fixlnum)

  " Adjust target line number if deletion happened above it
  if l:fixlnum < l:targetlnum
    let l:targetlnum -= 1
  endif

  " 6. Insert new line right below the matching pick line
  call append(l:targetlnum, l:newline)

  " 7. Move cursor to the new fixup line and center screen
  call cursor(l:targetlnum + 1, 1)
  normal! zz

  echo "Fixup moved for " . l:fixsha . " -> " . l:targetsha
endfunction

nnoremap <silent> <leader>mf :<C-u>call <SID>FixupMove()<CR>


colorscheme desert
let g:airline_theme = 'catppuccin'

nnoremap <Leader>ccc :colorscheme desert<cr> " Default colorscheme is bound as <L>ccc
nnoremap <Leader>ccd :colorscheme desert<cr>
nnoremap <Leader>cct :colorscheme catppuccin-mocha<cr>
nnoremap <Leader>ccg :colorscheme gruvbox<cr>
nnoremap <Leader>cck :colorscheme sonokai<cr>
nnoremap <Leader>ccl :colorscheme kanagawa-lotus<cr>
nnoremap <Leader>ccm :colorscheme gruvbox-material<cr>
nnoremap <Leader>ccs :colorscheme slate<cr>
nnoremap <Leader>ccv :colorscheme vividchalk<cr>
nnoremap <Leader>ccr :colorscheme railscasts<cr>
nnoremap <Leader>ccw :colorscheme kanagawa-wave<cr>

let g:colors = getcompletion('', 'color')
func! NextColors()
    let idx = index(g:colors, g:colors_name)
    return (idx + 1 >= len(g:colors) ? g:colors[0] : g:colors[idx + 1])
endfunc
func! PrevColors()
    let idx = index(g:colors, g:colors_name)
    return (idx - 1 < 0 ? g:colors[-1] : g:colors[idx - 1])
endfunc
nnoremap <Leader>cn :exe "colo " .. NextColors()<CR>
nnoremap <Leader>cp :exe "colo " .. PrevColors()<CR>

set completeopt=menu,menuone,noselect,noinsert
set shortmess+=c
set wildmenu
set wildoptions+=fuzzy

nnoremap <Leader>ra <C-W>o:AV<cr>
nnoremap <Leader>rm :Emodel<Space>
nnoremap <Leader>rc :Econtroller<Space>
nnoremap <Leader>rl :Elocale<Space>
nnoremap <Leader>rn :Elocale nl<cr>
nnoremap <Leader>rv :Eview<Space>
nnoremap <Leader>rs :Eschema<Space>
nnoremap <Leader>ri :Emigration<Space>
nnoremap <Leader>rt :Rails test<cr>

function! s:IndentFileStick() abort
  " Save view (for scroll) and precise position
  let l:view       = winsaveview()
  let l:lnum       = line('.')
  let l:old_vcol   = virtcol('.')      " screen column (handles tabs)
  let l:old_indent = indent(l:lnum)     " indent in spaces

  " Reindent entire buffer
  keepjumps normal! gg=G

  " Compute how much this line's indent changed
  let l:new_indent  = indent(l:lnum)
  let l:delta       = l:new_indent - l:old_indent - 1
  let l:target_vcol = max([1, l:old_vcol + l:delta])

  " Go back to the same line and same screen column
  call cursor(l:lnum, 1)
  execute 'normal! ' . l:target_vcol . '|'

  " Restore scroll/viewport without moving the cursor we just placed
  let l:view.lnum     = line('.')
  let l:view.col      = col('.')
  let l:view.curswant = col('.')
  call winrestview(l:view)
endfunction

nnoremap <silent> <leader>= :<C-u>call <SID>IndentFileStick()<CR>

nnoremap <silent> <leader>zr :<C-u>normal! varzc<CR>

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" ensure fetch is reloaded when sourcing .vimrc
runtime plugin/fetch.vim

" function to create an alternate file if it does not exist
function! s:AlternateOrCreate() abort
  " Need projectionist for reliable alternates
  if !exists('*projectionist#query')
    try | A | catch | echoerr 'No alternate (Projectionist not available).' | endtry
    return
  endif

  " Get the resolved alternate path for the current buffer
  let alts = projectionist#query('alternate')   " -> [ [root, resolved_path], ... ]
  if type(alts) != type([]) || empty(alts) || empty(alts[0][1])
    echoerr 'No alternate mapping for this file.'
    return
  endif
  let alt = alts[0][1]

  " If it exists, just open it; else create it and drop in the template
  if filereadable(alt)
    execute 'edit' fnameescape(alt)
  else
    call mkdir(fnamemodify(alt, ':h'), 'p')
    execute 'edit' fnameescape(alt)
    " If a template is defined in your projections, apply it
    silent! AD
  endif
endfunction
nnoremap <silent> <leader>rA :call <SID>AlternateOrCreate()<CR>

" --- Helpers: select to the Nth next/prev uppercase OR underscore OR dash ---
function! OpToNextCU(include, cnt) abort
  let pat   = '\C[A-Z_-]'     " change this to '\u' if you want uppercase-only
  let save  = getpos('.')
  let line0 = line('.')

  " start a visual selection so the pending operator uses it
  normal! v

  let i = a:cnt
  while i > 0
    " W = no wrap; also keep it on the same line (t/f semantics)
    if search(pat, 'W') == 0 || line('.') != line0
      normal! v | call setpos('.', save) | return
    endif
    let i -= 1
  endwhile

  " t-like: stop BEFORE the match; f-like: include the match
  if !a:include && col('.') > 1
    normal! h
  endif
endfunction

function! OpToPrevCU(include, cnt) abort
  let pat   = '\C[A-Z_-]'
  let save  = getpos('.')
  let line0 = line('.')

  normal! v

  let i = a:cnt
  while i > 0
    if search(pat, 'bW') == 0 || line('.') != line0
      normal! v | call setpos('.', save) | return
    endif
    let i -= 1
  endwhile

  " T-like: stop just AFTER the match; F-like: include the match
  if !a:include && col('.') < col('$') - 1
    normal! l
  endif
endfunction

" --- Dispatcher: make t/f/T/F recognize the special <C-u> variant with counts ---
function! Op_dispatch_t() abort
  let c = getcharstr()
  if c ==# "\<C-u>"
    return "\<Cmd>call OpToNextCU(0," . v:count1 . ")\<CR>"
  endif
  return 't' . c
endfunction

function! Op_dispatch_f() abort
  let c = getcharstr()
  if c ==# "\<C-u>"
    return "\<Cmd>call OpToNextCU(1," . v:count1 . ")\<CR>"
  endif
  return 'f' . c
endfunction

function! Op_dispatch_T() abort
  let c = getcharstr()
  if c ==# "\<C-u>"
    return "\<Cmd>call OpToPrevCU(0," . v:count1 . ")\<CR>"
  endif
  return 'T' . c
endfunction

function! Op_dispatch_F() abort
  let c = getcharstr()
  if c ==# "\<C-u>"
    return "\<Cmd>call OpToPrevCU(1," . v:count1 . ")\<CR>"
  endif
  return 'F' . c
endfunction

" Operator-pending expression mappings
onoremap <silent> <expr> t Op_dispatch_t()
onoremap <silent> <expr> f Op_dispatch_f()
onoremap <silent> <expr> T Op_dispatch_T()
onoremap <silent> <expr> F Op_dispatch_F()

let g:switch_custom_definitions =
    \ [
    \ switch#Words(['y', 'n']),
    \ switch#Words(['yes', 'no']),
    \ switch#Words(['assert_not', 'assert']),
    \ switch#Words(['assert_not_includes', 'assert_includes'])
    \ ]

nnoremap <buffer> <leader>cp :!to_pdf %<Enter>
