set nocompatible hidden laststatus=2
set backspace=indent,eol,start
syntax on
filetype plugin indent on
inoremap qq <ESC>
" Map <leader> key to comma
let mapleader = ','
nmap <F3> :set nu! <CR>
nmap <leader><F3> : set rnu! <CR>

nnoremap gjj :tabprevious <CR>
nnoremap gkk :tabnext <CR>
set modelines=0

set wildmenu
:nnoremap <S-Tab> :bprevious<CR>
:nnoremap <Tab> :bnext<CR>

call plug#begin('~/.vim/plugged')

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'

call plug#end()

set cot+=preview

set number                     " Show current line number
set relativenumber             " Show relative line numbers

"let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
"let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'
let $RUST_BACKTRACE = 'full' 
"let g:deoplete#enable_at_startup=1
let g:LanguageClient_autoStart=1
let g:LanguageClient_trace='verbose'

let g:LanguageClient_serverCommands = {
    \ 'cpp': ['/cquery/build/cquery', '--log-file=/tmp/cq.log'], " /m/u-g/A/p
    \ 'c': ['/cquery/build/cquery', '--log-file=/tmp/cq.log'],   " /m/u-g/A/p
    \ }

let g:LanguageClient_rootMarkers = {
\ 'cpp': ['*.cpp', 'build', 'compile_commands.json'],
\ 'c': ['*.c', 'build', 'compile_commands.json'],
\ }

let g:LanguageClient_loadSettings = 1 
let g:LanguageClient_settingsPath = expand('~/fm/settings.json')
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()

nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='papercolor'
let g:airline_powerline_fonts = 1

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_refresh_always = 1

nmap <F8> :TagbarToggle<CR>
" A buffer becomes hidden when it is abandoned
set hid

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 
" Add a bit extra margin to the left
"set foldcolumn=1

" => Moving around, tabs, windows and buffers

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
" map <space> /
" map <c-space> ?

function! ClangCheckImpl(cmd)
  if &autowrite | wall | endif
  echo "Running " . a:cmd . " ..."
  let l:output = system(a:cmd)
  cexpr l:output
  cwindow
  let w:quickfix_title = a:cmd
  if v:shell_error != 0
    cc
  endif
  let g:clang_check_last_cmd = a:cmd
endfunction

function! ClangCheck()
  let l:filename = expand('%')
  if l:filename =~ '\.\(cpp\|cxx\|cc\|c\)$'
    call ClangCheckImpl("clang-check " . l:filename)
  elseif exists("g:clang_check_last_cmd")
    call ClangCheckImpl(g:clang_check_last_cmd)
  else
  endif
endfunction

nmap <silent> <F5> :call ClangCheck()<CR><CR>

autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>

" NERDTree
let NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = '🗀'
let g:NERDTreeDirArrowCollapsible = '🗁'
let g:NERDTreeHighlightFolders = 1
let g:NERDTreeHighlightFoldersFullName = 1

"call deoplete#custom#option('num_processes', 1)

let g:LanguageClient_diagnosticsDisplay = {
    \ 1: {
    \"name": "Error",
    \"texthl": "ALEError",
    \"signText": "E",
    \"signTexthl": "ALEError",
    \},
    \2: {
    \"name": "Warning",
    \"texthl": "ALEWarning",
    \"signText": "W",
    \"signTexthl": "ALEWarning",
    \},
    \3: {
    \"name": "Info",
    \"texthl": "ALEInfo",
    \"signText": "I",
    \"signTexthl": "ALEInfo",
    \},
    \4: {
    \"name": "Hint",
    \"texthl": "ALEHint",
    \"signText": "H",
    \"signTexthl": "ALEHint",
    \},
    \}

set hidden
set noshowmode
set signcolumn=yes
set t_Co=256
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%101v', 100)
