filetype plugin indent on
set nocompatible
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
set number
set statusline=%<%f\ %{'['.(&fenc!=''?&fenc:&enc).']'}[TYPE=%{&ff}]%=[ROW=%l/%L],[COL=%c]

" 前回のカーソル位置に移動
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |exe "normal g`\"" | endif
" 改行時のコメントをやめる
au FileType * setlocal formatoptions-=ro
au FileType ruby,eruby,haml,scss,html,yaml,js :set dictionary=/usr/local/share/vim/vim72/syntax/ruby.vim nowrap tabstop=2 shiftwidth=2 expandtab
au FileType tf,javascript :set nowrap tabstop=2 shiftwidth=2 expandtab
au FileType json :set nowrap tabstop=2 shiftwidth=2 expandtab
au FileType go :set tabstop=4 shiftwidth=4
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

hi Pmenu        ctermfg=Black ctermbg=Grey
hi PmenuSel     ctermbg=Red
hi PmenuSbar    ctermbg=Cyan

inoremap <tab> <c-r>=InsertTabWrapper()<cr>
" insert mode cursor move
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>
" tab
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

" 全角スペース
autocmd Colorscheme * highlight FullWidthSpace ctermbg=red
autocmd VimEnter * match FullWidthSpace /　/
colorscheme koehler
syntax enable
