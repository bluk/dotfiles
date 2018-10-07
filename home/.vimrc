set nocompatible

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

if filereadable(expand("/etc/vim/vimrc.bundles"))
  source /etc/vim/vimrc.bundles
endif

compiler ruby

if &t_Co > 2
	set bg=dark
	syntax on
	set hlsearch
	try
		colorscheme vividchalk
	catch /^Vim\%((\a\+)\)\=:E185/
	endtry
endif

map <silent> <LocalLeader>nh :nohls<CR>

map <silent> <LocalLeader>bd :bufdo :bd<CR>

set number
set relativenumber
augroup toggle_relative_number
  autocmd InsertEnter * :setlocal norelativenumber
  autocmd InsertLeave * :setlocal relativenumber
augroup END

set tabstop=2
set shiftwidth=2
set autoindent
set softtabstop=2
set expandtab
set pastetoggle=<F2>
set backupcopy=yes " Setting backup copy preserves file inodes, which are needed for Docker file mounting

" For debugger symbols and the like
" set signcolumn=yes

filetype on
filetype indent on
filetype plugin on

set ignorecase
set incsearch
set smartcase

set backspace=eol,start,indent
set ruler

set nowrap

set history=10000

set showcmd

set autoread

set wildmenu

set tabpagemax=40

set completeopt=longest,menuone
set complete-=t " Don't use tags for autocomplete

set encoding=utf-8

set exrc

" Folds
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=manual
set foldcolumn=4
" autocmd ColorScheme * highlight SignColumn ctermbg=235 guibg=darkgrey
" autocmd ColorScheme * highlight SignColumn ctermbg=235 guibg=darkgrey
" highlight SignColumn guibg=darkgrey ctermbg=235
" highlight Folded ctermbg=black  guibg=black
" highlight Folded term=standout ctermfg=14 ctermbg=242 guifg=Cyan guibg=Grey
highlight Folded ctermfg=15 ctermbg=232 guifg=#DDEEFF guibg=#222222
" term=standout ctermfg=195 ctermbg=18 guifg=#aaddee guibg=#110077

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

" Remaps Ctrl+N to keep menu highlighted
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Remaps to not automatically insert longest text
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Highlight over 80 characters
if exists('+colorcolumn')
    set colorcolumn=80,120
else
    match ErrorMsg '\%>120.\+'
endif

set cursorline
highlight CursorLine term=none cterm=none ctermbg=235 guibg=#333333

" Double // is necessary to use absolute file path (in case there's two
" README.md files for instance)
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile
set undoreload=10000 "maximum number lines to save for undo on a buffer reload
set undolevels=1000 "maximum number of changes that can be undone

set wildignore +=tmp,.git,.*.swp,.svn,bower_components,node_modules,*.class,*.jar,*.gif,*.png,*.jpg,*.bak,*.pyc,vendor,*.o,*.class,*.lo

set showmatch
set hidden
set textwidth=0
set nosmartindent

autocmd FileType c,cpp,slang setlocal cindent
autocmd FileType c setlocal formatoptions+=ro
autocmd FileType perl setlocal smartindent
autocmd FileType css setlocal smartindent expandtab
autocmd FileType html setlocal formatoptions+=t1 tabstop=2 shiftwidth=2 autoindent softtabstop=2 expandtab
autocmd FileType xml setlocal formatoptions+=t1 tabstop=2 shiftwidth=2 autoindent softtabstop=2 expandtab
autocmd FileType make setlocal noexpandtab shiftwidth=4

" Ruby
autocmd FileType ruby setlocal smartindent tabstop=2 shiftwidth=2 autoindent softtabstop=2 expandtab
autocmd FileType eruby setlocal smartindent tabstop=2 shiftwidth=2 autoindent softtabstop=2 expandtab
autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby setlocal commentstring=#\ %s
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

autocmd FileType sh setlocal commentstring=#\ %s
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

augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" Status
set laststatus=2
set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\        " buffer number, and flags
set statusline+=%-40F\                    " full path
set statusline+=%=                        " seperate between right- and left-aligned
set statusline+=%10(C(%c%V)%)\            " column and virtual column
set statusline+=%6(L(%l/%L)%)\            " line
set statusline+=%4(B(%o)%)\               " byte
set statusline+=%P\                       " percentage of file
set statusline+=%1*[%{&ff}]-%y%*%*        " file type

