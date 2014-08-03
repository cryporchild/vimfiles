filetype plugin on
filetype indent on

" turn syntax highlighting on
set t_Co=256
syntax on
colorscheme ir_black

" Pathogen
call pathogen#infect()

" set UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

" Keep undo history between buffer switches
set hidden

" disable vi compatibility (emulation of old bugs)
set nocompatible

set completeopt=menu,longest,preview

" configure tabwidth and insert spaces instead of tabs
set expandtab
set shiftwidth=4
set tabstop=4
set shiftround  " round indent to multiple of 'shiftwidth'
let c_space_errors = 2

" Search while typing.
set incsearch

"Change so paste commands match indent level
map p ]p
map P ]P

"Save when focus is lost
:au FocusLost * :wa

" Maps scroll the left and right
map H zh
map L zl

" I'm lazy, so map comma to colon
map , :

"Maps ctrl+n to go to next buffer
:nnoremap <C-n> :w<CR> :bnext<CR>

"maps ctrl+p to go to previous buffer
:nnoremap <C-p> :w<CR> :bprevious<CR>

" Maps Alt-[h,j,k,l] to resizing a window split
map <silent> <A-h> <C-w><
map <silent> <A-j> <C-W>-
map <silent> <A-k> <C-W>+
map <silent> <A-l> <C-w>>
" Maps Alt-[s.v] to horizontal and vertical split respectively
map <silent> <A-s> :split<CR>
map <silent> <A-v> :vsplit<CR>
" Maps Alt-[n,p] for moving next and previous window respectively
map <silent> <A-n> <C-w><C-w>
map <silent> <A-p> <C-w><S-w>
" Maps Alt-c with close window
map <silent> <A-c> :clo<CR>
map <silent> <A-d> :BD<CR>

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" in normal mode F2 will save the file
nmap <F2> :wa<CR>

" switch between header/source with F4
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

"When F4 is pressed, the list of current buffers appears,
"then you are prompted with the list of open files to which you can choose the
"number
:nnoremap <F6> :buffers<CR>:buffer<Space>

" goto definition with F11
map <F11> <C-]>

set laststatus=2
" TODO Re-enable when fonts loaded!
"let g:airline_powerline_fonts=1

let g:flake8_max_line_length=119

nnoremap <F3> :set invpaste paste?<CR>
set pastetoggle=<F3>
set showmode

" map the Grep command to F10
set grepprg=grep\ -nH\ $*
nnoremap <silent> <F10> :Grep -r --exclude=doxygen*.* --include=*.c --include=*.h --include=*.cpp --include=*.hpp --include=*.xml --include=wscript --include=*.edc<CR>

nnoremap <silent> <F8> :TlistToggle<CR>

" This offers intelligent C++ completion when typing ... .->. or <C-o>
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/tags
" map <F12> :!ctags -R -f ~/.vim/tags/tags --c++-kinds=+p --fields=+iaS --extra=+q --exclude=ggl --exclude=boost ./ *<CR>
map <F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

let mapleader=" "
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_autoclose_preview_window_after_completion=1

nmap <F5> :wa<CR> :!python %<CR>
"autocmd Filetype python nnoremap <buffer> <F5> <C-o>:update<Bar>execute '!python '.shellescape(@%, 1)<CR>


function! Build()
    !python setup.py sdist && pip install --upgrade --no-deps .
endfunction
nmap <F9> :call Build()<CR>

"setlocal spell
"setlocal spelllang=en_gb
"map <F7> :setlocal spell! spell?<CR>
"imap <F7> <C-o>:setlocal spell! spell?<CR>

set nowrap

set backspace=2
" Place the backup files in a single directory - kepp it neat!
set backupdir=~/.vim/backup,/tmp
" ?????????
set wrapscan
"set spell
" turn line numbers on
set number
" Show numbers relative to the cursor
"set relativenumber
" highlight matching braces
set showmatch
let loaded_matchparen = 1
" Highlight lines wider than 80 characters
"set textwidth=79
" Set to auto read when a file is changed from the outside
set autoread
" Highlight doxygen syntax
let g:load_doxygen_syntax=1

" Set the cursor to be centered - when moving vertical..
set so=10
" Set cursor colours:
if &term =~ "xterm\\|rxvt\\|screen"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;red\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;green\x7"
  silent !echo -ne "\033]12;green\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]12;yellow\007"
  " use \003]12;gray\007 for gnome-terminal
endif

set ruler
set background=dark

" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */

" Creates a session
function! MakeSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if ( filewritable( b:sessiondir ) != 2 )
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:sessionfile = b:sessiondir . '/session.vim'
  exe "mksession! " . b:sessionfile
endfunction

" Updates a session, BUT ONLY IF IT ALREADY EXISTS
function! UpdateSession()
  if v:this_session != ""
    echo "Session Saved."
    exe 'mksession! ' . v:this_session
  else
    echo "No Session."
  endif
endfunction

" Loads a session if it exists
function! LoadSession()
  if argc() == 0
    let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
    let b:sessionfile = b:sessiondir . "/session.vim"
    if ( filereadable( b:sessionfile ) )
      exe 'source ' b:sessionfile
    else
      echo "No session loaded."
    endif
  else
    let b:sessionfile = ""
    let b:sessiondir = ""
  endif
endfunction

au VimEnter * nested :call LoadSession()
au VimLeave * :call UpdateSession()

" ------------------------------ TaskList ----------------------------------
"map <leader>t <Plug>TaskList
map T :TaskList<CR>
let g:tlTokenList = ['TODO', '@todo']

" ------------------------------ Python   ----------------------------------
set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m


" Set the colour scheme for lines that exceed text width
highlight TooLong ctermbg=20
au BufWinEnter * let w:m2=matchadd('TooLong', '\%<82v.\%>80v', -1)
highlight FarTooLong ctermbg=52
au BufWinEnter * let w:m2=matchadd('FarTooLong', '\%<122v.\%>120v', -1)

" Ensure the slowdown for buffer matches is prolonged
au Filetype cpp,c,java au BufWinLeave call clearmatches()

" Ensure the syntax is updated on loading.
autocmd BufEnter * :syntax sync fromstart

" Enable highlighting of GLSL files:
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl
