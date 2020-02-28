" Settings
:set number
:set tabstop=4
:set encoding=utf-8
:set virtualedit=onemore
:set backupdir=~/.cache/vim/tmp//,.
:set directory=~/.cache/vim/tmp//,.

" Key remappings
:noremap <expr> <end> (col('$')>1?"\<lt>end>\<lt>right>":'')
