" ===========================
"  Plugins (vim-plug)
" ===========================
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-which-key'

call plug#end()

" ===========================
"  Basic Settings
" ===========================
set nocompatible
set number
set relativenumber
set ruler
set showcmd
set showmatch
set hidden

" ===========================
"  Scroll / Cursor Position
" ===========================
set scrolloff=999

" ===========================
"  Indentation / Tab Settings
"  FreeBSD style(9)
" ===========================
set tabstop=8
set shiftwidth=8
set softtabstop=0
set noexpandtab
set autoindent

" ===========================
"  C-Specific / style(9)
" ===========================
set cindent
set cinoptions=(4200,u4200,+0.5s,*500,t0,U4200
set indentexpr=
set formatoptions=crql

" ===========================
"  Display
" ===========================
syntax on
filetype plugin indent on
set encoding=utf-8
set backspace=indent,eol,start
set textwidth=80

" ===========================
"  Search
" ===========================
set hlsearch
set incsearch
set ignorecase
set smartcase

" ===========================
"  Leader Key
" ===========================
let mapleader = " "
set timeoutlen=500

" ===========================
"  Which-Key
" ===========================
nnoremap <silent> <leader><leader> :WhichKey '<Space>'<CR>

" ===========================
"  Buffer Navigation
" ===========================
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>
nnoremap <leader>q :bd<CR>
nnoremap <leader>Q :bd!<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>ls :ls<CR>

" ===========================
"  Split Navigation
" ===========================
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>s :split<CR>
nnoremap <leader>v :vsplit<CR>

" ===========================
"  FZF
" ===========================
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>L :Lines<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>r :History<CR>

" ===========================
"  Manual  —  :Manual  or  Space m
" ===========================
nnoremap <leader>m :Manual<CR>

command! Manual call s:ShowManual()

let s:manual_line = 1
let s:manual_total = 0
let s:manual_height = 25

function! s:ShowManual()
    let s:manual_lines = [
        \ '',
        \ '  ╔═══════════════════════════════════════════════╗',
        \ '  ║              VIMRC MANUAL                     ║',
        \ '  ╚═══════════════════════════════════════════════╝',
        \ '',
        \ '   Leader key: Space',
        \ '',
        \ '   ┌─────────────────────────────────────────────┐',
        \ '   │  BUFFERS                                    │',
        \ '   ├─────────────────────────────────────────────┤',
        \ '   │  Tab          Next buffer                   │',
        \ '   │  Shift-Tab    Previous buffer               │',
        \ '   │  Space q      Close buffer                  │',
        \ '   │  Space Q      Close buffer (no save)        │',
        \ '   │  Space w      Save buffer                   │',
        \ '   │  Space ls     List all open buffers         │',
        \ '   └─────────────────────────────────────────────┘',
        \ '',
        \ '   ┌─────────────────────────────────────────────┐',
        \ '   │  SPLITS                                     │',
        \ '   ├─────────────────────────────────────────────┤',
        \ '   │  Space s      Horizontal split              │',
        \ '   │  Space v      Vertical split                │',
        \ '   │  Ctrl-h       Move to left split            │',
        \ '   │  Ctrl-j       Move to split below           │',
        \ '   │  Ctrl-k       Move to split above           │',
        \ '   │  Ctrl-l       Move to right split           │',
        \ '   └─────────────────────────────────────────────┘',
        \ '',
        \ '   ┌─────────────────────────────────────────────┐',
        \ '   │  FZF                                        │',
        \ '   ├─────────────────────────────────────────────┤',
        \ '   │  Space f      Find files                    │',
        \ '   │  Space b      Search open buffers           │',
        \ '   │  Space /      Search lines (current buf)    │',
        \ '   │  Space L      Search lines (all bufs)       │',
        \ '   │  Space g      Grep inside files (ripgrep)   │',
        \ '   │  Space r      Recent file history           │',
        \ '   └─────────────────────────────────────────────┘',
        \ '',
        \ '   ┌─────────────────────────────────────────────┐',
        \ '   │  INDENTATION — FreeBSD style(9)             │',
        \ '   ├─────────────────────────────────────────────┤',
        \ '   │  tabstop      8     Hard tab = 8 columns    │',
        \ '   │  shiftwidth   8     Indent = 8 columns      │',
        \ '   │  expandtab    off   Real tabs, not spaces   │',
        \ '   │  cont.        +0.5s 4 spaces for cont.      │',
        \ '   │  textwidth    80    Line wrap at 80 cols    │',
        \ '   └─────────────────────────────────────────────┘',
        \ '',
        \ '   ┌─────────────────────────────────────────────┐',
        \ '   │  USEFUL VIM COMMANDS                        │',
        \ '   ├─────────────────────────────────────────────┤',
        \ '   │  :e file      Open file                     │',
        \ '   │  :e .         Browse directory              │',
        \ '   │  :w           Save                          │',
        \ '   │  :wq          Save and quit                 │',
        \ '   │  :qa          Quit all                      │',
        \ '   │  >>           Indent line                   │',
        \ '   │  <<           Unindent line                 │',
        \ '   │  gg=G         Re-indent entire file         │',
        \ '   │  u            Undo                          │',
        \ '   │  Ctrl-r       Redo                          │',
        \ '   │  /pattern     Search forward                │',
        \ '   │  n / N        Next / prev result            │',
        \ '   │  :noh         Clear search highlight        │',
        \ '   └─────────────────────────────────────────────┘',
        \ '',
        \ '   ┌─────────────────────────────────────────────┐',
        \ '   │  SCROLL THIS POPUP                          │',
        \ '   ├─────────────────────────────────────────────┤',
        \ '   │  j / k        Scroll down / up              │',
        \ '   │  d / u        Half page down / up           │',
        \ '   │  g            Jump to top                   │',
        \ '   │  G            Jump to bottom                │',
        \ '   │  q / Esc      Close                         │',
        \ '   └─────────────────────────────────────────────┘',
        \ '',
        \ ]

    let s:manual_line = 1
    let s:manual_total = len(s:manual_lines)

    let l:popup = popup_create(s:manual_lines, #{
        \ title: ' Manual ',
        \ pos: 'center',
        \ minwidth: 55,
        \ maxwidth: 55,
        \ maxheight: s:manual_height,
        \ border: [1,1,1,1],
        \ borderchars: ['─','│','─','│','╭','╮','╯','╰'],
        \ borderhighlight: ['Title'],
        \ padding: [0,1,0,1],
        \ scrollbar: 1,
        \ firstline: 1,
        \ filter: function('s:ManualFilter'),
        \ highlight: 'Normal',
        \ mapping: 0,
        \ })
