let g:mapleader=";"                          " Change the leader key to something typable

set nocompatible
set t_Co=256
call plug#begin('~/.vim/bundle')

" Enable recursive cloning for YouCompleteMe etc
let g:plug_shallow = 0

" Local vimrc support
Plug 'MarcWeber/vim-addon-local-vimrc'

" EditorConfig file support
Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Library of common functions
Plug 'vim-scripts/ingo-library'

" Command aliasing
Plug 'vim-scripts/cmdalias.vim'

" Allow shell commands to run an interactive environment
Plug 'christoomey/vim-run-interactive'
nnoremap <leader>ri :RunInInteractiveShell<space>

" Sugar for shell commands around files
Plug 'tpope/vim-eunuch'

" Obsession.vim: window positions and current state
Plug 'tpope/vim-obsession'

" Open file:line formatted input
Plug 'bogado/file-line'

" Completion support; requires Vim 7.3.584
" Press <TAB> to complete, <C-Space> to semantically complete
" Automatically integrates with Ultisnips
Plug 'Valloric/YouCompleteMe', { 'do': 'python3 ./install.py --clang-completer --tern-completer' }
let g:ycm_server_python_interpreter = 'python3'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_complete_in_comments = 1
let g:ycm_use_ultisnips_completer = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_server_use_vim_stdout = 0
let g:ycm_server_log_level = 'warn'
let g:ycm_server_keep_logfiles = 1
"let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
"let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']

" JavaScript parsing and integration with YouCompleteMe
"Plug 'marijnh/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
" let g:tern_show_argument_hints = 'on_move'
" Plug 'Slava/tern-meteor', { 'for': 'javascript' }
"Plug 'slava/vim-spacebars'
"let g:mustache_abbreviations = 1

" Snippets
"Plug 'vim-scripts/tlib'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' | Plug 'zedr/zope-snipmate-bundle'
"let g:UltiSnips = {}
let g:UltiSnipsExpandTrigger="<c-x>"    " Compatibility with YouCompleteMe
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
"   let g:UltiSnipsSnippetDirectories=["UltiSnips", "mycoolsnippets"]

" Uber status bar improvement
Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}

" Syntax checking for Vim
Plug 'scrooloose/syntastic'
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_css_checkers = ['csslint']
let g:syntastic_sass_check_partials = 1
let g:syntastic_html_checkers = ['tidy']
let g:syntastic_html_tidy_ignore_errors=[
            \ '<tal:',
            \ '<metal:',
            \ 'proprietary attribute "metal:',
            \ 'proprietary attribute "tal:"',
            \ 'discarding unexpected </tal:',
            \ 'discarding unexpected </metal:'
            \ ]
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_json_checkers = ['jsonlint']
let g:syntastic_python_checkers = ['py3kwarn', 'pylama']
let g:syntastic_rst_checkers = ['rstcheck']
let g:syntastic_rst_rstcheck_quiet_messages = {"regex": [
            \ '\v"(ref|abbr|term|menuselection|ifconfig|glossary)"',
            \ 'Undefined substitution referenced: "project-',
            \ ]}
let g:syntastic_yaml_checkers = ['jsyaml']

" Automatic formatting of code
" You can manually autoindent, retab or remove trailing whitespace with the
" following respective commands:
"
"    gg=G
"    :retab
"    :RemoveTrailingSpaces
Plug 'Chiel92/vim-autoformat'
noremap <leader>p :Autoformat<CR>

" <leader><leader> movement to anywhere - w (words), f (chars), j (lines)
Plug 'Lokaltog/vim-easymotion'

" Git management: Gstatus, Gcommit, Gblame, Gmove, Ggrep, Gbrowse
" Use with -/p for status and patching.
Plug 'tpope/vim-fugitive'

" Search support: Ag
Plug 'rking/ag.vim'

" Insert-mode autocompletion for quotes, parentheses & brackets
Plug 'Raimondi/delimitMate'
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1
let g:delimitMate_jump_expansion = 1

" Coloured matching parentheses
Plug 'junegunn/rainbow_parentheses.vim'

