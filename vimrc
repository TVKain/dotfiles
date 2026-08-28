" ===========================
"  Plugins (vim-plug)
" ===========================
" Note: vim-plug needs to be installed first:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-which-key'

" C Intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Catppuccin theme
Plug 'catppuccin/vim', {'as': 'catppuccin'}

call plug#end()

" ===========================
"  Catppuccin Theme Configuration
" ===========================
" Load theme if plugin is installed
if filereadable(expand('~/.vim/plugged/catppuccin/colors/catppuccin_mocha.vim'))
    syntax enable
    set background=dark
    colorscheme catppuccin_mocha
endif

" ===========================
"  Basic Settings
" ===========================
set nocompatible
set number
set relativenumber
set showcmd
set showmatch
set hidden

" Fix vim screen clearing in tmux
if &term =~ 'tmux'
    set t_ut=y
endif

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
"  Clang-format (BSD style)
" ===========================
" Custom function to format C files using clang-format directly
function! ClangFormatBuffer()
    let l:save = winsaveview()
    let l:style = '{BasedOnStyle: LLVM, IndentWidth: 8, TabWidth: 8, UseTab: Always, ColumnLimit: 80, BreakBeforeBraces: Allman}'
    silent! execute '%!clang-format -style=' . shellescape(l:style)
    call winrestview(l:save)
endfunction

" Format on save for C files
augroup clang_format_custom
    autocmd!
    autocmd BufWritePre *.c,*.h,*.cpp,*.hpp call ClangFormatBuffer()
augroup END

" Keybinding for manual format
nnoremap <leader>F :call ClangFormatBuffer()<CR>
vnoremap <leader>F :call ClangFormatBuffer()<CR>

" ===========================
"  CoC (Conquer of Completion)
" ===========================
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" CoC highlight groups for better visibility with catppuccin mocha theme
highlight! link CocMenuSel PmenuSel
highlight! link CocPumSearch DiagnosticInfo
highlight! link CocPumDetail DiagnosticHint
highlight! link CocPumDocumentation Comment

" Custom CoC popup colors for better visibility with mocha theme
highlight CocFloating ctermbg=236 ctermfg=15 guibg=#1e1e2e guifg=#cdd6f4
highlight CocMenuSel ctermbg=61 ctermfg=15 guibg=#89b4fa guifg=#1e1e2e
highlight CocPumVirtualText ctermbg=236 ctermfg=8 guibg=#1e1e2e guifg=#6c7086

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ <SID>check_coc() ? coc#refresh() : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use Ctrl+T to insert literal tab when needed
inoremap <C-T> <TAB>

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:check_coc() abort
  try
    return exists('*coc#refresh') && coc#rpc#ready()
  catch
    return 0
  endtry
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin.
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
augroup coc_highlight
    autocmd!
    autocmd CursorHold * if exists('*coc#rpc#ready') && coc#rpc#ready() | silent call CocActionAsync('highlight') | endif
augroup END

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')

" ===========================
"  CoC Extensions Configuration
" ===========================
" CoC extensions should be installed manually when needed:
" :CocInstall coc-clangd coc-json coc-yaml coc-markdownlint

" ===========================
"  Enhanced CoC Features
" ===========================
" Enable document symbols for better code understanding
nnoremap <silent> <leader>o  :<C-u>CocList outline<cr>

" Enable workspace symbols for codebase analysis
nnoremap <silent> <leader>ss  :<C-u>CocList -I symbols<cr>

" Enable references for code graph analysis
nnoremap <silent> <leader>gr  :<C-u>CocList references<cr>

" Enable call hierarchy for function call analysis
nnoremap <silent> <leader>ch  :<C-u>CocList calls<cr>

" Enable code actions for quick fixes
nnoremap <silent> <leader>ca  :<C-u>CocList actions<cr>

" Enable diagnostics for error analysis
nnoremap <silent> <leader>di  :<C-u>CocList diagnostics<cr>

" Enable workspace diagnostics for codebase-wide issues
nnoremap <silent> <leader>wd  :<C-u>CocList workspaceDiagnostics<cr>

" Mappings for CoCList
" Show all diagnostics (mapped to <leader>di above)
" nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>ss  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>

" ===========================
"  Display
" ===========================
filetype plugin indent on
set encoding=utf-8
set backspace=indent,eol,start
set textwidth=80

" Bracket pair highlighting for better visibility with catppuccin mocha
highlight MatchParen cterm=bold ctermfg=15 ctermbg=238 gui=bold guifg=#cdd6f4 guibg=#45475a

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
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
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

" Leaf markdown preview
nnoremap <leader>md :vertical botright terminal leaf -w %<CR>

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
        \ '   │  Space bn     Next buffer                   │',
        \ '   │  Space bp     Previous buffer               │',
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
        \ '   │  C INTELLISENSE & FORMATTING                │',
        \ '   ├─────────────────────────────────────────────┤',
        \ '   │  Space F      Format C file (BSD style)     │',
        \ '   │  Space cf     Format selected (CoC)         │',
        \ '   │  gd           Go to definition              │',
        \ '   │  gr           Go to references              │',
        \ '   │  gi           Go to implementation          │',
        \ '   │  gy           Go to type definition         │',
        \ '   │  K            Show documentation            │',
        \ '   │  Space rn     Rename symbol                 │',
        \ '   │  [g / ]g      Prev/Next diagnostic          │',
        \ '   │  Tab          Navigate completion menu      │',
        \ '   │  Ctrl+T       Insert literal tab            │',
        \ '   │  Space o      Show outline                  │',
        \ '   │  Space ss     Search symbols                │',
        \ '   │  Space gr     Search references             │',
        \ '   │  Space ch     Show call hierarchy           │',
        \ '   │  Space ca     Show code actions             │',
        \ '   │  Space di     Show diagnostics              │',
        \ '   │  Space wd     Workspace diagnostics         │',
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
