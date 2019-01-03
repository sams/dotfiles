" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

syntax on

" Change mapleader
let mapleader=","
let maplocalleader="\\"

" Editing behaviour {{{
set showmode                    " always show what mode we're currently editing in
set nowrap                      " don't wrap lines
set tabstop=4                   " a tab is four spaces
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab                   " expand tabs by default (overloadable per file type later)
set shiftwidth=4                " number of spaces to use for autoindenting
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indentation on autoindenting
set number                      " always show line numbers
set showmatch                   " set show matching parenthesis
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
                                "    case-sensitive otherwise
set smarttab                    " insert tabs on the start of a line according to
                                "    shiftwidth, not tabstop
set scrolloff=4                 " keep 4 lines off the edges of the screen when scrolling
set virtualedit=all             " allow the cursor to go in to "invalid" places
set hlsearch                    " highlight search terms
set incsearch                   " show search matches as you type
set gdefault                    " search/replace "globally" (on a line) by default
set listchars=tab:▸\ ,trail:·,extends:#,nbsp:·

set nolist                      " don't show invisible characters by default,
                                " but it is enabled for some file types (see later)
set pastetoggle=<F2>            " when in insert mode, press <F2> to go to
                                "    paste mode, where you can paste mass data
                                "    that won't be autoindented
set mouse=a                     " enable using the mouse if terminal emulator
                                "    supports it (xterm does)
set fileformats="unix,dos,mac"
set formatoptions+=1            " When wrapping paragraphs, don't end lines
                                "    with 1-letter words (looks stupid)

set nrformats=                  " make <C-a> and <C-x> play well with
                                "    zero-padded numbers (i.e. don't consider
                                "    them octal or hex)

set shortmess+=I                " hide the launch screen
set clipboard=unnamed           " normal OS clipboard interaction
set autoread                    " automatically reload files changed outside of Vim

set updatetime=1000             " Speed up the updatetime so gitgutter and friends are quicker

function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
    return line . ' …' . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction
set foldtext=MyFoldText()


" Start Nvie Code :: Sort through }}}
" Mappings to easily toggle fold levels
nnoremap z0 :set foldlevel=0<cr>
nnoremap z1 :set foldlevel=1<cr>
nnoremap z2 :set foldlevel=2<cr>
nnoremap z3 :set foldlevel=3<cr>
nnoremap z4 :set foldlevel=4<cr>
nnoremap z5 :set foldlevel=5<cr>
" }}}

" Editor layout {{{
set termencoding=utf-8
set encoding=utf-8
set lazyredraw                  " don't update the display while executing macros
set laststatus=2                " tell VIM to always put a status line in, even
                                "    if there is only one window
set cmdheight=2                 " use a status bar that is 2 rows high
" }}}

" Vim behaviour {{{
set hidden                      " hide buffers instead of closing them this
                                "    means that the current buffer can be put
                                "    to background without being written; and
                                "    that marks and undo history are preserved
set switchbuf=useopen           " reveal already opened files from the
                                " quickfix window instead of opening new
                                " buffers
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
if v:version >= 730
    set undofile                " keep a persistent backup file
    set undodir=~/.vim/.undo,~/tmp,/tmp
endif
set nobackup                    " do not keep backup files, it's 70's style cluttering
set noswapfile                  " do not write annoying intermediate swap files,
                                "    who did ever restore from swap files anyway?
set directory=~/.vim/.tmp,~/tmp,/tmp
                                " store swap files in one of these directories
                                "    (in case swapfile is ever turned on)
set viminfo='20,\"80            " read/write a .viminfo file, don't store more
                                "    than 80 lines of registers
set wildmenu                    " make tab completion for files/buffers act like bash
set wildmode=list:full          " show a list when pressing tab and complete
                                "    first full match
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                       " change the terminal's title
set visualbell                  " don't beep
set noerrorbells                " don't beep
set showcmd                     " show (partial) command in the last line of the screen
                                "    this also shows visual selection info
set nomodeline                  " disable mode lines (security measure)
"set ttyfast                     " always use a fast terminal
set nocursorline                " don't highlight the current line (useful for quick orientation, but also slow to redraw)
" }}}

nnoremap <leader>, :set cursorline!<cr>  " toggle highlighting the cursor line

" Toggle the quickfix window {{{
" From Steve Losh, http://learnvimscriptthehardway.stevelosh.com/chapters/38.html
nnoremap <C-q> :call <SID>QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! s:QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction
" }}}

" Toggle the foldcolumn {{{
nnoremap <leader>f :call FoldColumnToggle()<cr>

let g:last_fold_column_width = 4  " Pick a sane default for the foldcolumn

function! FoldColumnToggle()
    if &foldcolumn
        let g:last_fold_column_width = &foldcolumn
        setlocal foldcolumn=0
    else
        let &l:foldcolumn = g:last_fold_column_width
    endif
endfunction
" }}}

" Highlighting {{{

if (has("termguicolors"))
   set termguicolors
endif

if &t_Co > 2 || has("gui_running")
   syntax on                    " switch syntax highlighting on, when the terminal has colors
endif

" }}}

" Shortcut mappings {{{
" Since I never use the ; key anyway, this is a real optimization for almost
" all Vim commands, as I don't have to press the Shift key to form chords to
" enter ex mode.
nnoremap ; :
nnoremap <leader>; ;

