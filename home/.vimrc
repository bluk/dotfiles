set nocompatible

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

if filereadable(expand("/etc/vim/vimrc.bundles"))
  source /etc/vim/vimrc.bundles
endif

compiler ruby

filetype on
set encoding=utf-8

filetype plugin on

if &t_Co > 2
	set bg=dark
	syntax on
	try
		colorscheme vividchalk
	catch /^Vim\%((\a\+)\)\=:E185/
	endtry
endif

" Double // is necessary to use absolute file path (in case there's two
" README.md files for instance)
set backupdir=~/.vim/backup//
set backupcopy=yes " Setting backup copy preserves file inodes, which are needed for Docker file mounting
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile
set undoreload=10000 "maximum number lines to save for undo on a buffer reload
set undolevels=1000 "maximum number of changes that can be undone

set history=10000

" Indention, tabs, spaces, wordwrapping
filetype indent on
" filetype indent on removes the need for set smartindent
" set nosmartindent
set autoindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set backspace=eol,start,indent

set nowrap

set textwidth=0
set pastetoggle=<F2>
map <silent> <LocalLeader>pp :set paste!<CR>

" Pasting over a selection does not replace the clipboard
xnoremap <expr> p 'pgv"'.v:register.'y'

" Highlighting
set hlsearch
map <silent> <LocalLeader>nh :nohls<CR>
set ignorecase
set incsearch
set smartcase

" Gutter numbers
set number
set relativenumber
augroup toggle_relative_number
  autocmd InsertEnter * :setlocal norelativenumber
  autocmd InsertLeave * :setlocal relativenumber
augroup END

" For debugger symbols and the like
set signcolumn=yes
highlight SignColumn ctermfg=15 ctermbg=232 guifg=#DDEEFF guibg=#222222

" Folds
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=manual
set foldcolumn=4
highlight Folded ctermfg=15 ctermbg=232 guifg=#DDEEFF guibg=#222222

set viewoptions-=options
augroup auto_save_folds
  autocmd BufWritePost *
        \   if expand('%') != '' && &buftype !~ 'nofile'
        \|      mkview
        \|  endif
  autocmd BufRead *
        \   if expand('%') != '' && &buftype !~ 'nofile'
        \|      silent loadview
        \|  endif
augroup END

let g:vim_markdown_folding_disabled = 1

" Highlight trailing whitespace
map <silent> <LocalLeader>ws :highlight clear ExtraWhitespace<CR>

function! Trim()
  %s/\s*$//
  ''
endfunction
command! -nargs=0 Trim :call Trim()
nnoremap <silent> <Leader>cw :Trim<CR>

autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

" Highlight too-long lines
autocmd BufRead,InsertEnter,InsertLeave * 2match LineLengthError /\%120v.*/
highlight LineLengthError ctermbg=red guibg=red
autocmd ColorScheme * highlight LineLengthError ctermbg=red guibg=red

" Change color of comments
highlight Comment ctermfg=lightblue
autocmd ColorScheme * highlight Comment ctermfg=lightblue guifg=lightblue

" Buffers
set hidden
map <silent> <LocalLeader>bd :bufdo :bd<CR>
map <C-K> :bprev<CR>
map <C-J> :bnext<CR>

" Tabs
set tabpagemax=40

" Mouse
set mouse=
set ttymouse=

" Automatically read unchanged files if changed elsewhere
set autoread

" Minimum number of lines around scrolling
set scrolloff=5
set sidescrolloff=5

" Show matching bracket, brace, etc.
set showmatch

" Auto-completion
set completeopt=longest,menuone
set complete-=t " Don't use tags for autocomplete

map <silent> <LocalLeader>rt :!ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f --langmap=Lisp:+.clj<CR>

