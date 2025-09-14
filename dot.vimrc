""" Coloring
syntax on
set termguicolors

""" Other Configurations
filetype plugin indent on
set incsearch ignorecase smartcase hlsearch
set ruler laststatus=2 showcmd showmode
set fillchars+=vert:\
set wrap breakindent
set encoding=utf-8
set number
set numberwidth=3
set title

""" Plugin Configurations

" NERDTree
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'
let g:NERDTreeIgnore = ['^node_modules$', '^.git$']
let NERDTreeMouseMode = 3 " Single mouseclick

""" Filetype-Specific Configurations

""" Custom Mappings
let mapleader="\<Space>"
nmap \ <leader>q

nnoremap <leader>s :w<cr>
map <leader>t :NERDTreeToggle<CR>
map <leader>T :NERDTreeFind<CR>
map <leader>B :TagbarToggle<CR>

" map leader f to search
nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fh :Telescope help_tags<CR>
nnoremap <leader>fc :cclose<cr>

" Mapping CtrlP command
nnoremap <Leader>b :<C-U>CtrlPBuffer<CR>
nnoremap <Leader>p :Telescope find_files<CR>

noremap <Leader>de O(require('pry'); binding.pry)<ESC>+
autocmd FileType javascript noremap <Leader>de Oeval(require('pryjs').it);<ESC>+

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1 
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

set colorcolumn=131
set textwidth=130
set formatoptions=croqj

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
nnoremap <leader>cb :call CopyBufferPath('%')<CR>
nnoremap <leader>cB :call CopyBufferPath('%:p')<CR>

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=100 " keep 100 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching
set regexpengine=1 " avoid slow scrolling issue with vim ruby (https://github.com/vim-ruby/vim-ruby/issues/243)

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Don't wrap long lines
set nowrap

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
set startofline

" Extentions to look for when using `gf`
set suffixesadd+=.tsx,.ts,.js,.jsx,.scss,.css,.json

" Enable copying from vim to the system-clipboard
set clipboard=unnamedplus

" Vim-plug 
call plug#begin()
    Plug 'tomtom/tcomment_vim'
    Plug 'mileszs/ack.vim'
    Plug 'slim-template/vim-slim'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'BurntSushi/ripgrep'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'sharkdp/fd'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-endwise'
    Plug 'ervandew/supertab'
    Plug 'tpope/vim-rails'
    Plug 'neovim/nvim-lspconfig'
    Plug 'preservim/nerdtree'
    Plug 'dense-analysis/ale'
    Plug 'vim-airline/vim-airline'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/neosnippet.vim'
    Plug 'Shougo/neosnippet-snippets'
    Plug 'wsdjeg/vim-fetch'
    Plug 'tpope/vim-scriptease'
    Plug 'folke/which-key.nvim'
    Plug 'psliwka/vim-smoothie'
    Plug 'chrisgrieser/nvim-various-textobjs'

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

" Automatically place a git "=fix" line under the line with the matching sha
let @f = '/=fix3w"ayw"bdd/^pick a"bp0:s/^pick/fixup/2wr>zz/^fixup'

let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_disable_lsp = 1
let g:ale_linters = {'ruby': ['rubocop', 'ruby']}
let g:ale_fixers = {'ruby': ['rubocop']}
let g:ale_ruby_ruby_lsp_use_bundler = 1
let g:ale_fix_on_save = 1
nnoremap <Leader>aa <Plug>(ale_toggle)
nnoremap <Leader>ae <Plug>(ale_enable)
nnoremap <Leader>aj <Plug>(ale_next_wrap)
nnoremap <Leader>ak <Plug>(ale_previous_wrap)
nnoremap <Leader>al <Plug>(ale_last)
nnoremap <Leader>af <Plug>(ale_fix)

colorscheme catppuccin-mocha
let g:airline#extensions#ale#enabled = 1
let g:airline_theme = 'catppuccin'

nnoremap <Leader>cc :colorscheme catppuccin-mocha<cr> " Default colorscheme is bound as <L>cc
nnoremap <Leader>cd :colorscheme desert<cr>
nnoremap <Leader>ct :colorscheme catppuccin-mocha<cr>
nnoremap <Leader>cg :colorscheme gruvbox<cr>
nnoremap <Leader>ck :colorscheme sonokai<cr>
nnoremap <Leader>cl :colorscheme kanagawa-lotus<cr>
nnoremap <Leader>cm :colorscheme gruvbox-material<cr>
nnoremap <Leader>cs :colorscheme slate<cr>
nnoremap <Leader>cv :colorscheme vividchalk<cr>
nnoremap <Leader>cr :colorscheme railscasts<cr>
nnoremap <Leader>cw :colorscheme kanagawa-wave<cr>

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

let g:deoplete#enable_at_startup = 1

call deoplete#custom#option('sources', {
\ '_': ['vim.lsp'],
\})

set completeopt=menu,menuone,noselect,noinsert
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

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" ensure fetch is reloaded when sourcing .vimrc
runtime plugin/fetch.vim

set foldmethod=syntax
set foldlevelstart=99
