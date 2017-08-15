call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'morhetz/gruvbox'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'fatih/vim-go'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'nsf/gocode', { 'rtp': 'vim',
  \ 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

call plug#end()

nmap <F2> :NERDTreeToggle<CR>

let mapleader="\<SPACE>"
au FileType go nmap <F8> :TagbarToggle<CR>
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>i <Plug>(go-info)

set rtp+=$GOPATH/src/github.com/golang/lint/misc/vim
autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" To conceal snippet markers
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let g:neosnippet#snippets_directory='~/.vim/plugged/vim-go/gosnippets/snippets,~/mysnippets'

" colorscheme gruvbox
set background=dark    " Setting dark mode
set nu
set tabstop=4
set shiftwidth=4

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:go_fmt_command = "goimports"                                                                                                                                            
                                                                                                                                                                              
au FileType json set conceallevel=0                                                                                                                                           
nnoremap <F3> :set hlsearch!<CR>
