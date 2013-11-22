""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Last Change:2012-03-04 20:08
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Generel
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vim中当前文件的字符编码方式
"set fileencoding=ucs-bom

if executable('/bin/bash')
  set shell=/bin/bash
endif

set nobinary
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileformats=unix,dos,mac

set nogdefault

set expandtab

set autowrite
set autochdir
set nolist

set clipboard+=unnamed              " update system clipboard

set foldlevelstart=3

set nonumber
set norelativenumber
set numberwidth=2
set ruler
set showmode

set showmatch
set matchtime=2
set matchpairs=(:),{:},[:],<:>

set whichwrap =b,s,<,>,[,]

set smartindent
set cindent
set cinoptions=g0,N-s

set colorcolumn=

if has('mouse')
    set mouse=a
endif

set path=.,/usr/include,/opt/local/include,,

"防止界面乱码（中文情况下）
set langmenu=zh_cn.utf-8

"状态栏显示设置
set laststatus=2
set statusline=
set statusline+=%<%f
set statusline+=%h%r%w
set statusline+=%1*%m%0*
set statusline+=%=
set statusline+=[
if v:version >= 600
set statusline+=%{strlen(&ft)?&ft:'none'},
set statusline+=%{&fileencoding},
endif
set statusline+=%{&fileformat}
set statusline+=]
if filereadable(expand("$VIM/vimfiles/plugin/vimbuddy.vim"))
set statusline+=\ %{VimBuddy()}
endif
set statusline+=\ [%n]
set statusline+=%-14(%l,%c/%V%)
set statusline+='\\x%02B'
set statusline+=\ %o/%p%%

"自动进入文件所在路径

"配色方案
"set background=dark
colorscheme default

"""""""""""""""""""""""""""""""""""""""""""""""""""
" Programming
"""""""""""""""""""""""""""""""""""""""""""""""""""
"设置粘贴模式
"set paste

"折叠设置
"set foldmethod=marker
"set foldlevel=3
"set foldcolumn=4

"保存文件格式的顺序

"""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件
"""""""""""""""""""""""""""""""""""""""""""""""""""

"netrw设置
let g:netrw_winsize=30
let g:netrw_liststyle=1
let g:netrw_timefmt='%Y-%m-%d %H:%M:%S'

"taglist
let Tlist_Ctags_Cmd='ctags'
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_Use_Right_Window=1
let Tlist_Enable_Fold_Column=1

"javascript语法高亮脚本的设置
let g:javascript_enable_domhtmlcss=1

"vimwiki设置
let g:vimwiki_use_mouse = 1
let g:vimwiki_CJK_length = 1
let g:vimwiki_list = [{'path':'d:/My Dropbox/vimwiki/',
\'path_html':'d:/My Dropbox/vimwiki/html/',
\'html_header':'d:/My Dropbox/vimwiki/template/header.tpl',
\'html_footer':'d:/My Dropbox/vimwiki/template/footer.tpl',}
\]

let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler_options = ' -std=c++0x'
let g:syntastic_cpp_include_dirs = [ '/usr/include', '/usr/local/include' ]
let g:syntastic_cpp_config_file = '.clang_complete'

"lua-support设置