" Avoid accidental hits of <F1> while aiming for <Esc>
noremap! <F1> <Esc>

nnoremap <leader>Q :q<CR>    " Quickly close the current window
nnoremap <leader>q :bd<CR>   " Quickly close the current buffer

" Use Q for formatting the current paragraph (or visual selection)
" This used to be `gq` and `gqap`, but the "w" variant is the same, but puts
" the cursor back at the original position after performing the
" transformation. See https://github.com/nvie/vimrc/issues/16
vnoremap Q gw
nnoremap Q gwap
" set breakindent on  " keep paragraph indentation when re-wrapping text

" Sort paragraphs
vnoremap <leader>s !sort -f<CR>gv
nnoremap <leader>s vip!sort -f<CR><Esc>

" make p in Visual mode replace the selected text with the yank register
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Shortcut to make
nnoremap mk :make<CR>

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '

" Use the damn hjkl keys
" noremap <up> <nop>
" noremap <down> <nop>
" noremap <left> <nop>
" noremap <right> <nop>

" Remap j and k to act as expected when used on long, wrapped, lines
nnoremap j gj
nnoremap k gk

" Easy window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
" nnoremap <leader>w <C-w>v<C-w>l

" Complete whole filenames/lines with a quicker shortcut key in insert mode
inoremap <C-f> <C-x><C-f>
inoremap <C-l> <C-x><C-l>

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
nnoremap <silent> <leader>d "_d
vnoremap <silent> <leader>d "_d
" vnoremap <silent> x "_x  TODODODOOo

" Quick yanking to the end of the line
nnoremap Y y$

" YankRing stuff
"let g:yankring_history_dir = '$HOME/.vim/.tmp'
"nnoremap <leader>r :YRShow<CR>

" Edit the vimrc file
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

