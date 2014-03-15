"Todo:
"Actual syntax checking and error highlighting for Python as per work
" machine.
" Snippets from Zope -- test if working on given file
"

set nocompatible
set t_Co=256
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

"Auto installer of plugins
Bundle 'gmarik/vundle'

" Completion support; requires Vim 7.3.584
" Press <TAB> to complete, <C-Space> to semantically complete
" Automatically integrates with Ultisnips
Bundle 'Valloric/YouCompleteMe'             
let g:ycm_complete_in_comments = 1
let g:ycm_use_ultisnips_completer = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_always_populate_location_list = 1
"let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']

" Snippets
Bundle 'vim-scripts/tlib'
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
Bundle 'zedr/zope-snipmate-bundle'
"let g:UltiSnips = {}
let g:UltiSnipsExpandTrigger="<c-j>"    " Compatibility with YouCompleteMe
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
"   let g:UltiSnipsSnippetDirectories=["UltiSnips", "mycoolsnippets"]

" Uber status bar improvement
Bundle 'Lokaltog/powerline'
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

" Syntax checking for Vim
Bundle 'scrooloose/syntastic'
let g:syntastic_aggregate_errors = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_css = ['csslint']
let g:syntastic_html_checkers = ['tidy']
let g:syntastic_javascript_checkers = ['jslint']
let g:syntastic_json_checkers = ['jsonlint']
let g:syntastic_python_checkers = ['py3kwarn', 'pylama']
let g:syntastic_rst_checkers = ['rstcheck']
let g:syntastic_yaml_checkers = ['jsyaml']

" \\ movement to anywhere - w (words), f (chars), j (lines)
Bundle 'Lokaltog/vim-easymotion'

" Git management: Gstatus, Gcommit, Gblame, Gmove, Ggrep, Gbrowse
" Use with -/p for status and patching.
Bundle 'tpope/vim-fugitive'                 

" Insert-mode autocompletion for quotes, parentheses & brackets
Bundle 'Raimondi/delimitMate'

" Intense commenting superpower
Bundle 'scrooloose/nerdcommenter'
let g:NERDCustomDelimiters = {
   \ 'yaml': { 'left': '#' },
   \ 'sls': { 'left': '#' }
   \ }

" File browser and explorer: Nerdtree
Bundle 'scrooloose/nerdtree'

" Auto indent detection
Bundle 'ciaranm/detectindent'

" Colour tool
Bundle 'Rykka/colorv.vim'

" Repeat support for .
Bundle 'tpope/vim-repeat'

" Repeat support for visual selection
Bundle 'vim-scripts/visualrepeat'

" Ability to easily change surrounding elements (eg cs[from][to])
Bundle 'tpope/vim-surround'

" Sets of useful mappings about [ and ]
Bundle 'tpope/vim-unimpaired'

" Alignment for C-style variables, definitions, comments, tables
Bundle 'vim-scripts/Align'


""""""""""""""""""""""""""""""""
" Sytax/filetype support bundles
""""""""""""""""""""""""""""""""
Bundle 'tpope/vim-git'
Bundle 'leshill/vim-json'
Bundle 'pangloss/vim-javascript'
let g:javascript_enable_domhtmlcss = 1
" HAML, LESS, SASS 
Bundle 'tpope/vim-haml'
" YAML
Bundle 'avakhov/vim-yaml'
" reST
Bundle 'Rykka/riv.vim'
let g:riv_python_rst_hl = 1
" Salt SLS
Bundle 'saltstack/salt-vim'
" VimL Checking
Bundle 'ynkdir/vim-vimlparser'
Bundle 'syngan/vim-vimlint'


" Python editng superpowers
" XXX Conflicts with another plugin on completion (Rope?)
" Bundle 'klen/python-mode'


""""""""""""""""""""
"Extra configuration
""""""""""""""""""""
syntax on                         " Syntax highlighting
filetype plugin on                " Filetype detection
filetype plugin indent on         " Indentation
set encoding=utf-8                " Set preferred char encoding
set backspace=indent,eol,start    " Backspace over everything
set formatoptions-=t              " Stop auto wrapping of text
set scrolloff=4                   " Keep x lines above an below the cursor
set autoindent                    " Indenting follows previous line
set smartindent                   " Intelligent identing
set smarttab                      " Tab char at start of line
set expandtab                     " Expand tabs to spaces
set tabstop=4                     " Tabs are this wide
set shiftwidth=4                  " Shifting is this wide
set softtabstop=4                 " Tabs are this wide
set shiftround                    " Round indent to multiples of shiftwidth
set matchpairs+=<:>               " Highlight char pairs
set foldmethod=syntax             " By default, use syntax to determine folds
set foldlevelstart=99             " All folds open by default
set ignorecase                    " Case insensitive searches
set smartcase                     " ...unless Vim thinks otherwise.
set hlsearch                      " Highlight search results
set incsearch                     " Incrementally search for results
set history=100                   " Increased history size
set showfulltag                   " Show tag and tidied search pattern as match 
set showmode                      " Show type of mode being used
set noerrorbells                  " Don't bell or blink
set showcmd                       " Show paritial command at bottom of screen
set shortmess+=a                  " Use short statuses for [+] [RO] [w]  
set ruler                         " Turn line number and column cursor on
set report=0                      " Always report if any lines changed
set laststatus=2                  " Always show status line
set noshowmode                    " Hide the default mode text below statusline
set confirm                       " Save/exit confirmation