"Pyclewn
if filereadable('/opt/local/bin/ggdb')
  let pyclewn_args='-p ggdb'
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""
" function defines
"""""""""""""""""""""""""""""""""""""""""""""""""""

function! CleanupBuffer(keep)
	if (&bin > 0)
		return
	endif
	silent! %s/\s\+$//ge
	let lnum = line(".")
	let lastline = line("$")
	let n = lastline
	while (1)
		let line = getline(n)
		if (!empty(line))
			break
		endif
		let n = n - 1
	endwhile
	let start = n+1+a:keep
	if (start < lastline)
		execute n+1+a:keep . "," . lastline . "d"
	endif
	exec "normal " . lnum . "G"
endfunction

"读取当前单词的man page
function! ReadMan()
    let s:man_word = expand('<cword>')
    :wincmd n
    :setlocal buftype=nofile
    :setlocal bufhidden=hide
    :setlocal noswapfile
    :setlocal nobuflisted
    :exe ":r!man " . s:man_word . " | col -b"
    :goto
    :delete
endfun
"command -nargs=0 -range ManInGnomeTerm !gnome-terminal --execute bash -i -c 'man $(if [ $(( <line2> - <line1> + 1 )) -ne 1 ]; then echo $(( <line2> - <line1> + 1 )); fi) <cword> || (echo "man lookup failed" 1>&2 && read)'

function! LoadCscope()
    let db = findfile("GTAGS", ".;")
    if (empty(db))
        let db = findfile("cscope.out", ".;")
        if (empty(db))
            return
        endif
        set cscopeprg=cscope
        let path = fnamemodify(db, ":p:h")
        set nocscopeverbose " suppress 'duplicate connection' error"
        exe "cs add " . db . " " . path
        set cscopeverbose
    else
        set cscopeprg=gtags-cscope
        let path = fnamemodify(db, ":p:h")
        let cwd = getcwd()
        exe "cd " . path
        set nocscopeverbose " suppress 'duplicate connection' error"
        exe "cs add " . db . " " . path
        set cscopeverbose
        exe "cd " . cwd
    endif
endfunction

function! LoadVimrcLocal()
    let file = findfile(".vimrc.local", ".;")
    if (! empty(file)) && filereadable(file)
        exec "source " . file
    endif
endfunction

function! LoadLocalPath(file)
    let config = findfile(a:file, '.;')
    if (! empty(config))
        exec 'setlocal path=' . &path
        let filepath = substitute(fnamemodify(config, ':p:h'), '\', '/', 'g')
        let lines = map(readfile(config),
                    \ 'substitute(v:val, ''\'', ''/'', ''g'')')
        for line in lines
            let matches = matchlist(line, '^\s*-I\s*\(\S\+\)')
            if matches != [] && matches[1] != ''
                " this one looks like an absolute path
                if match(matches[1], '^\%(/\|\a:\)') != -1
                    exec 'setlocal path+=' . matches[1]
                else
                    exec 'setlocal path+=' . filepath . '/' . matches[1]
                endif
            endif
        endfor
    endif
endfunction

function! UpdateTags()
    let db = findfile("GTAGS", ".;")
    if (empty(db))
        let db = findfile("cscope.out", ".;")
        if (empty(db))
            return
        endif
    endif
    let path = fnamemodify(db, ":p:h")
    let filename = expand('%:p')
    silent "!update_tags " . path . " " . filename
endfunction

function! StartPyclewn()
    Pyclewn
    Cinferiortty
    Cmapkeys
endfunction

function! SwitchCppHeader()
    let filename = bufname("")
    if filename =~ '\.\(h\|hpp\)$'
        let filedir = substitute(filename, '\.\(h\|hpp\)$', '', 'g')
        if filereadable(filedir . '.cpp')
            exec "edit " . filedir . '.cpp'
        elseif filereadable(filedir . '.cc')
            exec "edit " . filedir . '.cc'
        elseif filereadable(filedir . '.c')
            exec "edit " . filedir . '.c'
        endif
    elseif filename =~ '\.\(c\|cc\|cpp\)$'
        let filedir = substitute(filename, '\.\(c\|cc\|cpp\)$', '', 'g')
        if filereadable(filedir . '.h')
            exec "edit " . filedir . '.h'
        elseif filereadable(filedir . '.hpp')
            exec "edit " . filedir . '.hpp'
        endif
    endif
endfunction

function! UpdateTagsFile()
    silent !ctags -R --fields=+ianS --extra=+q
endfunction

function! DeleteTagsFile()
    silent !rm -f tags
endfunction

function! SetupGTAGSROOT()

endfunction

function! FindAndMake()
    let file = findfile("Makefile", ".;")
    if (empty(file))
		echo 'Cannot find Makefile.'
		return
    endif
    let path = fnamemodify(file, ":p:h")
	exec "cd " . path
	exec "make"
endfunction

command! Make :call FindAndMake()

"""""""""""""""""""""""""""""""""""""""""""""""""""
" autocmd
"""""""""""""""""""""""""""""""""""""""""""""""""""

if has("autocmd")
augroup vimrcEx
au!

augroup cline
    au!
augroup END

autocmd BufNewFile /* set fileformat=unix

autocmd BufReadPre /* call LoadVimrcLocal()

autocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

autocmd BufEnter /* call LoadCscope()

autocmd BufReadPost *.{cpp,cc,c,hpp,h} set syntax=cpp11

autocmd BufReadPre *.{cpp,cc,c,hpp,h} call LoadLocalPath('.clang_complete')
autocmd BufWritePost *.{cpp,cc,c,hpp,h} call UpdateTags()

autocmd BufNewFile,BufRead [Ss][Cc]ons* set filetype=scons

augroup END

endif " has("autocmd")

"""""""""""""""""""""""""""""""""""""""""""""""""""
" keymaps
"""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <Leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>ft :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>fe :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>ff :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <Leader>fi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <Leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>wfs :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>wfg :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>wfc :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>wft :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>wfe :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>wff :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <Leader>wfi :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <Leader>wfd :scs find d <C-R>=expand("<cword>")<CR><CR>

nmap <Leader>wm :call ReadMan()<CR>

nmap <Leader>ww <C-W><C-W>
nmap <Leader>wh <C-W><C-H>
nmap <Leader>wj <C-W><C-J>
nmap <Leader>wk <C-W><C-K>
nmap <Leader>wl <C-W><C-W>

nmap <Leader>wt :TagbarToggle<CR>
nmap <Leader>wd :NERDTreeToggle<CR>
nmap <Leader>wa :TrinityToggleAll<CR>

nmap <Leader>oh :call SwitchCppHeader()<CR>
nmap <Leader>op :call StartPyclewn()<CR>

"F2(及保存时)处理行尾的空格以及多余空行,F2同时能清除高亮
"autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
map <F2> :w<CR>:call CleanupBuffer(1)<CR>:noh<CR>
nmap <silent> <C-F7> :Sexplore!<cr>
"F6打开或关闭nerd_tree和taglist
"由于nerd_tree和taglist采用了trinity插件打开
"所以具体的设置以trinity.vim为准
nmap <F6> :TrinityToggleTagListAndNERDTree<CR>
nmap <F7> :NERDTreeToggle<CR> "始终在右边显示
nmap <F8> :TagbarToggle<CR>
"F12生成/更新tags文件
nmap <F12> :call UpdateTagsFile()<CR>
"Ctrl + F12删除tags文件
nmap <C-F12> :call DeleteTagsFile()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nnoremap <silent> K :ManInGnomeTerm<CR><CR>

if has("gui_running")

colorscheme clearcolor
set bsdir=buffer

if has("gui_gtk2")
    set guifont=Luxi\ Mono\ 12
elseif has("x11")
    " Also for GTK 1
    set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
elseif has("gui_win32")
    set guifont=Courier\ New:h9
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    "解决consle输出乱码
    language messages zh_CN.utf-8
elseif has("gui_macvim")
    set macmeta
    set guifont=Menlo:h12
    set guifontwide=Microsoft\ Yahei
endif
endif

"读取额外配置

