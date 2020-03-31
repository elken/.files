" elken's .vimrc
" Some snippets courtesy of Steve Losh, Tim Pope, Drew Neil, and random junk fom vim wiki

" Preamble                                                                      {{{               
" Set hostname
let g:hostname = system('echo -n $(hostname)')

" Set vim dir (neovim uses xdg now)
let g:vim_dir = "/etc/xdg/nvim/"

" Install vim-plug if it's missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
set nocompatible
" }}}
" Basic options                                                                 {{{
" Pretty self-explanatory

set regexpengine=2
set nocursorbind
set noscrollbind
set cmdheight=2
set noshowmode
set ambiwidth=single
set modelines=0
set autoindent
set showcmd
set hidden
set visualbell
set ttyfast
set ruler
set backspace=indent,eol,start
set backspace=2
" Setting both causes hybrid lines
set number
set relativenumber
set laststatus=2
set history=1000
set undofile
set undoreload=10000
set lazyredraw
set matchtime=3
set showbreak=↪
set splitbelow
set splitright
set autoread
set shiftround
set title
set linebreak
set dictionary=/usr/share/dict/words
set spellfile=~/.vim/custom-dictionary.utf-8.add
set write


" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

" Save when losing focus
au FocusLost * :silent! wall

" Resize splits when the window is resized
au VimResized * :wincmd =

" Leader
let mapleader = ","
let maplocalleader = "\\"

" cpoptions+=J, dammit                                                          {{{

" Something occasionally removes this.  If I manage to find it I'm going to
" comment out the line and replace all its characters with 'FUCK'.
augroup twospace
    au!
    au BufRead * :set cpoptions+=J
augroup END

" }}}
" Wildmenu completion                                                           {{{

set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

set wildignore+=*.orig                           " Merge resolution files

" Clojure/Leiningen
set wildignore+=classes
set wildignore+=lib

" }}}
" Line Return                                                                   {{{

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }}}
" Tabs, spaces, wrapping                                                        {{{

set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=80
set formatoptions=qrn1

" }}}
" Backups                                                                       {{{

set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}

" }}}
" Vim-plug                                                                      {{{
call plug#begin("~/.vim/bundle")
" Build functions                                                               {{{
function! BuildYCM(info)
    if a:info.status == 'installed' || a:info.force
        !./install.py --clang-completer 
    endif
endfunction

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    !cargo build --release
    UpdateRemotePlugins
  endif
endfunction
" }}}
" Options {{{
let g:plug_window = "bel new"
let g:plug_quit = "Q"
"}}}

Plug 'airblade/vim-gitgutter' 
Plug 'benekastah/neomake'
Plug 'vim-airline/vim-airline-themes' 
Plug 'bling/vim-bufferline' 
Plug 'chrisbra/Colorizer'
Plug 'chrisbra/NrrwRgn' 
Plug 'chrisbra/unicode.vim'
Plug 'chrisbra/vim-airline', { 'branch': 'feedkeys'}
Plug 'critiqjo/lldb.nvim'
Plug 'critiqjo/vim-autoclose'
Plug 'dhruvasagar/vim-table-mode'
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'junegunn/goyo.vim' 
Plug 'junegunn/rainbow_parentheses.vim' 
Plug 'junegunn/vim-easy-align'
Plug 'godlygeek/tabular'
Plug 'ianks/gruvbox'
Plug 'kopischke/unite-spell-suggest'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-startify' 
Plug 'moll/vim-bbye' 
Plug 'nvie/vim-flake8'
Plug 'plasticboy/vim-markdown'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic' 
Plug 'Shougo/echodoc.vim' 
Plug 'Shougo/unite.vim' 
Plug 'Shougo/vimproc' , { 'do': 'make'}
Plug 'simnalamburt/vim-mundo'
Plug 'terryma/vim-multiple-cursors' 
Plug 'tell-k/vim-autopep8'
Plug 'tmhedberg/SimpylFold'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary' 
Plug 'tpope/vim-dispatch' 
Plug 'tpope/vim-endwise' 
Plug 'tpope/vim-eunuch' 
Plug 'tpope/vim-fugitive' 
Plug 'tpope/vim-obsession' 
Plug 'tpope/vim-repeat' 
Plug 'tpope/vim-speeddating' 
Plug 'tpope/vim-surround' 
Plug 'tpope/vim-vinegar' 
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'vhdirk/vim-cmake', { 'for': 'cpp' }
Plug 'vim-scripts/a.vim'
Plug 'vim-scripts/auto_autoread'
Plug 'vim-scripts/greplace.vim' 
Plug 'vim-scripts/indentpython.vim' 
Plug 'vim-scripts/SyntaxRange' 
Plug 'vim-scripts/utl.vim' 
Plug 'wesQ3/vim-windowswap' 
Plug 'Xuyuanp/nerdtree-git-plugin' 