" Status
set laststatus=2
set statusline=
set statusline+=%<\                               " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\                " buffer number, and flags
set statusline+=%-40F\                            " full path
set statusline+=%=                                " seperate between right- and left-aligned
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%8(C(%c%V)%)\                    " column and virtual column
set statusline+=%6(L(%l/%L)%)\                    " line
set statusline+=%4(B(%o)%)\                       " byte
set statusline+=%P\                               " percentage of file
set statusline+=%1*%{fugitive#statusline()}%*\    " git status
set statusline+=%1*[%{&ff}]%*-%1*%y%*\            " file type
set statusline+=

" Bottom gutter
set showcmd
set ruler

" Show command options with TAB
set wildmenu

" Ignore files
set wildignore +=tmp,.git,.swp,.svn,bower_components,node_modules,*.class,*.jar,*.gif,*.png,*.jpg,*.bak,*.pyc,vendor,*.o,*.class,*.lo

" Read project directory's .vimrc file
" set exrc

" :w!! to write out a file with sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" CTRL-J/K navigation in popups
inoremap <expr> <c-j> (pumvisible()?"\<C-n>":"\<c-j>")
inoremap <expr> <c-k> (pumvisible()?"\<C-p>":"\<c-k>")

" Remaps Ctrl+N to keep menu highlighted
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Remaps to not automatically insert longest text
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Cursorline
set cursorline
highlight CursorLine term=none cterm=none ctermbg=235 guibg=#333333

" Netrw
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 20

" File types
autocmd FileType c,cpp,slang setlocal cindent
autocmd FileType c setlocal formatoptions+=ro
autocmd FileType perl setlocal smartindent
autocmd FileType css setlocal smartindent expandtab
autocmd FileType html setlocal formatoptions+=t1 tabstop=2 shiftwidth=2 autoindent softtabstop=2 expandtab
autocmd FileType xml setlocal formatoptions+=t1 tabstop=2 shiftwidth=2 autoindent softtabstop=2 expandtab
autocmd FileType make setlocal noexpandtab shiftwidth=4
autocmd FileType sh setlocal commentstring=#\ %s

" Ruby
autocmd FileType ruby setlocal smartindent tabstop=2 shiftwidth=2 autoindent softtabstop=2 expandtab
autocmd FileType eruby setlocal smartindent tabstop=2 shiftwidth=2 autoindent softtabstop=2 expandtab
autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby setlocal commentstring=#\ %s
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby runtime ruby_mappings.vim

" PHP
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP smartindent tabstop=4 shiftwidth=4 softtabstop=4

" JavaScript
autocmd FileType javascript setlocal formatoptions+=t1 tabstop=2 shiftwidth=2 autoindent softtabstop=2 expandtab
autocmd FileType javascript setlocal commentstring=//\ %s

" Python
autocmd FileType python setlocal smartindent tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType python runtime python_mappings.vim

" Java
autocmd FileType java setlocal smartindent tabstop=4 shiftwidth=4 softtabstop=4

" C#
autocmd FileType cs setlocal smartindent tabstop=4 shiftwidth=4 softtabstop=4

" Swift
autocmd FileType swift setlocal smartindent tabstop=4 shiftwidth=4 softtabstop=4

" Autoremove trailing spaces when saving the buffer
autocmd FileType c,cpp,elixir,eruby,html,java,javascript,php,ruby,swift autocmd BufWritePre <buffer> :%s/\s\+$//e

autocmd BufNewFile,BufRead *.txt setlocal textwidth=78
autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_us

" Run terraform fmt on terraform files
autocmd BufWritePre *.tf call terraform#fmt()

" Markdown
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" NerdTree
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>

let NERDTreeIgnore=['\.pyc$', '\.o$', '\.class$', '\.lo$']
let NERDTreeHijackNetrw = 1

" FZF
let $FZF_DEFAULT_COMMAND = 'find . -type f 2>/dev/null | grep -v -E "deps/|_build/|node_modules/|vendor/|.git/|.vim/|.build/"'
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_tags_command = 'ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f --langmap=Lisp:+.clj'
let g:fzf_layout = { 'down': '~40%' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

map <silent> <leader>ff :Files<CR>
map <silent> <leader>fg :GFiles<CR>
map <silent> <leader>fb :Buffers<CR>
map <silent> <leader>ft :Tags<CR>

" Git grep word
function! GitGrepWord()
  cgetexpr system("git grep -n '" . expand("<cword>") . "'")
  cwin
  echo 'Number of matches: ' . len(getqflist())
endfunction
command! -nargs=0 GitGrepWord :call GitGrepWord()
nnoremap <silent> <Leader>gw :GitGrepWord<CR>

" Vimux
let g:VimuxUseNearestPane = 1

map <silent> <LocalLeader>rl :wa<CR> :VimuxRunLastCommand<CR>
map <silent> <LocalLeader>vi :wa<CR> :VimuxInspectRunner<CR>
map <silent> <LocalLeader>vk :wa<CR> :VimuxInterruptRunner<CR>
map <silent> <LocalLeader>vx :wa<CR> :VimuxCloseRunner<CR>
map <silent> <LocalLeader>vp :VimuxPromptCommand<CR>
vmap <silent> <LocalLeader>vs "vy :call VimuxRunCommand(@v)<CR>
nmap <silent> <LocalLeader>vs vip<LocalLeader>vs<CR>
map <silent> <LocalLeader>ds :call VimuxRunCommand('clear; grep -E "^ *describe[ \(]\|^ *context[ \(]\|^ *it[ \(]" ' . bufname("%"))<CR>

" vim-ack
let g:AckAllFiles = 0
let g:AckCmd = 'ack --type-add ruby=.feature --ignore-dir=tmp 2> /dev/null'

" Ack
map <LocalLeader>aw :Ack '<C-R><C-W>'

" Visual * search, modified from: https://git.io/vFGBB
function! s:VSetSearch()
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
	call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
	let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>

let g:ale_enabled = 0                     " Disable linting by default
let g:ale_lint_on_text_changed = 'normal' " Only lint while in normal mode
let g:ale_lint_on_insert_leave = 1        " Automatically lint when leaving insert mode

let g:ale_linters = {
\   'java': []
\ }

let html_use_css=1
let html_number_lines=0
let html_no_pre=1

let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1

let g:ruby_indent_assignment_style = 'variable'

let g:no_html_toolbar = 'yes'

let g:rails_projections = {
      \   "script/*.rb": {
      \     "test": "spec/script/{}_spec.rb"
      \   },
      \   "spec/script/*_spec.rb": {
      \     "alternate": "script/{}.rb"
      \   },
      \   "app/lib/*.rb": {
      \     "test": "spec/lib/{}_spec.rb"
      \   }
      \ }

" Go
let g:go_fmt_command = "goimports"
let g:go_highlight_trailing_whitespace_error = 0

let test#strategy = "vimux"
let test#python#runner = 'nose'

" TComment
map <silent> <LocalLeader>cc :TComment<CR>
map <silent> <LocalLeader>uc :TComment<CR>

" Syntastic
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Swift
let g:syntastic_swift_checkers = ['swiftpm', 'swiftlint']
