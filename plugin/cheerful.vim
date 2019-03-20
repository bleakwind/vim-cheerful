" vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4: */
"
" +----------------------------------------------------------------------+
" | $Id: cheerful.vim 2018-04-06 14:28:29Z Bleakwind $                   |
" +----------------------------------------------------------------------+
" | Copyright (c) 2008-2018 Bleakwind(Rick Woo).                         |
" +----------------------------------------------------------------------+
" | This source file is cheerful.vim.                                    |
" | This source file is release under BSD license.                       |
" +----------------------------------------------------------------------+
" | Author: Bleakwind(Rick Woo) <bleakwind@gmail.com>                    |
" +----------------------------------------------------------------------+
"

if &cp || exists('g:cheerful_plugin')
    finish
endif
let b:cheerful_plugin = 1

scriptencoding utf-8

" reopen buffer
if exists('g:cheerful_reopen_enable') && g:cheerful_reopen_enable == 1
    if !exists('g:cheerful_reopen_dir') || g:cheerful_reopen_dir == ""
        let g:cheerful_reopen_file = $HOME."/.vim/cheerful/session_filelist.vim"
    else
        let g:cheerful_reopen_file = g:cheerful_reopen_dir."/session_filelist.vim"
    endif

    function! s:cheerful_reopen_build_cmd()
        autocmd BufEnter,VimLeave * nested call s:cheerful_reopen_build_session()
    endfunction

    function! s:cheerful_reopen_build_session()
        if !isdirectory(g:cheerful_reopen_dir)
            call mkdir(g:cheerful_reopen_dir, 'p', 0777)
        endif
        let buflist = []
        for file in getbufinfo({'buflisted':1})
            if file.name != "" && filereadable(file.name)
                if file.bufnr == bufnr('%')
                    call add(buflist, "c*".file.name)
                else
                    call add(buflist, "x*".file.name)
                endif
            endif
        endfor
        call writefile(buflist, g:cheerful_reopen_file, 'b')
    endfunction

    function! s:cheerful_reopen_restore_session()
        if argc() == 0 && filereadable(g:cheerful_reopen_file)
            let bufcurrent = 0
            let buflist = readfile(g:cheerful_reopen_file)
            for file_list in buflist
                let file_info = split(file_list, '*')
                if exists("file_info[1]") && file_info[1] != "" && filereadable(file_info[1])
                    silent exe "edit ".file_info[1]
                    if file_info[0] == 'c'
                        let bufcurrent = bufnr('%')
                    endif
                endif
            endfor
            if bufcurrent > 0
                silent exe "buffer ".bufcurrent
            endif
        endif
    endfunction

    autocmd VimEnter * nested call s:cheerful_reopen_build_cmd()
    autocmd VimEnter * nested call s:cheerful_reopen_restore_session()
endif

" jump lastplace
if exists('g:cheerful_lasplace_enable') && g:cheerful_lasplace_enable == 1
    function! s:cheerful_lasplace_set()
        if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            exe "normal! g`\""
        endif
    endfunction

    autocmd BufReadPost * nested call s:cheerful_lasplace_set()
endif