" Intense commenting superpower
Plug 'scrooloose/nerdcommenter'
let g:NERDCustomDelimiters = {
   \ 'python': { 'left': '# ', 'leftAlt': '#' },
   \ }

" Graphical undo tree viewer
Plug 'simnalamburt/vim-mundo'
let g:gundo_right = 1
nnoremap <leader>u :GundoToggle<CR>

" File browser and explorer: Nerdtree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Fuzzy file, buffer, mru, tag, etc finder
Plug 'kien/ctrlp.vim'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ }

" Most recently used file list
Plug 'yegappan/mru'
nnoremap <leader>f :MRU<CR>

" Auto indent detection
Plug 'ciaranm/detectindent'
"let g:detectindent_max_lines_to_analyse = 16
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4

" Indent guides
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']

" Emmet expanders <C-Y>, expansions of HTML, CSS and lots more
Plug 'mattn/emmet-vim'
let g:user_emmet_default_attrs_order = ['class', 'id']

" Browser for tags (classes, functions etc) within source code files
Plug 'jszakmeister/rst2ctags'
Plug 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : '~/.vim/bundle/rst2ctags/rst2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" Tag handling
Plug 'tpope/vim-ragtag'

" Tag movement
Plug 'gcmt/breeze.vim', { 'for': ['*.pt', '*.zpt', 'mako', 'php'] }

" Title case support
Plug 'christoomey/vim-titlecase'

" Colour tool
Plug 'Rykka/colorv.vim', { 'for': ['css', 'sass', 'scss', 'javascript', 'html'] }

" Repeat support for ``.`` (dot, period)
Plug 'tpope/vim-repeat'

" Repeat support for visual selection
Plug 'vim-scripts/visualrepeat'

" Ability to easily change surrounding elements (eg cs[from][to])
Plug 'tpope/vim-surround'
let g:surround_{char2nr('t')} = "``\r``"
let g:surround_{char2nr('e')} = "**\r**"
let g:surround_{char2nr('%')} = "%\r%"

" Sets of useful mappings about [ and ] & toggles for options
" such as cos (spelling) and coh (highlighting)
Plug 'tpope/vim-unimpaired'

" Alignment for C-style variables, definitions, comments, tables
Plug 'vim-scripts/Align'

" Sudo editing support
Plug 'chrisbra/SudoEdit.vim'
let g:sudo_no_gui=1

" Tmux compatibility support
Plug 'christoomey/vim-tmux-navigator'


""""""""""""""""""""""""""""""""
" Sytax/filetype support bundles
""""""""""""""""""""""""""""""""
" Clickable links
Plug 'Rykka/os.vim'
"Plug 'Rykka/clickable.vim'

" Statement or structure end keywords
Plug 'tpope/vim-endwise'

" Git files
Plug 'tpope/vim-git'

" JSON
Plug 'elzr/vim-json'
Plug 'tpope/vim-jdaddy'

" JavaScript
"Plug 'davidjb/vim-web-indent'
Plug 'jelera/vim-javascript-syntax'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
" XXX see https://github.com/othree/javascript-libraries-syntax.vim
Plug 'othree/javascript-libraries-syntax.vim'
let g:javascript_enable_domhtmlcss = 1
Plug 'moll/vim-node'

" CSS
"Plug 'skammer/vim-css-color'
Plug 'hail2u/vim-css3-syntax'

" HTML
Plug 'othree/html5.vim'
let g:html_indent_tags = 'li\|p'

Plug 'rstacruz/sparkup'
let g:sparkupExecuteMapping = '<Leader>h'
let g:sparkupNextMapping = '<Leader>n'
let g:sparkupMapsNormal = 1

" LESS
" Plug 'groenewege/vim-less'

" SASS, SCSS
Plug 'cakebaker/scss-syntax.vim'

" HAML
"Plug 'tpope/vim-haml'

" YAML
Plug 'avakhov/vim-yaml', { 'for': 'yaml' }

" Markdown
Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }

" reST - Highlight DocStrings in Python files
" Improvement for auto-numbered lists
" See https://github.com/Rykka/riv.vim/pull/59
Plug 'Rykka/riv.vim'
let g:riv_python_rst_hl = 1
let g:riv_ignored_vmaps='>,<'

