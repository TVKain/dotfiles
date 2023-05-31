
" set all&

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.
colorscheme default

" display indentation guides
" Ref: https://stackoverflow.com/a/2159997
set list listchars=tab:❘-,trail:·,extends:»,precedes:«,nbsp:×

set showmode                " Show current mode in command-line.
set showcmd                 " Show already typed keys when more are expected.

set splitbelow              " Open new windows below the current window.
set splitright              " Open new windows right of the current window.

set cursorline              " Find the current line quickly.
" smart set cursorline
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

set ruler                   " show cursor position

set magic                   " For regular expressions turn magic on

set wrapscan                " Searches wrap around end-of-file.

set report=0                " Always report changed lines.

"set mouse=a                " To enable mouse support

set mouse=                  " To disable mouse support

" set highlight search
set noswapfile " disable the swapfile
set hlsearch " highlight all results
set ignorecase " ignore case in search
set incsearch " show search results as you type

" Persistent undo
" Don't forget mkdir folder $HOME/.local/share/nvim/undo
set undofile
set undodir=$HOME/.local/share/vim/undo
set undolevels=1000
set undoreload=10000

set scrolloff=9
"set scrolloff=9999


"-----------------------------------------------------------
"        Status line
"-----------------------------------------------------------
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:%l\ \ Column:%c\ \ Filetype:%{&filetype}

"-----------------------------------------------------------
"        indentation and tab relate
"-----------------------------------------------------------
vnoremap < <gv
vnoremap > >gv

set autoindent              " Indent according to previous line.
set smarttab                " Be smart when using tabs ;)
set expandtab               " Use spaces instead of tabs.
set tabstop=4
set softtabstop =4          " Tab key indents by 4 spaces.
set shiftwidth  =4          " >> indents by 4 spaces.
set shiftround              " >> indents to next multiple of 'shiftwidth'.

"-----------------------------------------------------------
"        keymap custom
"-----------------------------------------------------------
inoremap kk <ESC>
let mapleader = " "
map ; <leader>
noremap <Leader>s :w<CR>
noremap <Leader>q :q<CR>
noremap <Leader>x :x<CR>

" Disable paste for using supertab plugin
set paste
" set paste on the fly
" noremap <leader>p :set paste<CR>
" unset paste on the fly
" noremap <leader>P :set nopaste<CR>
nnoremap <expr> <leader>p &paste =~ '1' ? ':set nopaste<cr>' : ':set paste<cr>'

" jump to next tab
noremap <leader>t gt
" jump to previous tab
noremap <leader>T gT

set number
"" set adaptive toggle number
nnoremap <expr> <leader>n &number =~# '1' ? ':set nonumber<cr>' : ':set number<cr>'
set relativenumber
nnoremap <expr> <leader>N &relativenumber =~ '1' ? ':set norelativenumber<cr>' : ':set relativenumber<cr>'

" tabnew
noremap <leader>tn :tabnew 

" set wrap on the fly
set wrap    " set wrap on the fly
nnoremap <expr> <leader>w &wrap =~ '1' ? ':set nowrap<cr>' : ':set wrap<cr>'

" Reload config
noremap <leader>r :so ~/.vim/server.vimrc<CR>
" noremap <leader>R :so ~/.vim/vimrc.local<CR>
noremap <leader>R :so ~/.vim/vimrc<CR>

" Make Ctrl-w undoable
inoremap <C-w> <C-g>u<C-w>

"-----------------------------------------------------------
"        other config
"-----------------------------------------------------------

" To copy to clipboard of host, first, vim must compile with +xterm_clipboard,
" then set below config, or easier install vim-gtk3.
set clipboard=unnamedplus