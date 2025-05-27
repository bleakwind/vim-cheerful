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

if exists('g:cheerful_plugin') || &compatible
    finish
endif
let b:cheerful_plugin = 1

scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

" ============================================================================
" 01: cheerful_struct setting
" ============================================================================
let g:cheerful_struct_enabled       = get(g:, 'cheerful_struct_enabled', 0)
let g:cheerful_struct_setname       = get(g:, 'cheerful_struct_setname', {})
let g:cheerful_struct_settype       = get(g:, 'cheerful_struct_settype', {})
let g:cheerful_struct_setpart       = get(g:, 'cheerful_struct_setpart', {})
let g:cheerful_struct_setbuff       = get(g:, 'cheerful_struct_setbuff', {})
let g:cheerful_struct_setcoth       = get(g:, 'cheerful_struct_setcoth', {})
let g:cheerful_struct_setsize       = get(g:, 'cheerful_struct_setsize', {})
let g:cheerful_struct_setopen       = get(g:, 'cheerful_struct_setopen', {})
let g:cheerful_struct_setclse       = get(g:, 'cheerful_struct_setclse', {})
let g:cheerful_struct_setnohi       = get(g:, 'cheerful_struct_setnohi', {})
let g:cheerful_struct_setstat       = get(g:, 'cheerful_struct_setstat', {})
let g:cheerful_struct_setshow       = get(g:, 'cheerful_struct_setshow', {})

let g:cheerful_struct_mainwin       = 0

" ============================================================================
" 02: cheerful_reopen setting
" ============================================================================
let g:cheerful_reopen_enabled       = get(g:, 'cheerful_reopen_enabled', 0)
let g:cheerful_reopen_setpath       = get(g:, 'cheerful_reopen_setpath', '')

let g:cheerful_reopen_data          = {}

