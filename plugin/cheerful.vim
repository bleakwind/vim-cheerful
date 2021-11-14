" vim: set expandtab tabstop=4 softtabstop=4 shiftwidth=4: */
"
" +--------------------------------------------------------------------------+
" | $Id: cheerful.vim 2018-10-18 10:06:29 Bleakwind Exp $                    |
" +--------------------------------------------------------------------------+
" | Copyright (c) 2008-2018 Bleakwind(Rick Wu).                              |
" +--------------------------------------------------------------------------+
" | This source file is cheerful.vim.                                        |
" | This source file is release under BSD license.                           |
" +--------------------------------------------------------------------------+
" | Author: Bleakwind(Rick Wu) <bleakwind@qq.com>                            |
" +--------------------------------------------------------------------------+
"

if exists('g:cheerful_plugin')
    finish
endif
let b:cheerful_plugin = 1

scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

" ============================================================================
" 01: Function for Neatly
" g:cheerful_neatly_enable = 1
" - Char for String:   `~!@#$%^&+-=()[]{},.;'/:|\"*?<>
" - Char for Filename: `~!@#$%^&+-=()[]{},.;'/:
" ============================================================================
if exists('g:cheerful_neatly_enable') && g:cheerful_neatly_enable == 1

    let g:cheerful_neatly_tool_visible      = {}
    let g:cheerful_neatly_edit_visible      = {}
    let g:cheerful_neatly_winid_main        = -1

    if !exists('g:cheerful_set_name') || empty(g:cheerful_set_name)
        let g:cheerful_set_name  == {}
    endif
    if !exists('g:cheerful_set_type') || empty(g:cheerful_set_name)
        let g:cheerful_set_type  == {}
    endif
    if !exists('g:cheerful_set_part') || empty(g:cheerful_set_name)
        let g:cheerful_set_part  == {}
    endif
    if !exists('g:cheerful_set_nocur') || empty(g:cheerful_set_name)
        let g:cheerful_set_nocur == {}
    endif
    if !exists('g:cheerful_set_stay') || empty(g:cheerful_set_name)
        let g:cheerful_set_stay  == {}
    endif
    if !exists('g:cheerful_set_size') || empty(g:cheerful_set_name)
        let g:cheerful_set_size  == {}
    endif
    if !exists('g:cheerful_set_open') || empty(g:cheerful_set_name)
        let g:cheerful_set_open  == {}
    endif
    if !exists('g:cheerful_set_close') || empty(g:cheerful_set_name)
        let g:cheerful_set_close == {}
    endif

    " --------------------------------------------------
    " Function List
    " --------------------------------------------------
    function s:ReturnWinid()
        let l:result_winid = bufwinid('%')
        return l:result_winid
    endfunction

    function s:ReturnWinlist()
        let g:cheerful_neatly_tool_visible  = {}
        let g:cheerful_neatly_edit_visible  = {}
        let l:winid_original = s:ReturnWinid()
        let l:bufid_last = bufnr('$')
        let l:i = 1
        while l:i <= l:bufid_last
           if bufexists(l:i)
               let l:winid_this = bufwinid(l:i)
               if l:winid_this > 0
                   if win_gotoid(l:winid_this) == 1
                       if count(g:cheerful_set_type, &filetype) > 0
                           let g:cheerful_neatly_tool_visible[&filetype] = l:winid_this
                       else
                           let g:cheerful_neatly_edit_visible[l:winid_this] = l:winid_this
                       endif
                   endif
               endif
           endif
           let l:i = l:i+1
        endwhile
        if len(g:cheerful_neatly_edit_visible) > 0
            for l:key in sort(keys(g:cheerful_neatly_edit_visible))
                if g:cheerful_neatly_edit_visible[l:key] > 0
                    let g:cheerful_neatly_winid_main = g:cheerful_neatly_edit_visible[l:key]
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
        if has_key(g:cheerful_set_type, a:name)
            if has_key(g:cheerful_neatly_tool_visible, g:cheerful_set_type[a:name])
                if win_gotoid(g:cheerful_neatly_tool_visible[g:cheerful_set_type[a:name]]) == 1
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
        if count(g:cheerful_neatly_edit_visible, bufwinid('%')) > 0
            let l:result_check = 1
        endif
        return l:result_check
    endfunction

    function s:WinviewSave(name)
        let l:result_winview = 0
        let l:winid_original = s:ReturnWinid()
        if s:ToolVisible(g:cheerful_set_name[a:name]) == 1
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
        if s:ToolVisible(g:cheerful_set_name[a:name]) == 1
            if !empty(a:winview)
                let l:result_winview = winrestview(a:winview)
            endif
        endif
        if l:winid_original != s:ReturnWinid()
            call win_gotoid(l:winid_original)
        endif
        return l:result_winview
    endfunction

    " --------------------------------------------------
    " Handle List
    " --------------------------------------------------
    function s:HandleTool(name, ope)
        let l:winid_original = s:ReturnWinid()

        call s:ReturnWinlist()
        call OperateJump()
        let l:winview_list   = {}
        for l:item in values(g:cheerful_set_name)
            let l:winview_list[l:item] = s:WinviewSave(l:item)
        endfor

        call OperateJump()
        let l:winid_operate = s:ToolVisible(a:name)
        if a:ope == 'open'
            if l:winid_operate != 1
                silent exe g:cheerful_set_open[a:name]
            endif
        elseif a:ope == 'close'
            if l:winid_operate == 1
                if g:cheerful_set_close[a:name] == 'close'
                    silent exe 'close'
                else
                    silent exe g:cheerful_set_close[a:name]
                endif
            endif
        endif

        call s:ReturnWinlist()
        call OperateJump()
        for l:item in values(g:cheerful_set_name)
            call s:WinviewRestore(l:item, l:winview_list[l:item])
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
            for l:item in values(g:cheerful_set_name)
                let l:winview_list[l:item] = s:WinviewSave(l:item)
            endfor

            call OperateJump()
            let l:winid_info_id = 0
            let l:winid_info_size = 0

            for l:item in values(g:cheerful_set_name)
                if g:cheerful_set_part[l:item] == 'info'
                    if s:ToolVisible(l:item) == 1
                        for l:v in values(g:cheerful_set_name)
                            if g:cheerful_set_part[l:v] == 'info' && l:v != l:item
                                call s:HandleTool(l:v,'close')
                            endif
                        endfor
                        exe 'wincmd L'
                        exe 'vertical resize '.g:cheerful_set_size[l:item]
                        if g:cheerful_set_nocur[l:item] == 1
                            setlocal nocursorline
                            setlocal nocursorcolumn
                        endif
                        if g:cheerful_set_stay[l:item] == 1
                            let l:winid_original = s:ReturnWinid()
                        endif
                        let l:winid_info_id = s:ReturnWinid()
                        let l:winid_info_size = g:cheerful_set_size[l:item]
                        break
                    endif
                endif
            endfor

            for l:item in values(g:cheerful_set_name)
                if g:cheerful_set_part[l:item] == 'tab'
                    if s:ToolVisible(l:item) == 1
                        for l:v in values(g:cheerful_set_name)
                            if g:cheerful_set_part[l:v] == 'tab' && l:v != l:item
                                call s:HandleTool(l:v,'close')
                            endif
                        endfor
                        exe 'wincmd K'
                        exe 'resize '.g:cheerful_set_size[l:item]
                        if g:cheerful_set_nocur[l:item] == 1
                            setlocal nocursorline
                            setlocal nocursorcolumn
                        endif
                        if g:cheerful_set_stay[l:item] == 1
                            let l:winid_original = s:ReturnWinid()
                        endif
                        break
                    endif
                endif
            endfor

            for l:item in values(g:cheerful_set_name)
                if g:cheerful_set_part[l:item] == 'debug'
                    if s:ToolVisible(l:item) == 1
                        for l:v in values(g:cheerful_set_name)
                            if g:cheerful_set_part[l:v] == 'debug' && l:v != l:item
                                call s:HandleTool(l:v,'close')
                            endif
                        endfor
                        exe 'wincmd J'
                        exe 'resize '.g:cheerful_set_size[l:item]
                        if g:cheerful_set_nocur[l:item] == 1
                            setlocal nocursorline
                            setlocal nocursorcolumn
                        endif
                        if g:cheerful_set_stay[l:item] == 1
                            let l:winid_original = s:ReturnWinid()
                        endif
                        break
                    endif
                endif
            endfor

            for l:item in values(g:cheerful_set_name)
                if g:cheerful_set_part[l:item] == 'tree'
                    if s:ToolVisible(l:item) == 1
                        for l:v in values(g:cheerful_set_name)
                            if g:cheerful_set_part[l:v] == 'tree' && l:v != l:item
                                call s:HandleTool(l:v,'close')
                            endif
                        endfor
                        exe 'wincmd H'
                        exe 'vertical resize '.g:cheerful_set_size[l:item]
                        if g:cheerful_set_nocur[l:item] == 1
                            setlocal nocursorline
                            setlocal nocursorcolumn
                        endif
                        if g:cheerful_set_stay[l:item] == 1
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
            for l:item in values(g:cheerful_set_name)
                call s:WinviewRestore(l:item, l:winview_list[l:item])
            endfor

        endif

        if l:winid_original != s:ReturnWinid()
            call win_gotoid(l:winid_original)
        endif
    endfunction

    " --------------------------------------------------
    " Operate List
    " --------------------------------------------------
    function OperateJump()
        let l:winid_operate = 0
        if s:EditInside() != 1
            let l:winid_operate = win_gotoid(g:cheerful_neatly_winid_main)
        endif
        return l:winid_operate
    endfunction

    function OperateTool(name, ope)
        if a:ope == 'open'
            for l:item in values(g:cheerful_set_name)
                if g:cheerful_set_part[l:item] == g:cheerful_set_part[a:name] && l:item != a:name
                    call s:HandleTool(l:item, 'close')
                endif
            endfor
            call s:HandleTool(a:name, 'open')
        elseif a:ope == 'close'
            call s:HandleTool(a:name, 'close')
        endif
        call s:HandleResize()
    endfunction

    function ResetTree()
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'tree'
                call s:HandleTool(l:item, 'open')
            endif
        endfor
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'tab'
                call s:HandleTool(l:item, 'open')
            endif
        endfor
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'debug'
                call s:HandleTool(l:item, 'close')
            endif
        endfor
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'info'
                call s:HandleTool(l:item, 'close')
            endif
        endfor
        call s:HandleResize()
        call OperateJump()
    endfunction

    function ResetEdit()
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'tree'
                call s:HandleTool(l:item, 'close')
            endif
        endfor
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'tab'
                call s:HandleTool(l:item, 'open')
            endif
        endfor
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'debug'
                call s:HandleTool(l:item, 'close')
            endif
        endfor
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'info'
                call s:HandleTool(l:item, 'close')
            endif
        endfor
        call s:HandleResize()
        call OperateJump()
    endfunction

    function ResetDebug()
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'tree'
                call s:HandleTool(l:item, 'open')
            endif
        endfor
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'tab'
                call s:HandleTool(l:item, 'open')
            endif
        endfor
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'debug'
                call s:HandleTool(l:item, 'open')
            endif
        endfor
        for l:item in values(g:cheerful_set_name)
            if g:cheerful_set_part[l:item] == 'info'
                call s:HandleTool(l:item, 'close')
            endif
        endfor
        call s:HandleResize()
        call OperateJump()
    endfunction

    " Autocmd
    " autocmd VimResized,BufWinEnter,BufHidden,BufDelete * call s:HandleResize()
    autocmd VimEnter * call ResetTree()