" NerdTree
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>

let NERDTreeIgnore=['\.pyc$', '\.o$', '\.class$', '\.lo$']
let NERDTreeHijackNetrw = 0

" FZF

let $FZF_DEFAULT_COMMAND = 'find * -type f 2>/dev/null | grep -v -E "deps/|_build/|node_modules/|vendor/"'
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_tags_command = 'ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f --langmap=Lisp:+.clj'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

map <silent> <leader>ff :Files<CR>
map <silent> <leader>fg :GFiles<CR>
map <silent> <leader>fb :Buffers<CR>
map <silent> <leader>ft :Tags<CR>

map <silent> <C-p> :Files<CR>

set scrolloff=5
set sidescrolloff=5
set mouse=
set ttymouse=

function! GitGrepWord()
  cgetexpr system("git grep -n '" . expand("<cword>") . "'")
  cwin
  echo 'Number of matches: ' . len(getqflist())
endfunction
command! -nargs=0 GitGrepWord :call GitGrepWord()
nnoremap <silent> <Leader>gw :GitGrepWord<CR>

function! Trim()
  %s/\s*$//
  ''
endfunction
command! -nargs=0 Trim :call Trim()
nnoremap <silent> <Leader>cw :Trim<CR>

" Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

" Highlight too-long lines
autocmd BufRead,InsertEnter,InsertLeave * 2match LineLengthError /\%126v.*/
highlight LineLengthError ctermbg=red guibg=red
autocmd ColorScheme * highlight LineLengthError ctermbg=red guibg=red

" Change color of comments
highlight Comment ctermfg=lightblue
autocmd ColorScheme * highlight Comment ctermfg=lightblue guifg=lightblue

let g:VimuxUseNearestPane = 1

" Vimux
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

" Side Search {{{
let g:side_search_prg = 'ack-grep --word-regexp'
      \. " --heading -C 2 --group"
let g:side_search_splitter = 'vnew'
let g:side_search_split_pct = 0.4

" SideSearch current word and return to original window
nnoremap <Leader>ss :SideSearch <C-r><C-w><CR> | wincmd p

" SS shortcut and return to original window
command! -complete=file -nargs=+ SS execute 'SideSearch <args>'
" }}}

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

let g:vim_markdown_folding_disabled = 1

let g:go_fmt_command = "goimports"
let g:go_highlight_trailing_whitespace_error = 0

let test#strategy = "vimux"
let test#python#runner = 'nose'

" TComment
map <silent> <LocalLeader>cc :TComment<CR>
map <silent> <LocalLeader>uc :TComment<CR>

map <silent> <LocalLeader>rt :!ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f --langmap=Lisp:+.clj<CR>

map <silent> <LocalLeader>gd :e product_diff.diff<CR>:%!git diff<CR>:setlocal buftype=nowrite<CR>

set tags+=gems.tags

cnoremap <Tab> <C-L><C-D>

nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <silent> Y y$

map <silent> <LocalLeader>ws :highlight clear ExtraWhitespace<CR>

map <silent> <LocalLeader>pp :set paste!<CR>

" Pasting over a selection does not replace the clipboard
xnoremap <expr> p 'pgv"'.v:register.'y'

imap <C-L> <SPACE>=><SPACE>

command! SudoW w !sudo tee %

" CTRL-J/K navigation in popups
inoremap <expr> <c-j> (pumvisible()?"\<C-n>":"\<c-j>")
inoremap <expr> <c-k> (pumvisible()?"\<C-p>":"\<c-k>")

" with help from http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufnr = buflist[winnr - 1]
  let file = bufname(bufnr)
  let buftype = getbufvar(bufnr, 'buftype')

  if buftype == 'nofile'
    if file =~ '\/.'
      let file = substitute(file, '.*\/\ze.', '', '')
    endif
  else
    let file = fnamemodify(file, ':p:t')
  endif
  if file == ''
    let file = '[No Name]'
  endif
  return file
endfunction

" set tabline=%!MyTabLine()

" Syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Swift

let g:syntastic_swift_checkers = ['swiftpm', 'swiftlint']

" :w!! to write out a file with sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Netrw
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