" ============================================================================
" 01: cheerful_struct detail
" g:cheerful_struct_enabled = 1
" - Char for String:   `~!@#$%^&+-=()[]{},.;'/:|\"*?<>
" - Char for Filename: `~!@#$%^&+-=()[]{},.;'/:
" ============================================================================
if exists('g:cheerful_struct_enabled') && g:cheerful_struct_enabled == 1

    " --------------------------------------------------
    " cheerful#StructInit
    " --------------------------------------------------
    function cheerful#StructInit()
        " set show
        let winlist = getwininfo()
        for [kc, vc] in items(g:cheerful_struct_setname)
            let g:cheerful_struct_setshow[kc] = 0
            for v in winlist
                let bufnr = v.bufnr
                let winnr = v.winnr
                let winid = v.winid
                let filetype = getbufvar(v.bufnr, '&filetype')
                let buftype = getbufvar(v.bufnr, '&buftype')
                let bufname = bufname(v.bufnr)
                if filetype == g:cheerful_struct_settype[kc]
                    let g:cheerful_struct_setshow[kc] = 1
                endif
            endfor
        endfor
        " set filetype
        let winlist = getwininfo()
        for [kc, vc] in items(g:cheerful_struct_setname)
            if !empty(g:cheerful_struct_setbuff[kc])
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if bufname == g:cheerful_struct_setbuff[kc]
                        call win_execute(winid, 'set filetype='.g:cheerful_struct_settype[kc])
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
            for [kc, vc] in items(g:cheerful_struct_setname)
                if g:cheerful_struct_settype[kc] == filetype
                    let searchkey = kc
                    break
                endif
            endfor
            if !empty(searchkey)
                if g:cheerful_struct_setstat[searchkey] == 1
                    call win_execute(winid, 'call StatuslineDetect(g:cheerful_struct_setname[searchkey])')
                endif
            elseif !empty(buftype)
                call win_execute(winid, 'call StatuslineDetect("Other")')
            else
                let g:cheerful_struct_mainwin = winid
                call win_execute(winid, 'call StatuslineDetect("Main")')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " cheerful#StructResize
    " --------------------------------------------------
    function cheerful#StructResize()
        call cheerful#StructInit()
        if g:cheerful_struct_mainwin > 0
            let l:winid_original = bufwinid('%')
            " check layout
            let winlist = getwininfo()
            for [kc, vc] in items(g:cheerful_struct_setname)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'info'
                        call win_execute(winid, 'silent wincmd L')
                        if g:cheerful_struct_setnohi[kc] == 1
                            call win_execute(winid, 'setlocal nocursorline')
                            call win_execute(winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'output'
                        call win_execute(winid, 'silent wincmd J')
                        if g:cheerful_struct_setnohi[kc] == 1
                            call win_execute(winid, 'setlocal nocursorline')
                            call win_execute(winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'tab'
                        call win_execute(winid, 'silent wincmd K')
                        if g:cheerful_struct_setnohi[kc] == 1
                            call win_execute(winid, 'setlocal nocursorline')
                            call win_execute(winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'tree'
                        call win_execute(winid, 'silent wincmd H')
                        if g:cheerful_struct_setnohi[kc] == 1
                            call win_execute(winid, 'setlocal nocursorline')
                            call win_execute(winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            " check size
            for [kc, vc] in items(g:cheerful_struct_setname)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'info'
                        call win_execute(winid, 'vertical resize '.g:cheerful_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'output'
                        call win_execute(winid, 'resize '.g:cheerful_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'tab'
                        call win_execute(winid, 'resize '.g:cheerful_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'tree'
                        call win_execute(winid, 'vertical resize '.g:cheerful_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            " fix size
            for [kc, vc] in items(g:cheerful_struct_setname)
                for v in winlist
                    let bufnr = v.bufnr
                    let winnr = v.winnr
                    let winid = v.winid
                    let filetype = getbufvar(v.bufnr, '&filetype')
                    let buftype = getbufvar(v.bufnr, '&buftype')
                    let bufname = bufname(v.bufnr)
                    if filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'info'
                        call win_execute(winid, 'vertical resize '.g:cheerful_struct_setsize[kc])
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
    " cheerful#StructOperate
    " --------------------------------------------------
    function cheerful#StructOperate(name, ope)
        call cheerful#StructInit()
        if g:cheerful_struct_mainwin > 0 && has_key(g:cheerful_struct_setname, a:name)
            let l:winid_original = bufwinid('%')
            " save state
            let set_show = {}
            for [kc, vc] in items(g:cheerful_struct_setshow)
                let set_show[kc] = g:cheerful_struct_setshow[kc]
            endfor
            " handle close
            let winlist = getwininfo()
            for [kc, vc] in items(g:cheerful_struct_setname)
                if !empty(g:cheerful_struct_setcoth[a:name]) && index(g:cheerful_struct_setcoth[a:name], kc) != -1
                    if set_show[kc] == 1
                        silent exe g:cheerful_struct_setclse[kc]
                    endif
                endif
            endfor
            " handle state
            if a:ope == 'open'
                silent exe g:cheerful_struct_setopen[a:name]
            elseif a:ope == 'close'
                silent exe g:cheerful_struct_setclse[a:name]
            endif
            " handle restore
            for [kc, vc] in items(g:cheerful_struct_setname)
                if !empty(g:cheerful_struct_setcoth[a:name]) && index(g:cheerful_struct_setcoth[a:name], kc) != -1
                    if set_show[kc] == 1
                        silent exe g:cheerful_struct_setopen[kc]
                    endif
                endif
            endfor
            " resize struct
            call cheerful#StructResize()
            " back winid
            if l:winid_original != bufwinid('%')
                call win_gotoid(l:winid_original)
            endif
        endif
    endfunction

    " --------------------------------------------------
    " cheerful#StructTree
    " --------------------------------------------------
    function cheerful#StructTree()
        call cheerful#StructInit()
        call win_gotoid(g:cheerful_struct_mainwin)
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
            for [k, v] in items(g:cheerful_struct_setname)
                if g:cheerful_struct_settype[k] == filetype
                    let if_have = 1
                    break
                endif
            endfor
            if if_have != 1 && !empty(buftype)
                call win_execute(winid, 'close')
            endif
        endfor
        " operate win
        for [k, v] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[k] == 'tree'
                call cheerful#StructOperate(k, 'open')
                break
            endif
        endfor
        for [k, v] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[k] == 'tab'
                call cheerful#StructOperate(k, 'open')
                break
            endif
        endfor
        for [k, v] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[k] == 'output'
                call cheerful#StructOperate(k, 'close')
            endif
        endfor
        for [k, v] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[k] == 'info'
                call cheerful#StructOperate(k, 'close')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " cheerful#StructOutput
    " --------------------------------------------------
    function cheerful#StructOutput()
        call cheerful#StructInit()
        call win_gotoid(g:cheerful_struct_mainwin)
        for [k, v] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[k] == 'output'
                if g:cheerful_struct_setshow[k] == 0
                    call cheerful#StructOperate(k, 'open')
                else
                    call cheerful#StructOperate(k, 'close')
                endif
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " cheerful#StructInfo
    " --------------------------------------------------
    function cheerful#StructInfo()
        call cheerful#StructInit()
        call win_gotoid(g:cheerful_struct_mainwin)
        for [k, v] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[k] == 'info'
                if g:cheerful_struct_setshow[k] == 0
                    call cheerful#StructOperate(k, 'open')
                else
                    call cheerful#StructOperate(k, 'close')
                endif
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " cheerful#StructClear
    " --------------------------------------------------
    function cheerful#StructClear()
        call cheerful#StructInit()
        call win_gotoid(g:cheerful_struct_mainwin)
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
            for [k, v] in items(g:cheerful_struct_setname)
                if g:cheerful_struct_settype[k] == filetype
                    let if_have = 1
                    break
                endif
            endfor
            if if_have != 1 && !empty(buftype)
                call win_execute(winid, 'close')
            endif
        endfor
        " operate win
        for [k, v] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[k] == 'tree'
                call cheerful#StructOperate(k, 'close')
            endif
        endfor
        for [k, v] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[k] == 'tab'
                call cheerful#StructOperate(k, 'open')
            endif
        endfor
        for [k, v] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[k] == 'output'
                call cheerful#StructOperate(k, 'close')
            endif
        endfor
        for [k, v] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[k] == 'info'
                call cheerful#StructOperate(k, 'close')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " cheerful#StructDebug
    " --------------------------------------------------
    function cheerful#StructDebug()
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
    " CheerfulStructCmd
    " --------------------------------------------------
    augroup CheerfulCmdStruct
        autocmd!
        autocmd BufEnter,BufWritePost * call cheerful#StructInit()
        autocmd VimResized * call cheerful#StructResize()
        autocmd VimEnter * call cheerful#StructTree()
    augroup END
endif

" ============================================================================
" 02: cheerful_reopen detail
" g:cheerful_reopen_enabled = 1
" ============================================================================
if exists('g:cheerful_reopen_enabled') && g:cheerful_reopen_enabled == 1

    " --------------------------------------------------
    " g:cheerful_reopen_file
    " --------------------------------------------------
    if !exists('g:cheerful_reopen_setpath') || g:cheerful_reopen_setpath == ""
        let g:cheerful_reopen_file = $HOME."/.vim/cheerful/reopen_filelist"
    else
        let g:cheerful_reopen_file = g:cheerful_reopen_setpath."/reopen_filelist"
    endif

    " --------------------------------------------------
    " cheerful#ReopenBuild
    " --------------------------------------------------
    function! cheerful#ReopenBuild(buf)
        if !isdirectory(g:cheerful_reopen_setpath)
            call mkdir(g:cheerful_reopen_setpath, 'p', 0777)
        endif
        if filereadable(g:cheerful_reopen_file)
            let savelist = []
            let bufname = fnamemodify(bufname(a:buf), ':p')
            let buflist = getbufinfo({'buflisted':1})
            let bnrlist = map(copy(buflist), 'v:val.bufnr')
            if index(bnrlist, a:buf) != -1
                for v in buflist
                    if !empty(v.name)
                        if v.name == bufname
                            call add(savelist, v.name."*C*1*1*1")
                        else
                            call add(savelist, v.name."*X*1*1*1")
                        endif
                    endif
                endfor
                let g:cheerful_reopen_data = savelist
                call writefile(g:cheerful_reopen_data, g:cheerful_reopen_file, 'b')
            endif
        endif
    endfunction

    " --------------------------------------------------
    " cheerful#ReopenClose
    " --------------------------------------------------
    function! cheerful#ReopenClose(buf)
        if !isdirectory(g:cheerful_reopen_setpath)
            call mkdir(g:cheerful_reopen_setpath, 'p', 0777)
        endif
        if filereadable(g:cheerful_reopen_file)
            let savelist = []
            let g:cheerful_reopen_data = readfile(g:cheerful_reopen_file)
            for v in g:cheerful_reopen_data
                let rec = split(v, '*')
                if (rec[0] != a:buf)
                    call add(savelist, rec[0]."*X*".rec[2]."*".rec[3]."*".rec[4]."")
                endif
            endfor
            let g:cheerful_reopen_data = savelist
            call writefile(g:cheerful_reopen_data, g:cheerful_reopen_file, 'b')
        endif
    endfunction

    " --------------------------------------------------
    " cheerful#ReopenRestore
    " --------------------------------------------------
    function! cheerful#ReopenRestore()
        if !isdirectory(g:cheerful_reopen_setpath)
            call mkdir(g:cheerful_reopen_setpath, 'p', 0777)
        endif
        if filereadable(g:cheerful_reopen_file)
            let savelist = []
            let currfile = ''
            let g:cheerful_reopen_data = readfile(g:cheerful_reopen_file)
            for v in g:cheerful_reopen_data
                let rec = split(v, '*')
                if exists("rec[0]") && rec[0] != "" && filereadable(rec[0])
                    silent exe "edit ".rec[0]
                    if rec[1] == 'C'
                        let currfile = rec[0]
                    endif
                endif
            endfor
            if !empty(currfile)
                silent exe "edit ".currfile
            endif
        endif
    endfunction

    " --------------------------------------------------
    " cheerful#ReopenBldcmd
    " --------------------------------------------------
    function! cheerful#ReopenBldcmd()
        augroup CheerfulCmdReopenBldcmd
            autocmd!
            autocmd BufAdd,BufEnter * nested call cheerful#ReopenBuild(str2nr(expand('<abuf>')))
            autocmd BufDelete * nested call cheerful#ReopenClose(expand('<afile>:p'))
        augroup END
    endfunction

    " --------------------------------------------------
    " CheerfulCmdReopen
    " --------------------------------------------------
    augroup CheerfulCmdReopen
        autocmd!
        autocmd VimEnter * nested call cheerful#ReopenBldcmd()
        autocmd VimEnter * nested call cheerful#ReopenRestore()
    augroup END
endif

" ============================================================================
" Other
" ============================================================================
let &cpoptions = s:save_cpo
unlet s:save_cpo