endif

" ============================================================================
" 02: Reopen last buffer
" g:cheerful_reopen_enable = 1
" g:cheerful_reopen_lastplace = 1
" g:cheerful_reopen_dir = ""
" ============================================================================
if exists('g:cheerful_reopen_enable') && g:cheerful_reopen_enable == 1
    if !exists('g:cheerful_reopen_dir') || g:cheerful_reopen_dir == ""
        let g:cheerful_reopen_file = $HOME."/.vim/cheerful/session_filelist.vim"
    else
        let g:cheerful_reopen_file = g:cheerful_reopen_dir."/session_filelist.vim"
    endif

    let g:cheerful_reopen_data     = {}

    function! s:cheerful_reopen_build_session()
        autocmd BufLeave * nested call s:cheerful_reopen_build_session_leave()
        autocmd BufWinEnter * nested call s:cheerful_reopen_build_session_enter()
        autocmd VimLeavePre * nested call s:cheerful_reopen_build_session_quit()
    endfunction

    function! s:cheerful_reopen_build_session_leave()
        if !isdirectory(g:cheerful_reopen_dir)
            call mkdir(g:cheerful_reopen_dir, 'p', 0777)
        endif

        let l:file_msg = {}
        for l:file_list in g:cheerful_reopen_data
            let l:file_info = split(l:file_list, '*')
            if len(l:file_info) == 5
                let l:file_msg[l:file_info[0]] = [l:file_info[1], l:file_info[2], l:file_info[3], l:file_info[4]]
            endif
        endfor
        let l:current_line    = line(".")
        let l:current_col     = col(".")
        let l:win_pos         = winline()
        let l:win_top         = l:current_line - l:win_pos + 1
        let l:current_file    = bufname()
        if has_key(l:file_msg, l:current_file)
            let l:file_msg[l:current_file] = ["c", l:current_line, l:current_col, l:win_top]
        endif

        let l:buflist = []
        for l:file_list in getbufinfo({'buflisted':1})
            if l:file_list.name != "" && filereadable(l:file_list.name)
                let l:this_msg = ["x", "1", "1", "1"]
                if has_key(l:file_msg, l:file_list.name)
                    let l:this_msg = l:file_msg[l:file_list.name]
                endif
                call add(l:buflist, l:file_list.name."*".l:this_msg[0]."*".l:this_msg[1]."*".l:this_msg[2]."*".l:this_msg[3])
            endif
        endfor
        let g:cheerful_reopen_data = l:buflist
    endfunction

    function! s:cheerful_reopen_build_session_enter()
        if !isdirectory(g:cheerful_reopen_dir)
            call mkdir(g:cheerful_reopen_dir, 'p', 0777)
        endif
        let l:current_msg = []
        let l:file_msg = {}
        for l:file_list in g:cheerful_reopen_data
            let l:file_info = split(l:file_list, '*')
            if len(l:file_info) == 5
                let l:file_msg[l:file_info[0]] = [l:file_info[1], l:file_info[2], l:file_info[3], l:file_info[4]]
            endif
        endfor
        let l:buflist = []
        for l:file_list in getbufinfo({'buflisted':1})
            if l:file_list.name != "" && filereadable(l:file_list.name)
                let l:this_msg = ["x", "1", "1", "1"]
                if has_key(l:file_msg, l:file_list.name)
                    let l:this_msg = l:file_msg[l:file_list.name]
                endif
                if l:file_list.bufnr == bufnr('%')
                    let l:current_msg = l:this_msg
                    call add(l:buflist, l:file_list.name."*c*".l:this_msg[1]."*".l:this_msg[2]."*".l:this_msg[3])
                else
                    call add(l:buflist, l:file_list.name."*x*".l:this_msg[1]."*".l:this_msg[2]."*".l:this_msg[3])
                endif
            endif
        endfor
        if exists('g:cheerful_reopen_lastplace') && g:cheerful_reopen_lastplace == 1
            if !empty(l:current_msg)
                call setpos('.', [0, l:current_msg[3] + &scrolloff, l:current_msg[2], 0])
                exe "normal zt"
                call setpos('.', [0, l:current_msg[1], l:current_msg[2], 0])
            endif
        endif
        let g:cheerful_reopen_data = l:buflist
        call writefile(g:cheerful_reopen_data, g:cheerful_reopen_file, 'b')
    endfunction

    function! s:cheerful_reopen_build_session_quit()
        call s:cheerful_reopen_build_session_leave()
        call writefile(g:cheerful_reopen_data, g:cheerful_reopen_file, 'b')
    endfunction

    function! s:cheerful_reopen_restore_session()
        if argc() == 0 && filereadable(g:cheerful_reopen_file)
            let l:current_buf = 0
            let l:current_msg = []
            let g:cheerful_reopen_data = readfile(g:cheerful_reopen_file)
            for l:file_list in g:cheerful_reopen_data
                let l:file_info = split(l:file_list, '*')
                if exists("l:file_info[0]") && l:file_info[0] != "" && filereadable(l:file_info[0])
                    silent exe "edit ".l:file_info[0]
                    if exists('g:cheerful_reopen_lastplace') && g:cheerful_reopen_lastplace == 1
                        call setpos('.', [0, l:file_info[4] + &scrolloff, l:file_info[3], 0])
                        exe "normal zt"
                        call setpos('.', [0, l:file_info[2], l:file_info[3], 0])
                    endif
                    if l:file_info[1] == 'c'
                        let l:current_buf = bufnr('%')
                        let l:current_msg = l:file_info
                    endif
                endif
            endfor
            if l:current_buf > 0
                silent exe "buffer ".l:current_buf
                if exists('g:cheerful_reopen_lastplace') && g:cheerful_reopen_lastplace == 1
                    call setpos('.', [0, l:current_msg[4] + &scrolloff, l:current_msg[3], 0])
                    exe "normal zt"
                    call setpos('.', [0, l:current_msg[2], l:current_msg[3], 0])
                endif
            endif
        endif
    endfunction

    " Autocmd
    autocmd VimEnter * nested call s:cheerful_reopen_build_session()
    autocmd VimEnter * nested call s:cheerful_reopen_restore_session()
endif

" ============================================================================
" 99: Other
" ============================================================================
let &cpoptions = s:save_cpo
unlet s:save_cpo

