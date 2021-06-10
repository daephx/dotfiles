" Settings
set backupdir=~/.cache/vim/tmp//,.
set directory=~/.cache/vim/tmp//,.
set encoding=utf-8
set expandtab
set hidden
set ignorecase
set number
set tabstop=4
set virtualedit=onemore

" Key remappings
:noremap <expr> <end> (col('$')>1?"\<lt>end>\<lt>right>":'')

" colorscheme molokai

set viminfo+=n~/.config/vim/.viminfo
