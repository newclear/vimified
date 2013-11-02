
" _. General {{{
if count(g:vimified_packages, 'general')
    Bundle 'SuperTab-continued.'
    let g:SuperTabDefaultCompletionType = "context"
    let g:SuperTabMappingForward = '<tab>'
    let g:SuperTabMappingBackward = '<s-tab>'
endif
" }}}

" _. Coding {{{
if count(g:vimified_packages, 'coding')
    Bundle 'scrooloose/syntastic'
    let g:syntastic_enable_signs=1
    let g:syntastic_auto_loc_list=1
    let g:syntastic_cpp_check_header = 1
    let g:syntastic_cpp_compiler_options = ' -std=c++0x'
    let g:syntastic_cpp_include_dirs = [ '/usr/include', '/opt/local/include' ]

    Bundle 'better-snipmate-snippet'

    " --
    set cscopeprg=gtags-cscope
    set cscopetag
    set tags=./tags
    set makeprg=mk
endif
" }}}

" _. C++ {{{
if count(g:vimified_packages, 'cpp')
    Bundle 'vim-scripts/c.vim'
    Bundle 'Cpp11-Syntax-Support'
    Bundle 'newclear/vim-pyclewn'

    let g:syntastic_cpp_config_file = '.clang_complete'
endif
" }}}

" _. Clang {{{
if count(g:vimified_packages, 'clang')
    Bundle 'newclear/lh-vim-lib'
    Bundle 'newclear/lh-dev'
    Bundle 'Rip-Rip/clang_complete'
    "let g:clang_periodic_quickfix = 1
    "let g:clang_exec = '"clang'
    "let g:clang_user_options = '2>/dev/null || exit 0"'
    let g:clang_auto_user_options = "path, .clang_complete"
    let g:clang_use_library = 1
    let g:clang_library_path = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib"
    let g:clang_complete_macros = 1
    "let g:clang_complete_patterns = 1

    let g:syntastic_cpp_config_file = '.clang_complete'

    Bundle 'Cpp11-Syntax-Support'
    Bundle 'newclear/vim-pyclewn'
endif
" }}}

" _. Lua {{{
if count(g:vimified_packages, 'lua')
    Bundle 'lua-support'
    let g:Lua_AuthorName    = 'Steven Clear Peng'
    let g:Lua_AuthorRef     = 'Mn'
    let g:Lua_Email         = 'kepeng@gmail.com'
    let g:Lua_Company       = 'NewClear Corporation'

endif
" }}}


" _. Color {{{
if count(g:vimified_packages, 'color')
    Bundle 'colorer-color-scheme'
endif
" }}}