" Salt SLS
Plug 'saltstack/salt-vim'
let g:sls_use_jinja_syntax = 1

" Jinja2
Plug 'Glench/Vim-Jinja2-Syntax'

" VimL Checking
Plug 'ynkdir/vim-vimlparser'
Plug 'syngan/vim-vimlint'

" GPG support
Plug 'jamessan/vim-gnupg'
"let g:GPGDebugLevel = 5
let g:GPGPreferArmor = 1
let g:GPGPreferSign = 1
let g:GPGDefaultRecipients=[
 \"David Beitey (Work) <david" . nr2char(64) . "davidjb" . "." . "com>",
 \]
function! SetGPGOptions()
    setlocal foldlevel=1
    setlocal foldclose=all
    setlocal foldopen=insert
endfunction

" Python editng superpowers
Plug 'klen/python-mode'
let g:pymode_lint_on_write = 0 | let g:pymode_lint_message = 0 | let g:pymode_syntax = 0 | let g:pymode_syntax_all = 0 | let g:pymode_trim_whitespaces = 0
let g:pymode_rope_show_doc_bind = '<c-e>d'
let g:pymode_rope = 0
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_autoimport_import_after_complete = 1

" XXX Conflicts with another plugin on completion (Rope?)
"let g:pymode_rope = 0
"

" Arduino
Plug 'vim-scripts/Arduino-syntax-file'

" Tmux
Plug 'tmux-plugins/vim-tmux'

" PHP
Plug 'StanAngeloff/php.vim'

" All Plug calls must be above here!
call plug#end()


""""""""""""""""""""
"Extra configuration
""""""""""""""""""""
" VVV Experimental
set display+=lastline
set tabpagemax=50
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

" ^^^ Exterimental
set ttimeout                                        " Time out when entering keycodes
set ttimeoutlen=100                                 " Set timeout for keycodes
set wildmode=list:longest,list:full                 " Configure command/filename completion
set wildmenu                                        " Enable command line completion
set autoread                                        " Automatically re-read unchanged files
set fileformats+=mac                                " Enable EOL detection for Mac files
set autoindent                                      " Copy indent to new line
set backspace=indent,eol,start                      " Backspace over everything
set background=light                                " Explicitly set background color
set encoding=utf-8                                  " Set preferred char encoding
set formatoptions-=t                                " Stop auto wrapping of text
set formatoptions+=j                                " Remove comment leaders when joining lines
set nrformats-=octal                                " Avoid numbers with leading zeros
set scrolloff=5                                     " Keep x lines above an below the cursor
set smartindent                                     " Intelligent identing
set smarttab                                        " Tab char at start of line
set expandtab                                       " Expand tabs to spaces
set tabstop=4                                       " Tabs are this wide
set shiftwidth=4                                    " Shifting is this wide
set softtabstop=4                                   " Tabs are this wide
set shiftround                                      " Round indent to multiples of shiftwidth
set matchpairs+=<:>                                 " Highlight char pairs
set foldmethod=syntax                               " By default, use syntax to determine folds
set foldlevelstart=99                               " All folds open by default
set ignorecase                                      " Case insensitive searches
set smartcase                                       " ...unless Vim thinks otherwise.
set hlsearch                                        " Highlight search results
set incsearch                                       " Incrementally search for results
set history=1000                                    " Increased history size
set showfulltag                                     " Show tag and tidied search pattern as match 
set noerrorbells                                    " Don't bell or blink
set splitbelow                                      " New splits open below
set splitright                                      " New splits open to the right
set showcmd                                         " Show paritial command at bottom of screen
set shortmess+=a                                    " Use short statuses for [+] [RO] [w]
set number                                          " Turn line numbering on
set ruler                                           " Turn line number and column cursor on
set report=0                                        " Always report if any lines changed
set laststatus=2                                    " Always show status line
set noshowmode                                      " Hide the default mode text below statusline
set confirm                                         " Save/exit confirmation
set list listchars=tab:»·,trail:·,nbsp:·            " Show hidden characters in files
set mouse=a                                         " Enable mouse support for terminal
set spelllang=en_au                                 " Configure spelling support for AU English
set spellfile=~/dotfiles/vim-spelling.utf-8.add     " Configure permanent spellfile location
set complete+=kspell                                " Autocomplete via dictionary during spellcheck
set undofile                                        " Automatically save persistent undo history
set undodir=~/.vim/undo                             " Configure undo history location
set diffopt+=vertical                               " Show diffs vertically

