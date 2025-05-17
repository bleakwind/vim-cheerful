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
" cheerful set list
" ============================================================================
if !exists('g:cheerful_set_main')
    let g:cheerful_set_main = 0
endif
if !exists('g:cheerful_set_path')
    let g:cheerful_set_path = ""
endif

if !exists('g:cheerful_set_name') || empty(g:cheerful_set_name)
    let g:cheerful_set_name  == {}
endif
if !exists('g:cheerful_set_type') || empty(g:cheerful_set_name)
    let g:cheerful_set_type  == {}
endif
if !exists('g:cheerful_set_part') || empty(g:cheerful_set_name)
    let g:cheerful_set_part  == {}
endif
if !exists('g:cheerful_set_buff') || empty(g:cheerful_set_name)
    let g:cheerful_set_buff  == {}
endif
if !exists('g:cheerful_set_coth') || empty(g:cheerful_set_name)
    let g:cheerful_set_coth == {}
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
if !exists('g:cheerful_set_stat') || empty(g:cheerful_set_name)
    let g:cheerful_set_stat  == {}
endif
if !exists('g:cheerful_set_show') || empty(g:cheerful_set_name)
    let g:cheerful_set_show == {}
endif

" ============================================================================
" 01: cheerful struct keep
" g:cheerful_struct_enable = 1
" - Char for String:   `~!@#$%^&+-=()[]{},.;'/:|\"*?<>
" - Char for Filename: `~!@#$%^&+-=()[]{},.;'/:
" ============================================================================
if exists('g:cheerful_struct_enable') && g:cheerful_struct_enable == 1

    " --------------------------------------------------
    " CheerfulStructInit
    " --------------------------------------------------
    function CheerfulStructInit()
        " set show
        let winlist = getwininfo()
        for [kc, vc] in items(g:cheerful_set_name)
            let g:cheerful_set_show[kc] = 0
            for v in winlist
                let bufnr = v.bufnr
                let winnr = v.winnr
                let winid = v.winid
                let filetype = getbufvar(v.bufnr, '&filetype')
                let buftype = getbufvar(v.bufnr, '&buftype')
                let bufname = bufname(v.bufnr)
                if filetype == g:cheerful_set_type[kc]
                    let g:cheerful_set_show[kc] = 1
                endif
            endfor
        endfor
        " set filetype
        let winlist = getwininfo()
        for [kc, vc] in items(g:cheerful_set_name)
            if !empty(g:cheerful_set_buff[kc])
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if bufname == g:cheerful_set_buff[kc]
                        call win_execute(winid, 'set filetype='.g:cheerful_set_type[kc])
                    endif
                endfor
            endif
        endfor
        " set statusline
        let winlist = getwininfo()
        for v in winlist
            let bufnr = v.bufnr
            let winnr = v.winnr
            let winid = v.winid
            let filetype = getbufvar(v.bufnr, '&filetype')
            let buftype = getbufvar(v.bufnr, '&buftype')
            let bufname = bufname(v.bufnr)
            let searchkey = ''
            for [kc, vc] in items(g:cheerful_set_name)
                if g:cheerful_set_type[kc] == filetype
                    let searchkey = kc
                    break
                endif
            endfor
            if !empty(searchkey)
                if g:cheerful_set_stat[searchkey] == 1
                    call win_execute(winid, 'call StatuslineDetect(g:cheerful_set_name[searchkey])')
                endif
            elseif !empty(buftype)
                call win_execute(winid, 'call StatuslineDetect("Other")')
            else
                let g:cheerful_set_main = winid
                call win_execute(winid, 'call StatuslineDetect("Main")')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " CheerfulStructResize
    " --------------------------------------------------
    function CheerfulStructResize()
        call CheerfulStructInit()
        if g:cheerful_set_main > 0
            let l:winid_original = bufwinid('%')
            " check layout
            let winlist = getwininfo()
            for [kc, vc] in items(g:cheerful_set_name)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_set_type[kc] && g:cheerful_set_part[kc] == 'info'
                        call win_execute(winid, 'silent wincmd L')
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_set_name)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_set_type[kc] && g:cheerful_set_part[kc] == 'output'
                        call win_execute(winid, 'silent wincmd J')
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_set_name)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_set_type[kc] && g:cheerful_set_part[kc] == 'tab'
                        call win_execute(winid, 'silent wincmd K')
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_set_name)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_set_type[kc] && g:cheerful_set_part[kc] == 'tree'
                        call win_execute(winid, 'silent wincmd H')
                        break
                    endif
                endfor
            endfor
            " check size
            for [kc, vc] in items(g:cheerful_set_name)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_set_type[kc] && g:cheerful_set_part[kc] == 'info'
                        call win_execute(winid, 'vertical resize '.g:cheerful_set_size[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_set_name)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_set_type[kc] && g:cheerful_set_part[kc] == 'output'
                        call win_execute(winid, 'resize '.g:cheerful_set_size[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_set_name)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_set_type[kc] && g:cheerful_set_part[kc] == 'tab'
                        call win_execute(winid, 'resize '.g:cheerful_set_size[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_set_name)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_set_type[kc] && g:cheerful_set_part[kc] == 'tree'
                        call win_execute(winid, 'vertical resize '.g:cheerful_set_size[kc])
                        break
                    endif
                endfor
            endfor
            " fix size
            for [kc, vc] in items(g:cheerful_set_name)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_set_type[kc] && g:cheerful_set_part[kc] == 'info'
                        call win_execute(winid, 'vertical resize '.g:cheerful_set_size[kc])
                        break
                    endif
                endfor
            endfor
            " back winid
            if l:winid_original != bufwinid('%')
                call win_gotoid(l:winid_original)
            endif
        endif
    endfunction

    " --------------------------------------------------
    " CheerfulStructOperate
    " --------------------------------------------------
    function CheerfulStructOperate(name, ope)
        call CheerfulStructInit()
        if g:cheerful_set_main > 0 && has_key(g:cheerful_set_name, a:name)
            let l:winid_original = bufwinid('%')
            " save state
            let set_show = {}
            for [kc, vc] in items(g:cheerful_set_show)
                let set_show[kc] = g:cheerful_set_show[kc]
            endfor
            " handle close
            let winlist = getwininfo()
            for [kc, vc] in items(g:cheerful_set_name)
                if !empty(g:cheerful_set_coth[a:name]) && index(g:cheerful_set_coth[a:name], kc) != -1
                    if set_show[kc] == 1
                        silent exe g:cheerful_set_close[kc]
                    endif
                endif
            endfor
            " handle state
            if a:ope == 'open'
                silent exe g:cheerful_set_open[a:name]
            elseif a:ope == 'close'
                silent exe g:cheerful_set_close[a:name]
            endif
            " handle restore
            for [kc, vc] in items(g:cheerful_set_name)
                if !empty(g:cheerful_set_coth[a:name]) && index(g:cheerful_set_coth[a:name], kc) != -1
                    if set_show[kc] == 1
                        silent exe g:cheerful_set_open[kc]
                    endif
                endif
            endfor
            " resize struct
            call CheerfulStructResize()
            " back winid
            if l:winid_original != bufwinid('%')
                call win_gotoid(l:winid_original)
            endif
        endif
    endfunction

    " --------------------------------------------------
    " CheerfulStructXXX
    " --------------------------------------------------
    function CheerfulStructTree()
        call CheerfulStructInit()
        call win_gotoid(g:cheerful_set_main)
        " clean other
        let winlist = getwininfo()
        for v in winlist
            let bufnr = v.bufnr
            let winnr = v.winnr
            let winid = v.winid
            let filetype = getbufvar(v.bufnr, '&filetype')
            let buftype = getbufvar(v.bufnr, '&buftype')
            let bufname = bufname(v.bufnr)
            let if_have = 0
            for [k, v] in items(g:cheerful_set_name)
                if g:cheerful_set_type[k] == filetype
                    let if_have = 1
                    break
                endif
            endfor
            if if_have != 1 && !empty(buftype)
                call win_execute(winid, 'close')
            endif
        endfor
        " operate win
        for [k, v] in items(g:cheerful_set_name)
            if g:cheerful_set_part[k] == 'tree'
                call CheerfulStructOperate(k, 'open')
                break
            endif
        endfor
        for [k, v] in items(g:cheerful_set_name)
            if g:cheerful_set_part[k] == 'tab'
                call CheerfulStructOperate(k, 'open')
                break
            endif
        endfor
        for [k, v] in items(g:cheerful_set_name)
            if g:cheerful_set_part[k] == 'output'
                call CheerfulStructOperate(k, 'close')
            endif
        endfor
        for [k, v] in items(g:cheerful_set_name)
            if g:cheerful_set_part[k] == 'info'
                call CheerfulStructOperate(k, 'close')
            endif
        endfor
    endfunction
    function CheerfulStructOutput()
        call CheerfulStructInit()
        call win_gotoid(g:cheerful_set_main)
        for [k, v] in items(g:cheerful_set_name)
            if g:cheerful_set_part[k] == 'output'
                if g:cheerful_set_show[k] == 0
                    call CheerfulStructOperate(k, 'open')
                else
                    call CheerfulStructOperate(k, 'close')
                endif
            endif
        endfor
    endfunction
    function CheerfulStructInfo()
        call CheerfulStructInit()
        call win_gotoid(g:cheerful_set_main)
        for [k, v] in items(g:cheerful_set_name)
            if g:cheerful_set_part[k] == 'info'
                if g:cheerful_set_show[k] == 0
                    call CheerfulStructOperate(k, 'open')
                else
                    call CheerfulStructOperate(k, 'close')
                endif
            endif
        endfor
    endfunction
    function CheerfulStructClear()
        call CheerfulStructInit()
        call win_gotoid(g:cheerful_set_main)
        " clean other
        let winlist = getwininfo()
        for v in winlist
            let bufnr = v.bufnr
            let winnr = v.winnr
            let winid = v.winid
            let filetype = getbufvar(v.bufnr, '&filetype')
            let buftype = getbufvar(v.bufnr, '&buftype')
            let bufname = bufname(v.bufnr)
            let if_have = 0
            for [k, v] in items(g:cheerful_set_name)
                if g:cheerful_set_type[k] == filetype
                    let if_have = 1
                    break
                endif
            endfor
            if if_have != 1 && !empty(buftype)
                call win_execute(winid, 'close')
            endif
        endfor
        " operate win
        for [k, v] in items(g:cheerful_set_name)
            if g:cheerful_set_part[k] == 'tree'
                call CheerfulStructOperate(k, 'close')
            endif
        endfor
        for [k, v] in items(g:cheerful_set_name)
            if g:cheerful_set_part[k] == 'tab'
                call CheerfulStructOperate(k, 'open')
            endif
        endfor
        for [k, v] in items(g:cheerful_set_name)
            if g:cheerful_set_part[k] == 'output'
                call CheerfulStructOperate(k, 'close')
            endif
        endfor
        for [k, v] in items(g:cheerful_set_name)
            if g:cheerful_set_part[k] == 'info'
                call CheerfulStructOperate(k, 'close')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " CheerfulStructDebug
    " --------------------------------------------------
    function CheerfulStructDebug()
        echo printf("= %-8s = %-8s = %-8s = %-16s = %-16s = %-16s", 'bufnr', 'winnr', 'winid', 'filetype', 'buftype', 'bufname')
        let winlist = getwininfo()
        for v in winlist
            let bufnr = v.bufnr
            let winnr = v.winnr
            let winid = v.winid
            let filetype = getbufvar(v.bufnr, '&filetype')
            let buftype = getbufvar(v.bufnr, '&buftype')
            let bufname = bufname(v.bufnr)
            echo printf("> %-8d > %-8d > %-8d > %-16s > %-16s > %-16s", bufnr, winnr, winid, filetype, buftype, bufname)
        endfor
    endfunction

    " --------------------------------------------------
    " Autocmd
    " --------------------------------------------------
    " autocmd VimResized,BufWinEnter,BufHidden,BufDelete * call CheerfulStructResize()
    autocmd BufEnter,BufWritePost * call CheerfulStructInit()
    autocmd VimEnter * call CheerfulStructTree()
endif

" ============================================================================
" 02: cheerful reopen last buffer
" g:cheerful_reopen_enable = 1
" g:cheerful_reopen_last = 1
" ============================================================================
if exists('g:cheerful_reopen_enable') && g:cheerful_reopen_enable == 1

    " --------------------------------------------------
    " cheerful reopen set
    " --------------------------------------------------
    if !exists('g:cheerful_set_path') || g:cheerful_set_path == ""
        let g:cheerful_reopen_file = $HOME."/.vim/cheerful/reopen_filelist.vim"
    else
        let g:cheerful_reopen_file = g:cheerful_set_path."/reopen_filelist.vim"
    endif

    " --------------------------------------------------
    " cheerful reopen data
    " --------------------------------------------------
    let g:cheerful_reopen_data  = {}

    " --------------------------------------------------
    " cheerful_reopen_build
    " --------------------------------------------------
    function! s:cheerful_reopen_build()
        autocmd BufLeave * nested call s:cheerful_reopen_bufleave()
        autocmd BufWinEnter * nested call s:cheerful_reopen_winenter()
        autocmd VimLeavePre * nested call s:cheerful_reopen_leavepre()
    endfunction

    " --------------------------------------------------
    " cheerful_reopen_restore
    " --------------------------------------------------
    function! s:cheerful_reopen_restore()
        if !isdirectory(g:cheerful_set_path)
            call mkdir(g:cheerful_set_path, 'p', 0777)
        endif
        if argc() == 0 && filereadable(g:cheerful_reopen_file)
            let l:current_buf = 0
            let l:current_msg = []
            let g:cheerful_reopen_data = readfile(g:cheerful_reopen_file)
            for l:file_list in g:cheerful_reopen_data
                let l:file_info = split(l:file_list, '*')
                if exists("l:file_info[0]") && l:file_info[0] != "" && filereadable(l:file_info[0])
                    silent exe "edit ".l:file_info[0]
                    if exists('g:cheerful_reopen_last') && g:cheerful_reopen_last == 1
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
                if exists('g:cheerful_reopen_last') && g:cheerful_reopen_last == 1
                    call setpos('.', [0, l:current_msg[4] + &scrolloff, l:current_msg[3], 0])
                    exe "normal zt"
                    call setpos('.', [0, l:current_msg[2], l:current_msg[3], 0])
                endif
            endif
        endif
    endfunction

    " --------------------------------------------------
    " cheerful_reopen_bufleave
    " --------------------------------------------------
    function! s:cheerful_reopen_bufleave()
        if !isdirectory(g:cheerful_set_path)
            call mkdir(g:cheerful_set_path, 'p', 0777)
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

    " --------------------------------------------------
    " cheerful_reopen_winenter
    " --------------------------------------------------
    function! s:cheerful_reopen_winenter()
        if !isdirectory(g:cheerful_set_path)
            call mkdir(g:cheerful_set_path, 'p', 0777)
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
        if exists('g:cheerful_reopen_last') && g:cheerful_reopen_last == 1
            if !empty(l:current_msg)
                call setpos('.', [0, l:current_msg[3] + &scrolloff, l:current_msg[2], 0])
                exe "normal zt"
                call setpos('.', [0, l:current_msg[1], l:current_msg[2], 0])
            endif
        endif
        let g:cheerful_reopen_data = l:buflist
        call writefile(g:cheerful_reopen_data, g:cheerful_reopen_file, 'b')
    endfunction

    " --------------------------------------------------
    " cheerful_reopen_leavepre
    " --------------------------------------------------
    function! s:cheerful_reopen_leavepre()
        call s:cheerful_reopen_bufleave()
        call writefile(g:cheerful_reopen_data, g:cheerful_reopen_file, 'b')
    endfunction

    " Autocmd
    autocmd VimEnter * nested call s:cheerful_reopen_build()
    autocmd VimEnter * nested call s:cheerful_reopen_restore()
endif

" ============================================================================
" 99: Other
" ============================================================================
let &cpoptions = s:save_cpo
unlet s:save_cpo

