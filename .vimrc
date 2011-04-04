set history=20
set ruler
set autoindent
set backspace=2
set laststatus=2
set showmatch
set showmode
set tabstop=2
set shiftwidth=2
set expandtab
set listchars=tab:>-
set list

set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8
"set fileencodings=utf-8,iso-2022-jp,utf-8
"set fenc=utf-8
"set enc=utf-8
set fileformats=unix,dos,mac

syntax on

"set statusline=%<%f¥ %{'['.(&fenc!=''?&fenc:&enc).']'}%=%l,%c¥ ¥
"set statusline=%<%f¥ %{'['.(&fenc!=''?&fenc:&enc).']'}[%{&ff}]%=[ROW=%l/%L],[COL=%c]¥ ¥
set statusline=%<%f\ %{'['.(&fenc!=''?&fenc:&enc).']'}[TYPE=%{&ff}]%=[ROW=%l/%L],[COL=%c]

autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" 横カーソルのハイライト
set cursorline

colorscheme delek
