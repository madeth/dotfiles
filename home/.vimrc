" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'ruby-matchit'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'skwp/vim-rspec'
NeoBundle 'quickrun.vim'
NeoBundle 'hallison/vim-markdown'
NeoBundle 'YankRing.vim'
NeoBundle 'mbbill/undotree'
NeoBundle 'szw/vim-tags'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'hashivim/vim-terraform'

call neobundle#end()

syntax enable
" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
set backup!
set backupdir=$HOME/.vim-backup
let &directory = &backupdir

set history=20
set ruler
set autoindent
set backspace=2
set laststatus=2
set showmatch
set showmode
set listchars=tab:>-
set list
set hlsearch
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8
set fileformats=unix,dos,mac
set cursorline

syntax on
colorscheme delek

set statusline=%<%f\ %{'['.(&fenc!=''?&fenc:&enc).']'}[TYPE=%{&ff}]%=[ROW=%l/%L],[COL=%c]

" 前回のカーソル位置に移動
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |exe "normal g`\"" | endif
" 改行時のコメントをやめる
au FileType * setlocal formatoptions-=ro
au FileType ruby,eruby,haml,scss,html,yaml,js :set dictionary=/usr/local/share/vim/vim72/syntax/ruby.vim nowrap tabstop=2 shiftwidth=2 expandtab
au FileType tf,javascript :set nowrap tabstop=2 shiftwidth=2 expandtab
" nopasteのあとにno pasteにしてくれる
au InsertLeave * set nopaste

function! InsertTabWrapper()
        let col = col('.') - 1
        if !col || getline('.')[col - 1] !~ '\k'
                return "\<TAB>"
        else
                if pumvisible()
                        return "\<C-N>"
                else
                        return "\<C-N>\<C-P>"
                end
        endif
endfunction
" Remap the tab key to select action with InsertTabWrapper
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
" }}} Autocompletion using the TAB key

hi Pmenu        ctermfg=Black ctermbg=Grey
hi PmenuSel     ctermbg=Red
hi PmenuSbar    ctermbg=Cyan

" insert mode cursor move
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>
nnoremap <Tab>  gt
nnoremap <silent> <C-h> :tabprevious<CR>
nnoremap <silent> <C-l> :tabnext<CR>

" 検索時に画面の真ん中に表示してくれる
nmap n nzz
nmap N Nzz

" remove highlight
nnoremap <ESC><ESC> :nohlsearch<CR>

" eol space
hi WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
au BufWinEnter * match WhitespaceEOL /\s\+$/
au WinEnter * match WhitespaceEOL /\s\+$/

" utf-8 only
hi ZSpace cterm=underline ctermfg=red
match ZSpace /　/

" Unite
" 入力モードで開始する
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
"nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
"nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
"nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
"nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
"nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>

" Yank
nmap ,y :YRShow<CR>
"set clipboard+=unnamedplus,unnamed

" undo履歴を表示する。? でヘルプを表示
" undotree.vim
" http://vimblog.com/blog/2012/09/02/undotree-dot-vim-display-your-undo-history-in-a-graph/
" https://github.com/r1chelt/dotfiles/blob/master/.vimrc
nmap <Leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 'topleft'
let g:undotree_SplitWidth = 35
let g:undotree_diffAutoOpen = 1
let g:undotree_diffpanelHeight = 25
let g:undotree_RelativeTimestamp = 1
let g:undotree_TreeNodeShape = '*'
let g:undotree_HighlightChangedText = 1
let g:undotree_HighlightSyntax = "UnderLined"