" Don't edit these type of files
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.pyo,*.swp

" Borrowed from tpope/vim-sensible
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
    set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
endif

" Map escape sequences to their Alt combinations
"for start in ['A', 'a']
    "let c=start
    "while c <= nr2char(25+char2nr(start))
        "exec "set <A-".c.">=\e".c
        "exec "imap \e".c." <A-".c.">"
        "let c=nr2char(1+char2nr(c))
    "endw
"endfor


"""""""""""""""""""""""""""""""
"  Colourisation and styling  "
"""""""""""""""""""""""""""""""
highlight Search term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
highlight SpellBad term=reverse ctermbg=224 ctermfg=0 gui=undercurl guisp=Red
highlight IndentGuidesEven ctermbg=244
highlight IndentGuidesOdd ctermbg=236
highlight MatchParen term=reverse ctermbg=239 guibg=Cyan


""""""""""""""
"  Commands  "
""""""""""""""

" Red-dotted colouring on leading whitespace in Python files (or all files?)
" Continuous syntax checking within Python files

" Clean up trailing whitespace in filecommand! CleanWhitespace %s/\s\+$//e
"

"""""""""""""
"Key Mappings
"""""""""""""

" Breeze support
" XXX Should only be applied to tag-based files
map <leader>te :BreezeMatchTag<CR>
nmap <leader>tf :BreezeJumpF<CR>
nmap <leader>tb :BreezeJumpB<CR>
nmap <leader>tsf :BreezeNextSibling<CR>
nmap <leader>tsb :BreezePrevSibling<CR>
nmap <leader>tp :BreezeParent<CR>
nmap <leader>tw :BreezeWhatsWrong<CR>

" YouCompleteMe support
nmap <leader>jd :YcmCompleter GoTo<CR>
nmap <leader>jf :YcmCompleter GoToDefinition<CR>

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

" m, M - Add new lines without insert mode
nmap <s-m> O<Esc>

" Control + b - Build using Make
nmap <C-b> :make<CR>

" Control + U - Shortcut for unifying (wrapping) lines
nmap <c-u> gqip
vmap <c-u> gq

" Control + N - file browser
map <C-n> :NERDTreeToggle<CR>

" Control + C,V - system clipboard handling
" Pasting enables paste mode, then pastes, placing the cursor after the paste
vmap <c-c> "+y
nmap <c-v> :set paste<CR>"+gp:set nopaste<CR>
"imap <c-v> <esc><c-v>i

" Control + R - visual selection replacement
vnoremap <C-r> "hy:%s/\(<C-r>h\)//gc<left><left><left>

" ;e - Shortcut for syntax checking
map <leader>e :SyntasticCheck<CR>:Errors<CR>

" ;g - Move to the element/variable declaration
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

" ;rc, ;rv - Replace all characters in selection
function! ReplaceOnLine() range
    let replacement = nr2char(getchar())
    execute a:firstline . "," . a:lastline . 's/\S/' . replacement . '/g'
endfunction
noremap <leader>rc :call ReplaceOnLine()<CR>
vnoremap <leader>rv "ey:%s/<C-R>e//gc<left><left><left>

" ;rt - Convert all tabs in document
nnoremap <leader>rt :retab<CR>

" ;d - Detect indent
nnoremap <leader>d :DetectIndent<CR>

" ;v - Open vimrc
nmap <leader>v :tabedit $MYVIMRC<CR>

" F2 - Toggle paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>


""""""""""""""
" Autocommands
""""""""""""""
if has("autocmd")
function! InitPlugins()
    " Command aliases
    " Search with `ag` instead
    call CmdAlias('ag', 'Ag')

    " Remove the autocommand once done
    au! InitPlugins VimEnter
endfunction

augroup InitPlugins
au!
    au VimEnter * :call InitPlugins()
