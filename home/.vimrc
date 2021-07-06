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
if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif
highlight SignColumn ctermfg=15 ctermbg=232 guifg=#DDEEFF guibg=#222222

" Folds
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=manual
set foldcolumn=4
highlight Folded ctermfg=15 ctermbg=232 guifg=#DDEEFF guibg=#222222

set viewoptions-=options
" augroup auto_save_folds
"   autocmd BufWritePost *
"         \   if expand('%') != '' && &buftype !~ 'nofile'
"         \|      mkview
"         \|  endif
"   autocmd BufRead *
"         \   if expand('%') != '' && &buftype !~ 'nofile'
"         \|      silent loadview
"         \|  endif
" augroup END

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
if !has('nvim')
  set mouse=
  set ttymouse=
endif

" Automatically read unchanged files if changed elsewhere
set autoread

" Minimum number of lines around scrolling
set scrolloff=5
set sidescrolloff=5

" Show matching bracket, brace, etc.
set showmatch

" Automatically writes the file on :make and other actions
set autowrite

" Auto-completion
set completeopt=longest,menuone,noinsert,noselect
set complete-=t " Don't use tags for autocomplete

map <silent> <LocalLeader>rt :!ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f --langmap=Lisp:+.clj<CR>

" Set Python to version 3; required for deoplete
set pyxversion=3

" Status
set laststatus=2
set statusline=
set statusline+=%<\                               " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\                " buffer number, and flags
set statusline+=%-40F\                            " full path
set statusline+=%=                                " seperate between right- and left-aligned
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%8(C(%c%V)%)\                    " column and virtual column
set statusline+=%6(L(%l/%L)%)\                    " line
set statusline+=%4(B(%o)%)\                       " byte
set statusline+=%P\                               " percentage of file
set statusline+=%1*[%{&ff}]%*-%1*%y%*\            " file type
set statusline+=%1*%{ObsessionStatus()}%*
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=

" Bottom gutter
set showcmd
set ruler

" Show command options with TAB
set wildmenu

" Ignore files
set wildignore +=tmp,.git,.swp,.svn,bower_components,node_modules,*.class,*.jar,*.gif,*.png,*.jpg,*.bak,*.pyc,vendor,*.o,*.class,*.lo,target

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
let g:netrw_liststyle = 1

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
autocmd BufNewFile *.js 0r ~/.vim/templates/typescript.tpl

" TypeScript
autocmd BufNewFile *.ts 0r ~/.vim/templates/typescript.tpl

" Python
autocmd FileType python setlocal smartindent tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType python runtime python_mappings.vim

" Java
autocmd FileType java setlocal smartindent tabstop=4 shiftwidth=4 softtabstop=4

" C#
autocmd FileType cs setlocal smartindent tabstop=4 shiftwidth=4 softtabstop=4

" Shell script
autocmd BufNewFile *.sh 0r ~/.vim/templates/bash_script.tpl

" Autoremove trailing spaces when saving the buffer
autocmd FileType c,cpp,elixir,eruby,html,java,javascript,php,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e

autocmd BufNewFile,BufRead *.txt setlocal textwidth=78
autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_us

" Run terraform fmt on terraform files
autocmd BufWritePre *.tf call terraform#fmt()

" Markdown
autocmd BufNewFile,BufRead *.md setlocal textwidth=80

" FZF
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git" --glob "!_build" --glob "!deps" --glob "!node_modules" --glob "!vendor" --glob "!.vim" --glob "!.build" --glob "!target"'
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

if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading\ --hidden\ --follow\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
let g:rg_derive_root='true'

command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)
nnoremap <leader>gw :Rg <C-R><C-W>

" Vimux
" let g:VimuxUseNearestPane = 1

map <silent> <leader>vp :VimuxPromptCommand<CR>
map <silent> <leader>vl :VimuxRunLastCommand<CR>
map <silent> <leader>vi :VimuxInspectRunner<CR>
map <silent> <leader>vx :VimuxCloseRunner<CR>
map <silent> <leader>vk :VimuxInterruptRunner<CR>
map <silent> <leader>vz :call VimuxZoomRunner()<CR>
map <silent> <leader>vc :VimuxClearRunnerHistory<CR>
vmap <silent> <leader>vs "vy :call VimuxRunCommand(@v)<CR>
nmap <silent> <leader>vs vip<LocalLeader>vs<CR>

" Visual * search, modified from: https://git.io/vFGBB
function! s:VSetSearch()
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
	call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
	let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>

let html_use_css=1
let html_number_lines=0
let html_no_pre=1
let g:no_html_toolbar = 'yes'

let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1

" Tagbar

nmap <silent> <leader>tb :TagbarToggle<CR>

" TComment
map <silent> <LocalLeader>cc :TComment<CR>
map <silent> <LocalLeader>uc :TComment<CR>

" Rust
let g:rustfmt_autosave = 1

autocmd FileType rust nmap <leader>b :Cbuild<CR>
autocmd FileType rust nmap <leader>r :Crun<CR>
autocmd FileType rust nmap <leader>t :Ctest<CR>
autocmd FileType rust nmap <leader>ft :RustTest<CR>

if has('nvim')

" " Set completeopt to have a better completion experience
" set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure lsp
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
    capabilities=capabilities,
    on_attach=on_attach
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)
EOF

" Code navigation shortcuts
" as found in :help lsp
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gs    <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Trigger completion with <tab>
" found in :help completion
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
" set signcolumn=yes

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

endif