call plug#end()

" }}}
" Color scheme and GUI                                                          {{{

set background=dark
let g:solarized_termcolors=256
set t_co=256
let g:enable_bold_font = 1
colorscheme gruvbox
if has('gui_running')
    set guifont=Hasklig\ 8
    set go-=m
    set go-=T
    set go-=r
    set go-=L
    set lines=999
    set columns=999

    nnoremap <C-v> "+gP
    inoremap <C-v> <Esc><C-v>a
    vnoremap <C-c> "+y
endif

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}
" Plugin settings                                                               {{{
" autopep8                                                                      {{{
let g:autopep8_aggressive = 1
let g:autopep8_disable_show_diff = 1
" }}}
" color_highlight                                                               {{{
nnoremap <F7> :ColorHighlight<CR>
" }}}
" Fugitive                                                                      {{{

nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gco :Gcheckout<cr>
nnoremap <leader>gci :Gcommit<cr>
nnoremap <leader>gm :Gmove<cr>
nnoremap <leader>gr :Gremove<cr>
nnoremap <leader>gp :Git push<cr>

augroup ft_fugitive
    au!

    au BufNewFile,BufRead .git/index setlocal nolist
augroup END

" Hub
nnoremap <leader>H :Gbrowse<cr>
vnoremap <leader>H :Gbrowse<cr>

" }}}
" Goyo                                                                          {{{
nnoremap <leader>gg :Goyo<CR>
let g:goyo_width = 150
" }}}
" Limelight                                                                     {{{
if &background == "dark"
    let g:limelight_conceal_ctermbg = '240'
    let g:limelight_conceal_ctermfg = '240'
else
    let g:limelight_conceal_ctermbg = 'grey'
    let g:limelight_conceal_ctermfg = 'grey'
endif
nnoremap <leader>l :Limelight!!<CR>
" }}}
" Markdown composer                                                             {{{
let g:markdown_composer_browser = "firefox"
" }}}
" Mundo                                                                         {{{

nnoremap <F5> :GundoToggle<CR>

" }}}
" NERDTree                                                                      {{{
nnoremap <F2> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}
" Startify                                                                      {{{

let g:startify_files_number = 5
let g:startify_enable_special = 0
let g:startify_session_dir = g:vim_dir . 'sessions'

let g:startify_custom_header = map(split(system('fortune -s | cowsay'), '\n'), '"   ". v:val') + ['','']  
let g:startify_custom_footer = ['',''] + map(split(system('toilet -F border -f future Be NEOVIMproved!'), '\n'), '"   ". v:val') + ['','']

let g:startify_skiplist = [
            \ 'COMMIT_EDITMSG',
            \ $VIMRUNTIME .'/doc',
            \ 'bundle/.*/doc',
            \ '.git/index',
            \ ]

let g:startify_bookmarks = [ 
            \ g:vim_dir . 'init.vim', 
            \ '~/.zshrc',
            \ '~/.dwm/config.h',
            \ '~/.st/config.h'
            \ ]
" }}}
" Syntastic                                                                     {{{
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
" }}}
" SimpylFold                                                                    {{{
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_docstring = 0
" }}}
" Tagbar                                                                        {{{
nnoremap <F9> :TagbarToggle<CR>
" }}}
" Unite                                                                         {{{
let g:unite_source_history_yank_enable = 1
nnoremap <leader>f :Unite file_rec/async<cr>
nnoremap <leader>/ :UniteWithCurrentDir grep<cr>
nnoremap <leader>y :Unite history/yank<cr>
nnoremap <leader>b :Unite -quick-match buffer<cr>

