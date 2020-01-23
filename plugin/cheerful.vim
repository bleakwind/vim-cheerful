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

if exists('g:cheerful_plugin')
    finish
endif
let b:cheerful_plugin = 1

scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

"##############################################################################
" 01: Function for Neatly
" - Char for String:   `~!@#$%^&+-=()[]{},.;'/:|\"*?<>
" - Char for Filename: `~!@#$%^&+-=()[]{},.;'/:
"##############################################################################
if exists('g:cheerful_neatly_enable') && g:cheerful_neatly_enable == 1

    let g:env_tool_visible      = {}
    let g:env_edit_visible      = {}
    let g:env_winid_main        = -1

    if !exists('g:set_tool_name')
        let g:set_tool_name  == {} 
    endif
    if !exists('g:set_tool_type')  
        let g:set_tool_type  == {}
    endif
    if !exists('g:set_tool_part')  
        let g:set_tool_part  == {}
    endif
    if !exists('g:set_tool_nocur') 
        let g:set_tool_nocur == {}
    endif
    if !exists('g:set_tool_stay')  
        let g:set_tool_stay  == {}
    endif
    if !exists('g:set_tool_size')  
        let g:set_tool_size  == {}
    endif
    if !exists('g:set_tool_open')  
        let g:set_tool_open  == {}
    endif
    if !exists('g:set_tool_close') 
        let g:set_tool_close == {}
    endif

    if !exists('g:set_tool_other') 
        let g:set_tool_other == {}
    endif

    "******************************************************************************
    " Function List
    "******************************************************************************
    function s:CheckConfig()
        if exists('g:config_builddir') 
            for l:key in keys(g:config_builddir)
                if filewritable(g:config_builddir[l:key]) != 2
                    call mkdir(g:config_builddir[l:key], 'p', 0777)
                endif
            endfor
        endif
        if exists('g:config_buildfile') 
            for l:key in keys(g:config_buildfile)
                if filewritable(g:config_buildfile[l:key]) != 1
                    call writefile(g:config_buildfile_content[l:key], g:config_buildfile[l:key], 'b')
                    call setfperm(g:config_buildfile[l:key], 'rwxrwxrwx')
                endif
            endfor
        endif
    endfunction

    function s:ReturnWinid()
        let l:result_winid = bufwinid('%')
        return l:result_winid
    endfunction

    function s:ReturnWinlist()
        let g:env_tool_visible  = {}
        let g:env_edit_visible  = {}
        let l:winid_original = s:ReturnWinid()
        let l:bufid_last = bufnr('$')
        let l:i = 1
        while l:i <= l:bufid_last
           if bufexists(l:i)
               let l:winid_this = bufwinid(l:i)
               if l:winid_this > 0
                   if win_gotoid(l:winid_this) == 1
                       if count(g:set_tool_type, &filetype) > 0
                           let g:env_tool_visible[&filetype] = l:winid_this
                       else
                           let g:env_edit_visible[l:winid_this] = l:winid_this
                       endif
                   endif
               endif
           endif
           let l:i = l:i+1
        endwhile
        if len(g:env_edit_visible) > 0
            for key in sort(keys(g:env_edit_visible))
                if g:env_edit_visible[key] > 0
                    let g:env_winid_main = g:env_edit_visible[key]
                    break
                endif
            endfor
        endif
        if l:winid_original != s:ReturnWinid()
            call win_gotoid(l:winid_original)
        endif
        return 1
    endfunction

    function s:ToolVisible(name)
        let l:winid_original = s:ReturnWinid()
        let l:result_check = 0
        if has_key(g:set_tool_type, a:name)
            if has_key(g:env_tool_visible, g:set_tool_type[a:name])
                if win_gotoid(g:env_tool_visible[g:set_tool_type[a:name]]) == 1
                    let l:result_check = 1
                endif
            endif
        endif
        if l:result_check != 1
            if l:winid_original != s:ReturnWinid()
                call win_gotoid(l:winid_original)
            endif
        endif
        return l:result_check
    endfunction

    function s:EditInside()
        let l:result_check = 0
        if count(g:env_edit_visible, bufwinid('%')) > 0
            let l:result_check = 1
        endif
        return l:result_check
    endfunction

    function s:WinviewSave(name)
        let l:result_winview = 0
        let l:winid_original = s:ReturnWinid()
        if s:ToolVisible(g:set_tool_name[a:name]) == 1
            let l:result_winview = winsaveview()
        endif
        if l:winid_original != s:ReturnWinid()
            call win_gotoid(l:winid_original)
        endif
        return l:result_winview
    endfunction

    function s:WinviewRestore(name, winview)
        let l:result_winview = -1
        let l:winid_original = s:ReturnWinid()
        if s:ToolVisible(g:set_tool_name[a:name]) == 1
            if !empty(a:winview)
                let l:result_winview = winrestview(a:winview)
            endif
        endif
        if l:winid_original != s:ReturnWinid()
            call win_gotoid(l:winid_original)
        endif
        return l:result_winview
    endfunction

    "******************************************************************************
    " Handle List
    "******************************************************************************
    function s:HandleTool(name, ope)
        let l:winid_original = s:ReturnWinid()

        call s:ReturnWinlist()
        call OperateJump()
        let l:winview_list   = {}
        for item in values(g:set_tool_name)
            let l:winview_list[item] = s:WinviewSave(item)
        endfor

        call OperateJump()
        let l:winid_operate = s:ToolVisible(a:name)
        if a:ope == 'open'
            if l:winid_operate != 1
                silent exe g:set_tool_open[a:name]
            endif
        elseif a:ope == 'close'
            if l:winid_operate == 1
                if g:set_tool_close[a:name] == 'close'
                    silent exe 'close'
                else
                    silent exe g:set_tool_close[a:name]
                endif
            endif
        endif

        call s:ReturnWinlist()
        call OperateJump()
        for item in values(g:set_tool_name)
            call s:WinviewRestore(item, l:winview_list[item])
        endfor

        if l:winid_original != s:ReturnWinid()
            call win_gotoid(l:winid_original)
        endif
    endfunction

    function s:HandleResize()
        let l:winid_original = s:ReturnWinid()

        call s:ReturnWinlist()

        if &diff != 1

            call OperateJump()
            let l:winview_list   = {}
            for item in values(g:set_tool_name)
                let l:winview_list[item] = s:WinviewSave(item)
            endfor

            call OperateJump()
            let l:winid_info_id = 0
            let l:winid_info_size = 0

            for item in values(g:set_tool_name)
                if g:set_tool_part[item] == 'info'
                    if s:ToolVisible(item) == 1
                        for v in values(g:set_tool_name)
                            if g:set_tool_part[v] == 'info' && v != item
                                call s:HandleTool(v,'close')
                            endif
                        endfor
                        exe 'wincmd L'
                        exe 'vertical resize '.g:set_tool_size[item]
                        if g:set_tool_nocur[item] == 1
                            setlocal nocursorline
                            setlocal nocursorcolumn
                        endif
                        if g:set_tool_stay[item] == 1
                            let l:winid_original = s:ReturnWinid()
                        endif
                        let l:winid_info_id = s:ReturnWinid()
                        let l:winid_info_size = g:set_tool_size[item]
                        break
                    endif
                endif
            endfor

            for item in values(g:set_tool_name)
                if g:set_tool_part[item] == 'tab'
                    if s:ToolVisible(item) == 1
                        for v in values(g:set_tool_name)
                            if g:set_tool_part[v] == 'tab' && v != item
                                call s:HandleTool(v,'close')
                            endif
                        endfor
                        exe 'wincmd K'
                        exe 'resize '.g:set_tool_size[item]
                        if g:set_tool_nocur[item] == 1
                            setlocal nocursorline
                            setlocal nocursorcolumn
                        endif
                        if g:set_tool_stay[item] == 1
                            let l:winid_original = s:ReturnWinid()
                        endif
                        break
                    endif
                endif
            endfor

            for item in values(g:set_tool_name)
                if g:set_tool_part[item] == 'debug'
                    if s:ToolVisible(item) == 1
                        for v in values(g:set_tool_name)
                            if g:set_tool_part[v] == 'debug' && v != item
                                call s:HandleTool(v,'close')
                            endif
                        endfor
                        exe 'wincmd J'
                        exe 'resize '.g:set_tool_size[item]
                        if g:set_tool_nocur[item] == 1
                            setlocal nocursorline
                            setlocal nocursorcolumn
                        endif
                        if g:set_tool_stay[item] == 1
                            let l:winid_original = s:ReturnWinid()
                        endif
                        break
                    endif
                endif
            endfor

            for item in values(g:set_tool_name)
                if g:set_tool_part[item] == 'tree'
                    if s:ToolVisible(item) == 1
                        for v in values(g:set_tool_name)
                            if g:set_tool_part[v] == 'tree' && v != item
                                call s:HandleTool(v,'close')
                            endif
                        endfor
                        exe 'wincmd H'
                        exe 'vertical resize '.g:set_tool_size[item]
                        if g:set_tool_nocur[item] == 1
                            setlocal nocursorline
                            setlocal nocursorcolumn
                        endif
                        if g:set_tool_stay[item] == 1
                            let l:winid_original = s:ReturnWinid()
                        endif
                        if l:winid_info_id > 0
                            call win_gotoid(l:winid_info_id)
                            exe 'vertical resize '.l:winid_info_size
                        endif
                        break
                    endif
                endif
            endfor

            call OperateJump()
            for item in values(g:set_tool_name)
                call s:WinviewRestore(item, l:winview_list[item])
            endfor

        endif

        if l:winid_original != s:ReturnWinid()
            call win_gotoid(l:winid_original)
        endif
    endfunction

    "******************************************************************************
    " Operate List
    "******************************************************************************
    function OperateJump()
        let l:winid_operate = 0
        if s:EditInside() != 1
            let l:winid_operate = win_gotoid(g:env_winid_main)
        endif
        return l:winid_operate
    endfunction

    function OperateTool(name, ope)
        if a:ope == 'open'
            for item in values(g:set_tool_name)
                if g:set_tool_part[item] == g:set_tool_part[a:name] && item != a:name
                    call s:HandleTool(item, 'close')
                endif
            endfor
            call s:HandleTool(a:name, 'open')
        elseif a:ope == 'close'
            call s:HandleTool(a:name, 'close')
        endif
        call s:HandleResize()
    endfunction

    function ResetTree()
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'tree'
                call s:HandleTool(item, 'open')
            endif
        endfor
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'tab'
                call s:HandleTool(item, 'open')
            endif
        endfor
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'debug'
                call s:HandleTool(item, 'close')
            endif
        endfor
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'info'
                call s:HandleTool(item, 'close')
            endif
        endfor
        call s:HandleResize()
        call OperateJump()
    endfunction

    function ResetEdit()
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'tree'
                call s:HandleTool(item, 'close')
            endif
        endfor
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'tab'
                call s:HandleTool(item, 'open')
            endif
        endfor
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'debug'
                call s:HandleTool(item, 'close')
            endif
        endfor
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'info'
                call s:HandleTool(item, 'close')
            endif
        endfor
        call s:HandleResize()
        call OperateJump()
    endfunction

    function ResetDebug()
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'tree'
                call s:HandleTool(item, 'open')
            endif
        endfor
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'tab'
                call s:HandleTool(item, 'open')
            endif
        endfor
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'debug'
                call s:HandleTool(item, 'open')
            endif
        endfor
        for item in values(g:set_tool_name)
            if g:set_tool_part[item] == 'info'
                call s:HandleTool(item, 'close')
            endif
        endfor
        call s:HandleResize()
        call OperateJump()
    endfunction

    " Autocmd
    " autocmd VimResized,BufWinEnter,BufHidden,BufDelete * call s:HandleResize()
    autocmd VimEnter * call s:CheckConfig()
    autocmd VimEnter * call ResetTree()
endif

"##############################################################################
" 02: Reopen last buffer
" g:cheerful_reopen_enable == 1
" g:cheerful_reopen_dir == ""
"##############################################################################
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

    " Autocmd
    autocmd VimEnter * nested call s:cheerful_reopen_build_cmd()
    autocmd VimEnter * nested call s:cheerful_reopen_restore_session()
endif

"##############################################################################
" 03: Jump to lastplace
" g:cheerful_lasplace_enable == 1
"##############################################################################
if exists('g:cheerful_lasplace_enable') && g:cheerful_lasplace_enable == 1
    function! s:cheerful_lasplace_set()
        if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            exe "normal! g`\""
        endif
    endfunction

    " Autocmd
    autocmd BufReadPost * nested call s:cheerful_lasplace_set()
endif

"##############################################################################
" 99: Other
"##############################################################################
let &cpoptions = s:save_cpo
unlet s:save_cpo
"##############################################################################