augroup END

augroup vimrcEx
au!
    """"""""""""""""""""""""
    "  All types of files  "
    """"""""""""""""""""""""

    "Whenever vimrc is saved, re-source it.
    au bufwritepost .vimrc,vimrc source $MYVIMRC

    " Open file browser if nothing edited
    "au vimenter * if !argc() | NERDTree | endif

    " Switch to the directory of the current file, unless it's a help file.
    au BufEnter * if &ft != 'help' | silent! cd %:p:h | endif

    " In all files, try to jump to the last spot cursor was before exiting
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

    " Always colourise parentheses
    au FileType * :RainbowParentheses

    " Salt roster files
    au BufNewFile,BufRead roster,master setlocal filetype=yaml

    " Different types of file support
    au FileType json map <leader>p :%!json_xs -f json -t json-pretty<CR>
    au FileType json map <leader>jm :%!json_xs -f json -t json<CR>

    "au BufReadCmd,FileReadCmd *.\(gpg\|asc\|pgp\) call SetGPGOptions()

    " Allow stylesheets to autocomplete hyphenated words
    au FileType css,scss,sass setlocal iskeyword+=-

    " Indent width for HTML/CSS/SASS
    au FileType css,scss,sass,html setlocal shiftwidth=2 tabstop=2 softtabstop=2

    au BufNewFile,BufRead *.rb,*.rbw,*.gem,*.gemspec,[rR]akefile,*.rake,*.thor,Vagrantfile setlocal filetype=ruby
    au BufNewFile,BufRead *.erb setlocal filetype=eruby
    au FileType eruby setlocal nocindent

    au BufNewFile,BufRead *.js setlocal filetype=javascript
    au FileType javascript setlocal nocindent
    au FileType javascript nmap <leader>jd :TernDef<CR>
    au FileType javascript nmap <leader>jt :TernType<CR>
    au FileType javascript nmap <leader>jr :TernRename<CR>

    au BufNewFile,BufRead *.coffee setlocal filetype=coffee
    au FileType coffee setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with

    au BufNewFile,BufRead *.pt setlocal filetype=html.pt
    au BufNewFile,BufRead *.zcml setlocal filetype=xml.zcml
    au BufNewFile,BufRead *.zpt setlocal filetype=xml.zpt
    au FileType html.pt,xml.zpt let g:syntastic_html_tidy_ignore_errors = [
                \ 'discarding unexpected </metal',
                \ 'proprietary attribute "tal:',
                \ 'proprietary attribute "xmlns:',
                \ 'proprietary attribute "metal:',
                \ '<metal:' ]
    "au FileType xml let g:detectindent_preferred_expandtab = 1 | let g:detectindent_preferred_indent = 2
    "au FileType python let g:detectindent_preferred_expandtab = 1 | let g:detectindent_preferred_indent = 4

    " Correctly detect rst files as rst, not vim files
    "au BufRead,BufNewFile *.rst setfiletype rst
    " Handle Control-Enter in rST documents
    au FileType rst inoremap <NL> <esc>:RivListNew<CR>A
    " rst documents - ensure . isn't part of character ranges, remove list leader on join
    au FileType rst setlocal iskeyword-=. textwidth=78 formatoptions-=c

    " Configure automatic spell checking
    au FileType rst,gitcommit setlocal spell

    " Automatic wrapping
    au FileType markdown setlocal textwidth=78 formatoptions-=c

    " Python-specific filetype customisations
    " Fix smart indenting of Python comments
    au FileType python inoremap # X<c-h>#
    " Allow """ comments to work in Python files
    au FileType python let b:delimitMate_nesting_quotes = ['"']
    " Disable <> characters in delimitMate
    au FileType python let b:delimitMate_matchpairs = "(:),[:],{:}"
    " Shortcut for fixing PEP8 issues
    au FileType python nmap <leader>f :PymodeLintAuto<CR>:SyntasticCheck<CR>

    " Arduino filetypes
    au BufNewFile,BufRead *.pde setlocal ft=arduino

    " XXX May want to prefer expandtab for all files
    " Detect indentation of all files
    "au BufReadPost * :DetectIndent

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