"}}}
" vim-airline                                                                   {{{
" GitGutter stuff
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 0
let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']

" Syntastic
let g:airline#extensions#syntastic#enabled = 1

" Fugitive
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''

" Tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tab_nr = 1

" Other crap
let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0
" }}}
" vim-easy-align                                                                {{{
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}
" vim-gitgutter                                                                 {{{
let g:gitgutter_sign_column_always = 0
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_removed = '--'
let g:gitgutter_sign_removed_first_line = '@@'
let g:gitgutter_sign_modified_removed = 'mr'

" }}}
" vim-session                                                                   {{{
let g:session_autosave = 'no'
let g:session_autoload = 'no'
" }}}
" Windowswap                                                                    {{{
nnoremap <leader>mw Windowswap#EasyWindowSwap
" }}}
" YouCompleteMe                                                                 {{{
 
"let g:ycm_key_list_select_completion=[]
"let g:ycm_key_list_previous_completion=[]

nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_register_as_syntastic_checker = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_server_log_level = "debug"
let g:ycm_confirm_extra_conf = 0
"}}}  
" }}}
" Convenience mappings                                                          {{{

" Convert a URL to vim-plug syntax
nnoremap <leader>up 3cf/Plug '<Esc>$a'<Esc>

" Fuck you in the dick :bdelete
nnoremap <Leader>q :Bdelete<CR>
nnoremap <C-x> :Bdelete<CR>:q<CR>

" Source my vimrc (Remember coders are lazy)
nnoremap <F1> :w<CR>:so %<CR>
nnoremap <F3> :PlugInstall<CR>
nnoremap <S-F3> :PlugClean<CR>

" Quick build
nnoremap <F11> :CMake<CR>:Make<CR>

" Fuck XOFF
noremap  <C-s> :w<cr>    
noremap  <C-q> :w<cr>:Bdelete<cr>

" Stop it, hash key.
inoremap # X<BS>#

" Sort lines
nnoremap <leader>s vip:!sort<cr>
vnoremap <leader>s :!sort<cr>

" Iter through listed buffers
" Need to find a more sane way to do this
nnoremap <leader>] :bnext<CR>
nnoremap <leader>[ :bprevious<CR>

" Another way to iter through buffers
" May migrate to this if I like it
nnoremap <C-b> :buffers<CR>:buffer<Space>

" I constantly hit "u" in visual mode when I mean to "y". Use "gu" for those rare occasions.
" From https://github.com/henrik/dotfiles/blob/master/vim/config/mappings.vim
vnoremap u <nop>
vnoremap gu u

" Rebuild Ctags (mnemonic RC -> CR -> <cr>)
nnoremap <leader><cr> :silent !myctags<cr>:redraw!<cr>

" Clean trailing whitespace
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z:nohl<cr>

" Select entire buffer
nnoremap vaa ggvGg_
nnoremap Vaa ggVG

" "Uppercase word" mapping.
inoremap <C-u> <esc>mzg~iw`za

" Formatting, TextMate-style
nnoremap <leader>Q gqip
vnoremap <leader>Q gq

" Reformat line.
" I never use l as a macro register anyway.
nnoremap ql gqq

" Easier linewise reselection of what you just pasted.
nnoremap <leader>V V`]

" Indent/dedent/autoindent what you just pasted.
nnoremap <lt>> V`]<
nnoremap ><lt> V`]>
nnoremap =- V`]=

" Keep the cursor in place while joining lines
nnoremap <leader>j mzJ`z

" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" Source
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Marks and Quotes
noremap ' `
noremap ` <C-^>

" Sudo to write
cnoremap w!! SudoWrite
cnoremap e!! SudoEdit

" Typos
command! -bang E e<bang>
command! -bang Q q<bang>
command! -bang W w<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>

" I suck at typing.
vnoremap - =

" Toggle paste
" For some reason pastetoggle doesn't redraw the screen (thus the status bar
" doesn't change) while :set paste! does, so I use that instead.
" set pastetoggle=<F6>
nnoremap <F6> :set paste!<cr>

" Toggle [i]nvisible characters
nnoremap <leader>i :set list!<cr>

" Unfuck my screen
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

" Cd to current open file
nnoremap <leader>cd :cd %:p:h<cr>

" Easy filetype switching                                                       {{{

nnoremap _d   :set ft=diff<CR>
nnoremap _c   :set ft=c<CR>
nnoremap _cpp :set ft=c++<CR>
nnoremap _sh  :set ft=sh<CR>
" }}}

" }}}
" Quick editing                                                                 {{{

nnoremap <leader>ev :vsplit ~/.vimrc<cr>
nnoremap <leader>ey :vsplit ~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py<cr>
nnoremap <leader>ez :vsplit ~/.zshrc<CR>
nnoremap <leader>ew :vsplit ~/notes/index.md<CR>
" }}}
" Searching and movement                                                        {{{

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

set virtualedit+=block

noremap <silent> <leader><space> :noh<cr>:let @/=""<cr>:echo "Search cleared."<cr>

runtime macros/matchit.vim
map <tab> %

" Made D behave
nnoremap D d$

" Don't move on *
nnoremap * *<c-o>

" Jumping to tags.
"
" Basically, <c-]> jumps to tags (like normal) and <c-\> opens the tag in a new
" split instead.
"
" Both of them will align the destination line to the upper middle part of the
" screen.  Both will pulse the cursor line so you can see where the hell you
" are.  <c-\> will also fold everything in the buffer and then unfold just
" enough for you to see the destination line.
nnoremap <c-]> <c-]>mzzvzz15<c-e>`z:Pulse<cr>
nnoremap <c-\> <c-w>v<c-]>mzzMzvzz15<c-e>`z:Pulse<cr>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" Easier to type, and I never use the default behavior.
noremap H ^
noremap J L
noremap K H
noremap L $
vnoremap L g_

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" gi already moves to "last place you exited insert mode", so we'll map gI to
" something similar: move to last change
nnoremap gI `.

" Fix linewise visual selection of various text objects
nnoremap VV V
nnoremap Vit vitVkoj
nnoremap Vat vatV
nnoremap Vab vabV
nnoremap VaB vaBV

" Directional Keys                                                              {{{

" It's 2013.
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Easy buffer navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap <leader>v <C-w>v

" Pinky saving strats
nnoremap ; :
nnoremap : ;

" }}}
" Visual Mode */# from Scrooloose                                               {{{

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" }}}
" List navigation                                                               {{{

nnoremap <left>  :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz
nnoremap <up>    :lprev<cr>zvzz
nnoremap <down>  :lnext<cr>zvzz

" }}}

" }}}
" Folding                                                                       {{{

set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

function! MyFoldText()                                                          "{{{
    " let &l:fillchars = substitute(&l:fillchars,',\?fold:.','','gi')
    let l:numwidth = 8
    let l:foldtext = '| '.(v:foldend-v:foldstart).' lines folded'
    let l:endofline = &textwidth+strlen(l:foldtext)
    let l:linetext = strpart(getline(v:foldstart),0,l:endofline-strlen(l:foldtext))
    let l:align = l:endofline-strlen(l:linetext)
    setlocal fillchars=" "
    return printf('%s%*s', l:linetext, l:align, l:foldtext)
  endfunction
"}}}
set foldtext=MyFoldText()

" }}}
" Filetype-specific                                                             {{{
" All                                                                           {{{
    au FileType * RainbowParentheses
    au CursorMovedI * if pumvisible() == 0|pclose|endif
    au InsertLeave * if pumvisible() == 0|pclose|endif

    " Auto chdir because I'm very lazy and easily confused
    set autochdir
    au BufEnter * silent! lcd %:p:h

" }}}
" C                                                                             {{{

augroup ft_c
    au!
    au FileType c setlocal foldmethod=marker foldmarker={,}
    au BufWritePost c Neomake
augroup END

" }}}
" C++                                                                           {{{

augroup ft_cpp
    au!
    au FileType cpp setlocal foldmethod=syntax foldmarker={,}
    au BufWritePost cpp Neomake
augroup END

" }}}
" Firefox                                                                       {{{