" Don't edit these type of files
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.pyo,*.swp

"Optional useful settings
"set number                        " Line numbering


"""""""""""""""""""""""""""""""
"  Colourisation and styling  "
"""""""""""""""""""""""""""""""
highlight Search term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow


""""""""""""""
"  Commands  "
""""""""""""""

" Red-dotted colouring on leading whitespace in Python files (or all files?)
" Continuous syntax checking within Python files

" Clean up trailing whitespace in filecommand! CleanWhitespace %s/\s\+$//e

"""""""""""""
"Key Mappings
"""""""""""""

" Easy out from input mode
inoremap jk <Esc>

" Movement - work more logically with wrapped lines
map j gj
map k gk

" Movement - easily move to start/end of lines
map H ^
map L $

" Visual indenting should stay selected
vmap < <gv
vmap > >gv

" <space> - toggles folds opened and closed
nnoremap <space> za

" <space> - in visual mode creates a fold over the marked range
vnoremap <space> zf

" * and # - Search for selected text when used in visual mode
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR

" Ctrl + Arrows - Move around quickly
nnoremap  <c-up>     {
nnoremap  <c-down>   }
nnoremap  <c-right>  El
nnoremap  <c-left>   Bh

" Shift + Arrows, Shift + movement - Visually Select text
nnoremap  <s-up>     Vk
nnoremap  <s-down>   Vj
nnoremap  <s-right>  vl
nnoremap  <s-left>   vh

" \g - Move to the element/variable declaration
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

" \rt - Convert all tabs in document
map <leader>rt ggVG :retab<CR>

" Control + L - Shortcut for wrapping lines
map <c-l> gq

" Control + E - Replace visual selection
"vnoremap <C-e> "ey:%s/<C-R>e//gc<left><left><left>

" Control + N - file browser
map <C-n> :NERDTreeToggle<CR>

" F2 - Toggle paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" F8 - Toggle spelling
" http://vimdoc.sourceforge.net/htmldoc/spell.html
if v:version >= 700
function! <SID>ToggleSpell()
   if &spell != 1
       setlocal spell spelllang=en_au
   else
       setlocal spell!
   endif
endfunction
nnoremap <silent> <F8> <ESC>:call <SID>ToggleSpell()<CR>
endif

""""""""""""""
" Autocommands
""""""""""""""
"Whenever vimrc is saved, re-source it.
autocmd! bufwritepost .vimrc source %

if has("autocmd")
augroup vimrcEx
au!
    """"""""""""""""""""""""
    "  All types of files  "
    """"""""""""""""""""""""
    " Open file browser if nothing edited
    au vimenter * if !argc() | NERDTree | endif

    " Switch to the directory of the current file, unless it's a help file.
    au BufEnter * if &ft != 'help' | silent! cd %:p:h | endif

    " In all files, try to jump to the last spot cursor was before exiting
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

    " Different types of file support 
    au BufNewFile,BufRead *.htm,*.html set filetype=html.css.javascript
    au FileType html.css.javascript set nocindent autoindent smartindent

    au BufNewFile,BufRead *.css,*.less set filetype=css

    au BufNewFile,BufRead *.sass set filetype=sass
    
    au BufNewFile,BufRead *.rb,*.rbw,*.gem,*.gemspec,[rR]akefile,*.rake,*.thor,Vagrantfile set filetype=ruby
    au BufNewFile,BufRead *.erb set filetype=eruby
    au FileType eruby set nocindent autoindent smartindent
    
    au BufNewFile,BufRead *.js set filetype=javascript
    au FileType javascript set nocindent autoindent smartindent

    au BufNewFile,BufRead *.coffee set filetype=coffee
    au FileType coffee setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with

    au BufNewFile,BufRead *.pt set filetype=html.pt
    au BufNewFile,BufRead *.zcml set filetype=xml.zcml
    au BufNewFile,BufRead *.zpt set filetype=xml.zpt
    "au FileType xml let g:detectindent_preferred_expandtab = 1 | let g:detectindent_preferred_indent = 2

    " Detect indentation of all files
    au BufReadPost * :DetectIndent

    " XXX Unknown consequences here
    " Python-specific filetype customisations
    au FileType python set omnifunc=pythoncomplete#Complete
    au FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
    au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    au FileType python set list listchars=tab:»·,trail:·
    " Fix "smart" indenting of Python comments
    au FileType python inoremap # X<c-h>#
    " For detectindent
    au FileType python let g:detectindent_preferred_expandtab = 1 | let g:detectindent_preferred_indent = 4

    " Omni completion for filetypes
    " Configured by default on Ubuntu installation of Vim
    "au FileType python set omnifunc=pythoncomplete#Complete
    "au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    "au FileType html set omnifunc=htmlcomplete#CompleteTags
    "au FileType css set omnifunc=csscomplete#CompleteCSS
    "au FileType xml set omnifunc=xmlcomplete#CompleteTags
    "au FileType php set omnifunc=phpcomplete#CompletePHP
    "au FileType c set omnifunc=ccomplete#Complete


augroup END
endif
