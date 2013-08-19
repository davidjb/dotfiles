"Todo:
"<c-P> seems to supertab menu
"<tab> does ultisnips; check if vim-snippets are responsible for 
"  Python def and class extensions
"Someone opens a Scratch pad window
"Ultisnips and supertab have failed
"Actual syntax checking and error highlighting for Python as per work
" machine.
"Powerline isn't working. Does it need to be installed?
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'

"Git management
Bundle 'tpope/vim-fugitive' 

" // movement to anywhere - w (words), f (chars)
Bundle 'Lokaltog/vim-easymotion'

" Tab completion menu
" XXX Not working atm
Bundle 'ervandew/supertab'

" Snippets
Bundle 'MarcWeber/ultisnips'
Bundle 'honza/vim-snippets'

"let g:UltiSnips = {}


" Status bar improvement
Bundle 'Lokaltog/powerline'
"set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

" Python syntax highlighting
Bundle 'hdima/python-syntax'
let python_highlight_all=1
"Bundle 'klen/python-mode'


""""""""""""""""""""
"Extra configuration
""""""""""""""""""""

syntax on                         " Syntax highlighting
filetype on                       " Filetype detection
filetype plugin indent on         " Indentation
set number                        " Line numbering
set autoindent                    " Indenting follows previous line
set smartindent                   " Intelligent identing 
set smarttab                      " Tab char at start of line
set tabstop=4                     " Tabs are this wide
set shiftwidth=4                  " Shifting is this wide
set softtabstop=4                 " Tabs are this wide
set expandtab                     " Expand tabs to spaces
set shiftround                    " Round indent to multiples of shiftwidth
set matchpairs+=<:>               " Highlight char pairs
set noerrorbells                  " Don't bell or blink
set laststatus=2                  " Always show status line
set showcmd                       " Save/exit confirmation
set ignorecase                    " Case insensitive searches
set smartcase                     " ...unless Vim thinks otherwise.
set hlsearch                      " Highlight search results
set incsearch                     " Incrementally search for results

""""""""""""""""""""""""
"Filetype customisations
""""""""""""""""""""""""

" Python
"au FileType python set omnifunc=pythoncomplete#Complete
"au FileType python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
"au FileType coffee setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
"au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
"inoremap # #

"""""""""
"Mappings
"""""""""

"Window movement: avoid needing c-w first
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