augroup ft_firefox
    au!
    au BufRead,BufNewFile ~/Library/Caches/*.html setlocal buftype=nofile
augroup END

" }}}
" Haskell                                                                       {{{

augroup ft_haskell
    au!
    au BufEnter *.hs compiler ghc
augroup END

" }}}
" Makefle                                                                       {{{
autocmd FileType make setlocal noexpandtab
"}}}
" Mail                                                                          {{{

augroup ft_mail
    au!

    au Filetype mail setlocal spell
augroup END

" }}}
" Markdown                                                                      {{{

augroup ft_markdown
    au!

    au BufNewFile,BufRead *.m*down setlocal filetype=markdown foldlevel=1
    au BufNewFile,BufRead *.md setlocal filetype=markdown foldlevel=1

    au FileType markdown nnoremap <buffer> <F10> :!pandoc -f markdown --toc % -o %<.pdf<CR>
    au FileType markdown nnoremap <buffer> <S-F10> :! xdg-open %<.pdf 2>&1> /dev/null &<CR><CR>
    inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

augroup END

" }}}
" Mutt                                                                          {{{

augroup ft_muttrc
    au!

    au BufRead,BufNewFile *.muttrc set ft=muttrc

    au FileType muttrc setlocal foldmethod=marker foldmarker={{{,}}}
augroup END

" }}}
" Org                                                                           {{{

augroup ft_org
    au! 


augroup END
"}}}
" Python                                                                        {{{

augroup ft_python
    au!

    au FileType python setlocal define=^\s*\\(def\\\\|class\\)
    au FileType man nnoremap <buffer> <cr> :q<cr>

    " Jesus tapdancing Christ, built-in Python syntax, you couldn't let me
    " override this in a normal way, could you?
    au FileType python if exists("python_space_error_highlight") | unlet python_space_error_highlight | endif

    au FileType python iabbrev <buffer> afo assert False, "Okay"

    set textwidth=80
    set formatoptions=cq
    " SimpylFold
    au BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
    au BufWinLeave *.py setlocal foldexpr< foldmethod<
    " Make virtualenvs work
    py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
    au BufWritePost *.py call Flake8() 
    au BufWritePost *.py call Autopep8()

augroup END

" }}}
" Shell                                                                         {{{

augroup ft_shell
    au FileType sh set foldmethod=marker
augroup END
" }}}
" Standard In                                                                   {{{

augroup ft_stdin
    au!

    " Treat buffers from stdin (e.g.: echo foo | vim -) as scratch.
    au StdinReadPost * :set buftype=nofile
augroup END

" }}}
" TeX                                                                           {{{
let g:tex_flavor='latex'

" }}}
" Vim                                                                           {{{

augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}
" }}}
" Text objects                                                                  {{{
" Next and Last                                                                 {{{
"
" Motion for "next/last object".  "Last" here means "previous", not "final".
" Unfortunately the "p" motion was already taken for paragraphs.
"
" Next acts on the next object of the given type, last acts on the previous
" object of the given type.  These don't necessarily have to be in the current
" line.
"
" Currently works for (, [, {, and their shortcuts b, r, B. 
"
" Next kind of works for ' and " as long as there are no escaped versions of
" them in the string (TODO: fix that).  Last is currently broken for quotes
" (TODO: fix that).
"
" Some examples (C marks cursor positions, V means visually selected):
"
" din'  -> delete in next single quotes                foo = bar('spam')
"                                                      C
"                                                      foo = bar('')
"                                                                C
"
" canb  -> change around next parens                   foo = bar('spam')
"                                                      C
"                                                      foo = bar
"                                                               C
"
" vin"  -> select inside next double quotes            print "hello ", name
"                                                       C
"                                                      print "hello ", name
"                                                             VVVVVV

onoremap an :<c-u>call <SID>NextTextObject('a', '/')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', '/')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', '/')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', '/')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', '?')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', '?')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', '?')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', '?')<cr>


function! s:NextTextObject(motion, dir)
    let c = nr2char(getchar())
    let d = ''

    if c ==# "b" || c ==# "(" || c ==# ")"
        let c = "("
    elseif c ==# "B" || c ==# "{" || c ==# "}"
        let c = "{"
    elseif c ==# "r" || c ==# "[" || c ==# "]"
        let c = "["
    elseif c ==# "'"
        let c = "'"
    elseif c ==# '"'
        let c = '"'
    else
        return
    endif

    " Find the next opening-whatever.
    execute "normal! " . a:dir . c . "\<cr>"

    if a:motion ==# 'a'
        " If we're doing an 'around' method, we just need to select around it
        " and we can bail out to Vim.
        execute "normal! va" . c
    else
        " Otherwise we're looking at an 'inside' motion.  Unfortunately these
        " get tricky when you're dealing with an empty set of delimiters because
        " Vim does the wrong thing when you say vi(.

        let open = ''
        let close = ''

        if c ==# "(" 
            let open = "("
            let close = ")"
        elseif c ==# "{"
            let open = "{"
            let close = "}"
        elseif c ==# "["
            let open = "\\["
            let close = "\\]"
        elseif c ==# "'"
            let open = "'"
            let close = "'"
        elseif c ==# '"'
            let open = '"'
            let close = '"'
        endif

        " We'll start at the current delimiter.
        let start_pos = getpos('.')
        let start_l = start_pos[1]
        let start_c = start_pos[2]

        " Then we'll find it's matching end delimiter.
        if c ==# "'" || c ==# '"'
            " searchpairpos() doesn't work for quotes, because fuck me.
            let end_pos = searchpos(open)
        else
            let end_pos = searchpairpos(open, '', close)
        endif

        let end_l = end_pos[0]
        let end_c = end_pos[1]

        call setpos('.', start_pos)

        if start_l == end_l && start_c == (end_c - 1)
            " We're in an empty set of delimiters.  We'll append an "x"
            " character and select that so most Vim commands will do something
            " sane.  v is gonna be weird, and so is y.  Oh well.
            execute "normal! ax\<esc>\<left>"
            execute "normal! vi" . c
        elseif start_l == end_l && start_c == (end_c - 2)
            " We're on a set of delimiters that contain a single, non-newline
            " character.  We can just select that and we're done.
            execute "normal! vi" . c
        else
            " Otherwise these delimiters contain something.  But we're still not
            " sure Vim's gonna work, because if they contain nothing but
            " newlines Vim still does the wrong thing.  So we'll manually select
            " the guts ourselves.
            let whichwrap = &whichwrap
            set whichwrap+=h,l

            execute "normal! va" . c . "hol"

            let &whichwrap = whichwrap
        endif
    endif
endfunction

" }}}
" }}}
" nvim stuff                                                                    {{{
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
    nnoremap <C-t>s :sp term://zsh<CR>a
    nnoremap <C-t>v :vsp term://zsh<CR>a
endif
"}}}
" Mini-plugins                                                                  {{{
" Nyan! {{{

function! NyanMe() " {{{
    hi NyanFur             guifg=#BBBBBB
    hi NyanPoptartEdge     guifg=#ffd0ac
    hi NyanPoptartFrosting guifg=#fd3699 guibg=#fe98ff
    hi NyanRainbow1        guifg=#6831f8
    hi NyanRainbow2        guifg=#0099fc
    hi NyanRainbow3        guifg=#3cfa04
    hi NyanRainbow4        guifg=#fdfe00
    hi NyanRainbow5        guifg=#fc9d00
    hi NyanRainbow6        guifg=#fe0000


    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl None
    echo ""

    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanFur
    echon "╰"
    echohl NyanPoptartEdge
    echon "⟨"
    echohl NyanPoptartFrosting
    echon "⣮⣯⡿"
    echohl NyanPoptartEdge
    echon "⟩"
    echohl NyanFur
    echon "⩾^ω^⩽"
    echohl None
    echo ""

    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl NyanRainbow1
    echon "≈"
    echohl NyanRainbow2
    echon "≋"
    echohl NyanRainbow3
    echon "≈"
    echohl NyanRainbow4
    echon "≋"
    echohl NyanRainbow5
    echon "≈"
    echohl NyanRainbow6
    echon "≋"
    echohl None
    echon " "
    echohl NyanFur
    echon "”   ‟"
    echohl None

    sleep 1
    redraw
    echo " "
    echo " "
    echo "Noms?"
    redraw
endfunction " }}}
command! NyanMe call NyanMe()

" }}}
" }}}
" TODO (At some point I may invest in a plugin for this)                        {{{
" - Use Abolish
" - Plan my awesome keymap plugin thing
" - Devise a nice way to handle everything (projects, settings, etc)
" It's been some months since I looked at this and I've still made 0 progress
" Sometimes I amaze myself
"}}}