" Clears the search register
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Pull word under cursor into LHS of a substitute (for quick search and
" replace)
nnoremap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

" Keep search matches in the middle of the window and pulse the line when moving
" to them.
nnoremap n n:call PulseCursorLine()<cr>
nnoremap N N:call PulseCursorLine()<cr>

" Quickly get out of insert mode without your fingers having to leave the
" home row (either use 'jj' or 'jk')
inoremap jj <Esc>

" Quick alignment of text
" nnoremap <leader>al :left<CR>
" nnoremap <leader>ar :right<CR>
" nnoremap <leader>ac :center<CR>

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Ctrl+W to redraw the buffer's contents
"
" For some reason unclear to me, new files opened via the quickfix window
" (for example Flow errors triggered in unopened files) don't get
" their file types detected automatically.  For these new buffers, the
" filetype= (empty).
"
" This can be fixed by running
"
"     :filetype detect
"
" In those buffers, but this is super laborious.  This just plugs that
" under my existing "refresh the screen" shortcut <c-w>.
nnoremap <C-w> :filetype detect<cr>:redraw!<cr>

" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" Folding
nnoremap <Space> za
vnoremap <Space> za

" Strip all trailing whitespace from a file, using ,W
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Use The Silver Searcher over grep, iff possible
if executable('ag')
   " Use ag over grep
   set grepprg=ag\ --nogroup\ --nocolor
endif

" grep/Ack/Ag for the word under cursor
" vnoremap <leader>a y:grep! "\b<c-r>"\b"<cr>:cw<cr>
" nnoremap <leader>a :grep! "\b<c-r><c-w>\b"
vnoremap <leader>a y:Ag <c-r><cr>:cw<cr>
nnoremap <leader>a :Ag <c-r><c-w>
nnoremap K *N:grep! "\b<c-r><c-w>\b"<cr>:cw<cr>

" Allow quick additions to the spelling dict
nnoremap <leader>g :spellgood <c-r><c-w>

" Define "Ag" command
command -nargs=+ -complete=file -bar Ag silent! grep! <args> | cwindow | redraw!

" bind \ (backward slash) to grep shortcut
nnoremap \ :Ag<SPACE>

" Creating folds for tags in HTML
"nnoremap <leader>ft Vatzf

" Reselect text that was just pasted with ,v
nnoremap <leader>v V`]
" }}}

" NERDTree settings {{{
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <leader>m :NERDTreeClose<CR>:NERDTreeFind<CR>
nnoremap <leader>N :NERDTreeClose<CR>

" Store the bookmarks file
let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

" Show hidden files, too
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1

" Quit on opening files from the tree
let NERDTreeQuitOnOpen=1

" Highlight the selected entry in the tree
let NERDTreeHighlightCursorline=1

" Use a single click to fold/unfold directories and a double click to open
" files
let NERDTreeMouseMode=2

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
            \ '\.o$', '\.so$', '\.egg$', '^\.git$', '__pycache__', '\.DS_Store' ]

" }}}

" vim-sort-imports config (import-sort fixer) {{{

" TODO: Ideally, this command would be run as an ALE fixer, so we can get rid
" of the vim-sort-imports plugin.
let g:import_sort_auto = 1

" }}}

" vim-flake8 default configuration
let g:flake8_show_in_gutter=1

" Conflict markers {{{
" highlight conflict markers
match ErrorMsg '\v^[<\|=|>]{7}([^=].+)?$'

" shortcut to jump to next conflict marker
nnoremap <silent> <leader>c /\v^[<\|=>]{7}([^=].+)?$<CR>
" }}}

" Filetype specific handling {{{
" only do this part when compiled with support for autocommands
if has("autocmd")
    augroup invisible_chars "{{{
        au!

        " Show invisible characters in all of these files
        autocmd filetype vim setlocal list
        autocmd filetype python,rst setlocal list
        autocmd filetype ruby setlocal list
        autocmd filetype javascript,css setlocal list
    augroup end "}}}

    augroup vim_files "{{{
        au!

        " Bind <F1> to show the keyword under cursor
        " general help can still be entered manually, with :h
        autocmd filetype vim noremap <buffer> <F1> <Esc>:help <C-r><C-w><CR>
        autocmd filetype vim noremap! <buffer> <F1> <Esc>:help <C-r><C-w><CR>
    augroup end "}}}

    augroup html_files "{{{
        au!

        " This function detects, based on HTML content, whether this is a
        " Django template, or a plain HTML file, and sets filetype accordingly
        fun! s:DetectHTMLVariant()
            let n = 1
            while n < 50 && n < line("$")
                " check for django
                if getline(n) =~ '{%\s*\(extends\|load\|block\|if\|for\|include\|trans\)\>'
                    set ft=htmldjango.html
                    return
                endif
                let n = n + 1
            endwhile
            " go with html
            set ft=html
        endfun

        " Auto-tidy selection
        vnoremap <leader>x :!tidy -q -i --show-errors 0 --show-body-only 1 --wrap 0<cr><cr>

        autocmd BufNewFile,BufRead *.html,*.htm,*.j2 call s:DetectHTMLVariant()
    augroup end " }}}

    augroup python_files "{{{
        au!

        " This function detects, based on Python content, whether this is a
        " Django file, which may enabling snippet completion for it
        fun! s:DetectPythonVariant()
            let n = 1
            while n < 50 && n < line("$")
                " check for django
                if getline(n) =~ 'import\s\+\<django\>' || getline(n) =~ 'from\s\+\<django\>\s\+import'
                    set ft=python.django
                    "set syntax=python
                    return
                endif
                let n = n + 1
            endwhile
            " go with html
            set ft=python
        endfun
        autocmd BufNewFile,BufRead *.py call s:DetectPythonVariant()

        " PEP8 compliance (set 1 tab = 4 chars explicitly, even if set
        " earlier, as it is important)
        autocmd filetype python setlocal textwidth=78
        autocmd filetype python match ErrorMsg '\%>120v.\+'

        " But disable autowrapping as it is super annoying
        autocmd filetype python setlocal formatoptions-=t

        " Folding for Python (uses syntax/python.vim for fold definitions)
        "autocmd filetype python,rst setlocal nofoldenable
        "autocmd filetype python setlocal foldmethod=expr

        " Python runners
        autocmd filetype python noremap <buffer> <F5> :w<CR>:!python %<CR>
        autocmd filetype python inoremap <buffer> <F5> <Esc>:w<CR>:!python %<CR>
        autocmd filetype python noremap <buffer> <S-F5> :w<CR>:!ipython %<CR>
        autocmd filetype python inoremap <buffer> <S-F5> <Esc>:w<CR>:!ipython %<CR>

        " Automatic insertion of breakpoints
        autocmd filetype python nnoremap <buffer> <leader>bp :normal oimport pdb; pdb.set_trace()  # TODO: BREAKPOINT  # noqa<Esc>

        " Toggling True/False
        autocmd filetype python nnoremap <silent> <C-t> mmviw:s/True\\|False/\={'True':'False','False':'True'}[submatch(0)]/<CR>`m:nohlsearch<CR>

        " Run a quick static syntax check every time we save a Python file
        autocmd BufWritePost *.py call Flake8()

        " Defer to isort for sorting Python imports (instead of using Unix sort)
        autocmd filetype python nnoremap <leader>s mX:%!isort -<cr>`X:redraw!<cr>
    augroup end " }}}

    augroup js_files "{{{
        au!

        autocmd filetype javascript setlocal foldmethod=syntax

        " Defer to import-sort for sorting JavaScript imports (instead of using Unix sort)
        " autocmd filetype javascript nnoremap <leader>s :StopAutoSortImport<cr>:w<cr>:SortImport<cr>:StartAutoSortImport<cr>
        autocmd filetype javascript nnoremap <leader>s :write<cr>

    augroup end " }}}

    augroup clojure_files "{{{
        au!

        " Set up <leader>r to run the entire file with vim-fireplace
        autocmd filetype clojure nnoremap <leader>r :%Eval<cr>
        autocmd filetype clojure RainbowParenthesesActivate
        autocmd filetype clojure RainbowParenthesesLoadRound
        autocmd filetype clojure RainbowParenthesesLoadSquare
        autocmd filetype clojure RainbowParenthesesLoadBraces
    augroup end " }}}

    augroup supervisord_files "{{{
        au!

        autocmd BufNewFile,BufRead supervisord.conf set ft=dosini
    augroup end " }}}

    augroup markdown_files "{{{
        au!

        autocmd filetype markdown noremap <buffer> <leader>p :w<CR>:!open -a 'Marked 2' %<CR><CR>
    augroup end " }}}

    augroup ruby_files "{{{
        au!

    augroup end " }}}

    augroup rst_files "{{{
        au!

        " Auto-wrap text around 74 chars
        autocmd filetype rst setlocal textwidth=74
        autocmd filetype rst setlocal formatoptions+=nqt
        autocmd filetype rst match ErrorMsg '\%>74v.\+'
    augroup end " }}}

    augroup css_files "{{{
        au!

        autocmd filetype css,less setlocal foldmethod=marker foldmarker={,}
    augroup end "}}}

    augroup javascript_files "{{{
        au!

        autocmd filetype javascript setlocal expandtab
        autocmd filetype javascript setlocal listchars=trail:·,extends:#,nbsp:·
        autocmd filetype javascript setlocal foldmethod=marker foldmarker={,}

        " Toggling True/False
        autocmd filetype javascript nnoremap <silent> <C-t> mmviw:s/true\\|false/\={'true':'false','false':'true'}[submatch(0)]/<CR>`m:nohlsearch<CR>

        " Enable insertion of "debugger" statement in JS files
        autocmd filetype javascript nnoremap <leader>b Odebugger;<esc>

    augroup end "}}}

    augroup textile_files "{{{
        au!

        autocmd filetype textile set tw=78 wrap

        " Render YAML front matter inside Textile documents as comments
        autocmd filetype textile syntax region frontmatter start=/\%^---$/ end=/^---$/
        autocmd filetype textile highlight link frontmatter Comment
    augroup end "}}}

    augroup git_files "{{{
        au!

        " Don't remember the last cursor position when editing commit
        " messages, always start on line 1
        autocmd filetype gitcommit call setpos('.', [0, 1, 1, 0])
    augroup end "}}}
endif
" }}}

" Restore cursor position upon reopening files {{{
autocmd BufReadPost *
    \ if &filetype != "gitcommit" && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
" }}}

" Common abbreviations / misspellings {{{
"source ~/.vim/autocorrect.vim
" }}}

" Extra vi-compatibility {{{
" set extra vi-compatible options
set cpoptions+=$     " when changing a line, don't redisplay, but put a '$' at
                     " the end during the change
set formatoptions-=o " don't start new lines w/ comment leader on pressing 'o'
au filetype vim set formatoptions-=o
                     " somehow, during vim filetype detection, this gets set
                     " for vim files, so explicitly unset it again
au filetype crontab setlocal backupcopy=yes
                     " editing crontab files needs to happen in-place
" }}}

" Creating underline/overline headings for markup languages
" Inspired by http://sphinx.pocoo.org/rest.html#sections
nnoremap <leader>1 yyPVr=jyypVr=
nnoremap <leader>2 yyPVr*jyypVr*
nnoremap <leader>3 yypVr=
nnoremap <leader>4 yypVr-
nnoremap <leader>5 yypVr^
nnoremap <leader>6 yypVr"

iab lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit
iab llorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.  Etiam lacus ligula, accumsan id imperdiet rhoncus, dapibus vitae arcu.  Nulla non quam erat, luctus consequat nisi
iab lllorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.  Etiam lacus ligula, accumsan id imperdiet rhoncus, dapibus vitae arcu.  Nulla non quam erat, luctus consequat nisi.  Integer hendrerit lacus sagittis erat fermentum tincidunt.  Cras vel dui neque.  In sagittis commodo luctus.  Mauris non metus dolor, ut suscipit dui.  Aliquam mauris lacus, laoreet et consequat quis, bibendum id ipsum.  Donec gravida, diam id imperdiet cursus, nunc nisl bibendum sapien, eget tempor neque elit in tortor

" Smart-quote a paragraph
vnoremap ' :s/'/’/<cr>

"set guifont=Anonymous\ for\ Powerline:h12 linespace=2
"set guifont=Droid\ Sans\ Mono:h14 linespace=0
"set guifont=Mensch\ for\ Powerline:h14 linespace=0
"set guifont=saxMono:h14 linespace=3
"set guifont=Ubuntu\ Mono:h18 linespace=3
set guifont=Source\ Code\ Pro\ Light:h10 linespace=0

if has("gui_running")
    " Remove toolbar, left scrollbar and right scrollbar
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
    set guifont=Source\ Code\ Pro\ Light:h13 linespace=0
else
    set bg=dark
endif

"colorscheme onedark

" Pulse ------------------------------------------------------------------- {{{

function! PulseCursorLine()
    setlocal cursorline

    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    hi CursorLine guibg=#3a3a3a
    redraw
    sleep 14m

    hi CursorLine guibg=#4a4a4a
    redraw
    sleep 10m

    hi CursorLine guibg=#3a3a3a
    redraw
    sleep 14m

    hi CursorLine guibg=#2a2a2a
    redraw
    sleep 10m

    execute 'hi ' . old_hi
    setlocal nocursorline
endfunction

" }}}

" Powerline configuration ------------------------------------------------- {{{

let g:Powerline_symbols = 'compatible'
"let g:Powerline_symbols = 'fancy'

" }}}

" Python mode configuration ----------------------------------------------- {{{

" Don't run pylint on every save
let g:pymode = 1
let g:pymode_breakpoint = 0
let g:pymode_breakpoint_bind = '<leader>b'
let g:pymode_doc = 0
let g:pymode_doc_bind = 'K'
let g:pymode_folding = 0
let g:pymode_indent = 0
let g:pymode_lint = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
let g:pymode_lint_cwindow = 1
let g:pymode_lint_ignore = ''
let g:pymode_lint_message = 1
let g:pymode_lint_on_fly = 0
let g:pymode_lint_on_write = 0
let g:pymode_lint_select = ''
let g:pymode_lint_signs = 1
let g:pymode_motion = 0
let g:pymode_options = 0
let g:pymode_paths = []
let g:pymode_quickfix_maxheight = 6
let g:pymode_quickfix_minheight = 3
let g:pymode_rope = 1
let g:pymode_rope_completion = 0
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_run = 0
let g:pymode_run_bind = '<leader>r'
let g:pymode_trim_whitespaces = 0

" }}}

" JavaScript configuration ------------------------------------------------ {{{

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" }}}

" fzf config -------------------------------------------------------------- {{{

" Invoke fzf, but CommandT style
nnoremap <leader>t :Files<cr>
nnoremap <leader>. :Tags<cr>
nnoremap <leader>b :Buffers<cr>

" ------------------------------------------------------------------------- }}}

" Learn Vim Script the Hard Way Exercises
"noremap - ddp
"noremap _ ddkP

" C-U in insert/normal mode, to uppercase the word under cursor
inoremap <c-u> <esc>viwUea
nnoremap <c-u> viwUe

" Quote words under cursor
nnoremap <leader>" viW<esc>a"<esc>gvo<esc>i"<esc>gvo<esc>3l
nnoremap <leader>' viW<esc>a'<esc>gvo<esc>i'<esc>gvo<esc>3l

" Quote current selection
" TODO: This only works for selections that are created "forwardly"
vnoremap <leader>" <esc>a"<esc>gvo<esc>i"<esc>gvo<esc>ll
vnoremap <leader>' <esc>a'<esc>gvo<esc>i'<esc>gvo<esc>ll

" Use shift-H and shift-L for move to beginning/end
nnoremap H 0
nnoremap L $

" Define operator-pending mappings to quickly apply commands to function names
" and/or parameter lists in the current line
onoremap inf :<c-u>normal! 0f(hviw<cr>
onoremap anf :<c-u>normal! 0f(hvaw<cr>
onoremap in( :<c-u>normal! 0f(vi(<cr>
onoremap an( :<c-u>normal! 0f(va(<cr>

" "Next" tag
onoremap int :<c-u>normal! 0f<vit<cr>
onoremap ant :<c-u>normal! 0f<vat<cr>

" Function argument selection (change "around argument", change "inside argument")
onoremap ia :<c-u>execute "normal! ?[,(]\rwv/[),]\rh"<cr>
vnoremap ia :<c-u>execute "normal! ?[,(]\rwv/[),]\rh"<cr>

" Split previously opened file ('#') in a split window
nnoremap <leader>sh :execute "leftabove vsplit" bufname('#')<cr>
nnoremap <leader>sl :execute "rightbelow vsplit" bufname('#')<cr>

" Grep searches
"nnoremap <leader>g :silent execute "grep! -R " . shellescape('<cword>') . " ."<cr>:copen 12<cr>
"nnoremap <leader>G :silent execute "grep! -R " . shellescape('<cWORD>') . " ."<cr>:copen 12<cr>

" Rope config
nnoremap <leader>A :RopeAutoImport<cr>

" Switch from block-cursor to vertical-line-cursor when going into/out of
" insert mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Configure vim-expand-region, for easy selection precision {{{

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

let g:expand_region_text_objects = {
   \ 'iw'  : 0,
   \ 'i"'  : 1,
   \ 'i''' : 1,
   \ 'a"'  : 0,
   \ 'a''' : 0,
   \ 'i)'  : 1,
   \ 'i}'  : 1,
   \ 'i]'  : 1,
   \ 'a)'  : 1,
   \ 'a}'  : 1,
   \ 'a]'  : 1,
   \ }

" }}}

" Configure ArgWrap
let g:argwrap_tail_comma = 1
nnoremap <leader>w :ArgWrap<cr>

" ALE config {{{

" let g:ale_enabled = 1
let g:ale_completion_enabled = 0
let g:ale_lint_delay = 200   " millisecs
" let g:ale_lint_on_text_changed = 'always'  " never/insert/normal/always
let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
" let g:ale_open_list = 1

" TODO: Temporary hack until our eslint is configured correctly
let g:ale_javascript_eslint_options = '--rulesdir eslint'

let g:ale_linters = {
\   'javascript.jsx': ['eslint', 'flow'],
\   'javascript': ['eslint', 'flow'],
\}
let g:ale_fixers = {
\   'javascript.jsx': ['eslint', 'prettier'],
\   'javascript': ['eslint', 'prettier'],
\}

" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)

" }}}

" {{{ Check JS with Flow

" Uncomment this if it gets annoying
" let g:asyncomplete_auto_popup = 0
" let g:asyncomplete_remove_duplicates = 1

" Tab completion for vim-lsp
" inoremap <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <tab> <c-n>
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<cr>"
set completeopt=menu,longest,preview

" Force refresh completion
imap <s-space> <Plug>(asyncomplete_force_refresh)

" vim-lsp configuration for IDE-like Flow help
" See https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Flow
if executable('flow-language-server')
   nnoremap gd :LspDefinition<cr>
   nnoremap <leader>i :LspHover<cr>
   autocmd FileType javascript setlocal omnifunc=lsp#complete
   autocmd FileType javascript.jsx setlocal omnifunc=lsp#complete

   au User lsp_setup call lsp#register_server({
      \ 'name': 'flow-language-server',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'flow-language-server --stdio']},
      \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
      \ 'whitelist': ['javascript', 'javascript.jsx'],
      \ })
endif

" }}}

" Easy align plugin {{{

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" }}}

let g:gitgutter_max_signs=9999

" End Nvie Code   :: Sort Through }}}

" Move more naturally up/down when wrapping is enabled.
nnoremap j gj
nnoremap k gk

" Map F1 to Esc because I'm sick of seeing help pop up
map <F1> <Esc>
imap <F1> <Esc>

" Local dirs
if !has('win32') && !empty($DOTFILES)
  set backupdir=$DOTFILES/caches/vim
  set directory=$DOTFILES/caches/vim
  set undodir=$DOTFILES/caches/vim
  let g:netrw_home = expand('$DOTFILES/caches/vim')
endif

" Create vimrc autocmd group and remove any existing vimrc autocmds,
" in case .vimrc is re-sourced.
augroup vimrc
  autocmd!
augroup END

" Per-mode cursor shape
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
if has('unix')
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
elseif has('macuinx')
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
endif

" Theme / Syntax highlighting

" " Show trailing whitespace.
autocmd vimrc ColorScheme * :hi ExtraWhitespace ctermbg=red guibg=red

" Visual settings
set cursorline " Highlight current line
set number " Enable line numbers.
set showtabline=2 " Always show tab bar.
set relativenumber " Use relative line numbers. Current line is still in status bar.
"set title " Show the filename in the window titlebar.
"set nowrap " Do not wrap lines.
"set noshowmode " Don't show the current mode (airline.vim takes care of us)
set laststatus=2 " Always show status line

" Show absolute numbers in insert mode, otherwise relative line numbers.
autocmd vimrc InsertEnter * :set norelativenumber
autocmd vimrc InsertLeave * :set relativenumber

set textwidth=80
" Show 120 columns but make it obvious where 80 characters is
let &colorcolumn="81,".join(range(120,999),",")

" Scrolling
set scrolloff=3 " Start scrolling three lines before horizontal border of window.
set sidescrolloff=3 " Start scrolling three columns before vertical border of window.

" Indentation
set autoindent " Copy indent from last line when starting new line.
set shiftwidth=2 " The # of spaces for indenting.
set smarttab " At start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces.
set softtabstop=2 " Tab key results in 2 spaces
set tabstop=2 " Tabs indent only 2 spaces
set expandtab " Expand tabs to spaces

" Reformatting
set nojoinspaces " Only insert single space after a '.', '?' and '!' with a join command.

" Toggle show tabs and trailing spaces (,v)
if has('win32')
  set listchars=tab:>\ ,trail:.,eol:$,nbsp:_,extends:>,precedes:<
else
  set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:»,precedes:«
endif
"set fillchars=fold:-
nnoremap <silent> <leader>v :call ToggleInvisibles()<CR>

" Extra whitespace
autocmd vimrc BufWinEnter * :2match ExtraWhitespaceMatch /\s\+$/
autocmd vimrc InsertEnter * :2match ExtraWhitespaceMatch /\s\+\%#\@<!$/
autocmd vimrc InsertLeave * :2match ExtraWhitespaceMatch /\s\+$/

" Toggle Invisibles / Show extra whitespace
function! ToggleInvisibles()
  set nolist!
  if &list
    hi! link ExtraWhitespaceMatch ExtraWhitespace
  else
    hi! link ExtraWhitespaceMatch NONE
  endif
endfunction

set nolist
call ToggleInvisibles()

" Trim extra whitespace
function! StripExtraWhiteSpace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction
noremap <leader>ss :call StripExtraWhiteSpace()<CR>

" Search / replace
set gdefault " By default add g flag to search/replace. Add g to toggle.
set hlsearch " Highlight searches
set incsearch " Highlight dynamically as pattern is typed.
set ignorecase " Ignore case of searches.
set smartcase " Ignore 'ignorecase' if search pattern contains uppercase characters.

" Clear last search
map <silent> <leader>/ <Esc>:nohlsearch<CR>

" Ignore things
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/log/*,*/tmp/*

" Vim commands
set hidden " When a buffer is brought to foreground, remember undo history and marks.
set report=0 " Show all changes.
set mouse=a " Enable mouse in all modes.
set ttymouse=xterm2 " Ensure mouse works inside tmux
set shortmess+=I " Hide intro menu.

" Splits
set splitbelow " New split goes below
set splitright " New split goes right

let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_disable_when_zoomed = 1
" Ctrl-arrows select split
nnoremap <silent> <C-Up> :TmuxNavigateUp<cr>
nnoremap <silent> <C-Down> :TmuxNavigateDown<cr>
nnoremap <silent> <C-Left> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-Right> :TmuxNavigateRight<cr>
" This seems to be necessary in gnome-terminal
nnoremap <silent> [1;5A :TmuxNavigateUp<cr>
nnoremap <silent> [1;5B :TmuxNavigateDown<cr>
nnoremap <silent> [1;5D :TmuxNavigateLeft<cr>
nnoremap <silent> [1;5C :TmuxNavigateRight<cr>
" Ctrl-J/K/L/H select split
nnoremap <silent> <C-H> :TmuxNavigateUp<cr>
nnoremap <silent> <C-L> :TmuxNavigateDown<cr>
nnoremap <silent> <C-J> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-K> :TmuxNavigateRight<cr>
" Previous split
nnoremap <silent> <C-\> :TmuxNavigatePrevious<cr>

" Buffer navigation
nnoremap <leader>b :CtrlPBuffer<CR> " List other buffers
map <leader><leader> :b#<CR> " Switch between the last two files
map gb :bnext<CR> " Next buffer
map gB :bprev<CR> " Prev buffer

" Switch buffers with Alt-Left/Right
nmap <silent> <M-Left> :bprev<CR>
nmap <silent> <M-Right> :bnext<CR>
vmap <silent> <M-Left> :bprev<CR>
vmap <silent> <M-Right> :bnext<CR>
nmap <silent> [1;3D :bprev<CR>
nmap <silent> [1;3C :bnext<CR>
vmap <silent> [1;3D <Esc>:bprev<CR>
vmap <silent> [1;3C <Esc>:bnext<CR>

" Resize panes with Shift-Left/Right/Up/Down
nnoremap <silent> <S-Up> :resize +1<CR>
nnoremap <silent> <S-Down> :resize -1<CR>
nnoremap <silent> <S-Right> :vertical resize +1<CR>
nnoremap <silent> <S-Left> :vertical resize -1<CR>
nnoremap <silent> [1;2A :resize +1<CR>
nnoremap <silent> [1;2B :resize -1<CR>
nnoremap <silent> [1;2C :vertical resize +1<CR>
nnoremap <silent> [1;2D :vertical resize -1<CR>

" Ctrl-J, the opposite of Shift-J
nnoremap <C-J> i<CR><Esc>k:.s/\s\+$//e<CR>j^

" Jump to buffer number 1-9 with ,<N> or 1-99 with <N>gb
let c = 1
while c <= 99
  if c < 10
    " execute "nnoremap <silent> <leader>" . c . " :" . c . "b<CR>"
    execute "nmap <leader>" . c . " <Plug>AirlineSelectTab" . c
  endif
  execute "nnoremap <silent> " . c . "gb :" . c . "b<CR>"
  let c += 1
endwhile

" Fix page up and down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" Use Q for formatting the current paragraph (or selection)
" vmap Q gq
" nmap Q gqap

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" When editing a file, always jump to the last known cursor position. Don't do
" it for commit messages, when the position is invalid, or when inside an event
" handler (happens when dropping a file on gvim).
autocmd vimrc BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" The :Src command will source .vimrc & .gvimrc files
command! Src :call SourceConfigs()

if !exists("*SourceConfigs")
  function! SourceConfigs()
    let files = ".vimrc"
    source $MYVIMRC
    if has("gui_running")
      let files .= ", .gvimrc"
      source $MYGVIMRC
    endif
    echom "Sourced " . files
  endfunction
endif

" FILE TYPES

autocmd vimrc BufRead .vimrc,*.vim set keywordprg=:help
autocmd vimrc BufRead,BufNewFile *.md set filetype=markdown
autocmd vimrc BufRead,BufNewFile *.tmpl set filetype=html
autocmd vimrc FileType sql :let b:vimpipe_command="psql mydatabase"
autocmd vimrc FileType sql :let b:vimpipe_filetype="postgresql"

" PLUGINS

" Airline
let g:airline_powerline_fonts = 1 " TODO: detect this?
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s '
let g:airline#extensions#tabline#buffer_nr_show = 1
" let g:airline#extensions#tabline#fnamecollapse = 0
" let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#fnametruncate = 16
let g:airline#extensions#tabline#fnamecollapse = 2
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#syntastic#enabled = 1

" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMouseMode = 2
let NERDTreeMinimalUI = 1
map <leader>n :NERDTreeToggle<CR>
autocmd vimrc StdinReadPre * let s:std_in=1
" If no file or directory arguments are specified, open NERDtree.
" If a directory is specified as the only argument, open it in NERDTree.
autocmd vimrc VimEnter *
  \ if argc() == 0 && !exists("s:std_in") |
  \   NERDTree |
  \ elseif argc() == 1 && isdirectory(argv(0)) |
  \   bd |
  \   exec 'cd' fnameescape(argv(0)) |
  \   NERDTree |
  \ end

" Signify
let g:signify_vcs_list = ['git', 'hg', 'svn']

" CtrlP.vim
" map <leader>p <C-P>
" map <leader>r :CtrlPMRUFiles<CR>
" let g:ctrlp_match_window_bottom = 0 " Show at top of window
let g:ctrlp_show_hidden = 1

" Vim-pipe
let g:vimpipe_invoke_map = '<Leader>r'
let g:vimpipe_close_map = '<Leader>p'

" DBExt
let g:dbext_default_profile_PG_skillsbot = 'type=pgsql:host=rds.bocoup.com:dbname=skillsbot-dev:user=skillsbot-dev'
let g:dbext_default_profile = 'PG_skillsbot'

" Indent Guides
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1

" Mustache/handlebars
let g:mustache_abbreviations = 1

" Ack/ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
let g:ack_autoclose = 1
nnoremap <Leader>a :Ack!<Space>

" Multiple cursors
nnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>
vnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>
nnoremap <silent> j :MultipleCursorsFind <C-R>/<CR>
vnoremap <silent> j :MultipleCursorsFind <C-R>/<CR>

" Ale
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'node_modules/.bin/eslint'
let g:syntastic_json_checkers = ['jsonlint']


" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''


" Emmet
" imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

" https://github.com/junegunn/vim-plug
" Reload .vimrc and :PlugInstall to install plugins.
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'                                                       " Core config
Plug 'rafi/awesome-vim-colorschemes'                                            " Color schemes
Plug 'bling/vim-airline'                                                        " Status bar
Plug 'tpope/vim-surround'                                                       " Quotes / parens / tags
Plug 'tpope/vim-fugitive'                                                       " Git wrapper
Plug 'tpope/vim-rhubarb'                                                        " Github helper
Plug 'tpope/vim-vinegar'                                                        " File browser (?)
Plug 'tpope/vim-repeat'                                                         " Enable . repeat in plugins
Plug 'tpope/vim-commentary'                                                     " (gcc) Better commenting
Plug 'tpope/vim-unimpaired'                                                     " Pairs of mappings with [ ]
Plug 'tpope/vim-eunuch'                                                         " Unix helpers
Plug 'scrooloose/nerdtree'                                                      " (,n) File browser
Plug 'ctrlpvim/ctrlp.vim'                                                       " (C-P)(,b) Fuzzy file/buffer/mru/tag finder
if v:version < 705 && !has('patch-7.4.785')
  Plug 'vim-scripts/PreserveNoEOL'                                              " Preserve missing final newline on save
endif
Plug 'editorconfig/editorconfig-vim'                                            " EditorConfig
Plug 'nathanaelkane/vim-indent-guides'                                          " (,ig) Visible indent guides
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}                                   " React JSX highlighting/indenting
Plug 'AndrewRadev/splitjoin.vim'                                                " (gS)(gJ) Split/join multi-line statements
Plug 'mhinz/vim-signify'                                                        " VCS status in the sign column
Plug 'mattn/emmet-vim'                                                          " (C-Y,) Expand HTML abbreviations
Plug 'chase/vim-ansible-yaml'                                                   " Ansible YAML highlighting
Plug 'klen/python-mode', {'for': 'python'}                                      " Python mode
Plug 'terryma/vim-multiple-cursors'                                             " (C-N) Multiple selections/cursors
Plug 'vim-scripts/dbext.vim'
Plug 'krisajenkins/vim-pipe'                                                    " (,r) Run a buffer through a command
Plug 'krisajenkins/vim-postgresql-syntax'
Plug 'mileszs/ack.vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'elzr/vim-json'
Plug 'othree/eregex.vim'
if v:version >= 800
  Plug 'w0rp/ale'
else
  Plug 'vim-syntastic/syntastic'
endif
Plug 'leafgarland/typescript-vim'
Plug 'tmhedberg/simpylfold'
Plug 'konfekt/fastfold'
Plug 'vim-scripts/yankring.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'othree/html5-syntax.vim'
Plug 'tmhedberg/matchit'
Plug 'alunny/pegjs-vim'
Plug 'nvie/vim-align'
Plug 'nvie/python-mode'
Plug 'nvie/vim-oceanic-next'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-git'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-speeddating'
Plug 'airblade/vim-gitgutter'
Plug 'jparise/vim-graphql'
Plug 'terryma/vim-expand-region'
Plug 'foosoft/vim-argwrap'
Plug 'bling/vim-bufferline'
Plug 'tpope/vim-commentary'
Plug 'leshill/vim-json'
Plug 'mxw/vim-jsx'
Plug 'jelera/vim-javascript-syntax'
Plug 'othree/yajs'
Plug 'groenewege/vim-less'
Plug 'scy/vim-mkdir-on-write'
Plug 'tsl0922/vim-nginx'
Plug 'powerline/powerline'
Plug 'tpope/vim-sleuth'
Plug 'ruanyl/vim-sort-imports'
call plug#end()

" Folding using fastFolding
let g:markdown_folding = 1
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:sh_fold_enabled= 7
let g:ruby_fold = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:r_syntax_folding = 1
let g:rust_fold = 1
let g:php_folding = 1

" presentation
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"
let g:javascript_conceal_noarg_arrow_function = "🞅"
let g:javascript_conceal_underscore_arrow_function = "🞅"
let g:SimpylFold_docstring_preview = 1
let g:gruvbox_bold = 1
let g:gruvbox_italic = 1
let g:gruvbox_italicize_comments = 1
let g:gruvbox_contrast_dark = 'medium'
set background=dark
colorscheme OceanicNext

" Folding rules {{{
set foldenable                  " enable folding
set foldcolumn=2                " add a fold column
set foldmethod=marker           " detect triple-{ style fold markers
set foldlevelstart=99           " start out with everything unfolded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                                " which commands trigger auto-unfold