endfunction

function! s:ManualScroll(winid, delta)
    let s:manual_line += a:delta
    if s:manual_line < 1
        let s:manual_line = 1
    endif
    let l:max = s:manual_total - s:manual_height + 1
    if l:max < 1
        let l:max = 1
    endif
    if s:manual_line > l:max
        let s:manual_line = l:max
    endif
    call popup_setoptions(a:winid, #{firstline: s:manual_line})
endfunction

function! s:ManualFilter(winid, key)
    if a:key ==# 'q' || a:key ==# "\<Esc>"
        call popup_close(a:winid)
        return 1
    endif
    if a:key ==# 'j' || a:key ==# "\<Down>"
        call s:ManualScroll(a:winid, 1)
        return 1
    endif
    if a:key ==# 'k' || a:key ==# "\<Up>"
        call s:ManualScroll(a:winid, -1)
        return 1
    endif
    if a:key ==# 'd' || a:key ==# "\<C-d>"
        call s:ManualScroll(a:winid, 12)
        return 1
    endif
    if a:key ==# 'u' || a:key ==# "\<C-u>"
        call s:ManualScroll(a:winid, -12)
        return 1
    endif
    if a:key ==# 'g'
        let s:manual_line = 1
        call popup_setoptions(a:winid, #{firstline: 1})
        return 1
    endif
    if a:key ==# 'G'
        let s:manual_line = s:manual_total - s:manual_height + 1
        if s:manual_line < 1
            let s:manual_line = 1
        endif
        call popup_setoptions(a:winid, #{firstline: s:manual_line})
        return 1
    endif
    return 1
endfunction
