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

if !hlexists('SpecialcolorMatchtag') | highlight default link StatusLine_0 StatusLine | endif
if !hlexists('SpecialcolorMatchtag') | highlight default StatusLine_1 ctermfg=Green     ctermbg=DarkGreen cterm=NONE guifg=#A3D97D guibg=#467623 gui=NONE | endif
if !hlexists('SpecialcolorMatchtag') | highlight default StatusLine_2 ctermfg=Black     ctermbg=DarkGray  cterm=NONE guifg=#59647A guibg=#171c22 gui=NONE | endif
if !hlexists('SpecialcolorMatchtag') | highlight default StatusLine_3 ctermfg=DarkGreen ctermbg=Gray      cterm=NONE guifg=#006400 guibg=#1D2228 gui=NONE | endif
if !hlexists('SpecialcolorMatchtag') | highlight default StatusLine_4 ctermfg=Blue      ctermbg=LightGray cterm=NONE guifg=#1E5791 guibg=#21252b gui=NONE | endif
if !hlexists('SpecialcolorMatchtag') | highlight default StatusLine_5 ctermfg=Red       ctermbg=LightGray cterm=NONE guifg=#A2000C guibg=#171C22 gui=NONE | endif
if !hlexists('SpecialcolorMatchtag') | highlight default StatusLine_6 ctermfg=DarkGreen ctermbg=LightGray cterm=NONE guifg=#006400 guibg=#171C22 gui=NONE | endif
if !hlexists('SpecialcolorMatchtag') | highlight default StatusLine_7 ctermfg=Blue      ctermbg=LightGray cterm=NONE guifg=#1E5791 guibg=#171C22 gui=NONE | endif
if !hlexists('SpecialcolorMatchtag') | highlight default StatusLine_8 ctermfg=Red       ctermbg=LightGray cterm=NONE guifg=#A2000C guibg=#171C22 gui=NONE | endif

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
        let l:winlist = getwininfo()
        for [kc, vc] in items(g:cheerful_struct_setname)
            let g:cheerful_struct_setshow[kc] = 0
            for il in l:winlist
                let l:bufnr = il.bufnr
                let l:winnr = il.winnr
                let l:winid = il.winid
                let l:filetype = getbufvar(il.bufnr, '&filetype')
                let l:buftype = getbufvar(il.bufnr, '&buftype')
                let l:bufname = bufname(il.bufnr)
                if l:filetype == g:cheerful_struct_settype[kc]
                    let g:cheerful_struct_setshow[kc] = 1
                endif
            endfor
        endfor
        " set filetype
        let l:winlist = getwininfo()
        for [kc, vc] in items(g:cheerful_struct_setname)
            if !empty(g:cheerful_struct_setbuff[kc])
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:bufname == g:cheerful_struct_setbuff[kc]
                        call win_execute(l:winid, 'set filetype='.g:cheerful_struct_settype[kc])
                    endif
                endfor
            endif
        endfor
        " set statusline
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnr = il.bufnr
            let l:winnr = il.winnr
            let l:winid = il.winid
            let l:filetype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            let l:searchkey = ''
            for [kc, vc] in items(g:cheerful_struct_setname)
                if g:cheerful_struct_settype[kc] == l:filetype
                    let l:searchkey = kc
                    break
                endif
            endfor
            if !empty(l:searchkey)
                if g:cheerful_struct_setstat[l:searchkey] == 1
                    call win_execute(l:winid, 'call cheerful#StructStatusline(g:cheerful_struct_setpart[l:searchkey])')
                endif
            elseif !empty(l:buftype)
                call win_execute(l:winid, 'call cheerful#StructStatusline("other")')
            else
                let g:cheerful_struct_mainwin = l:winid
                call win_execute(l:winid, 'call cheerful#StructStatusline("main")')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " cheerful#StructStatusline
    " --------------------------------------------------
    function! cheerful#StructStatusline(...)
        let l:stacon = exists('a:1') ? a:1 : ''
        if (l:stacon == 'tree')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#[%{cheerful#StructStatusname()}]%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'tab')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#[%{cheerful#StructStatusname()}]%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_7#\ [*:%{len(filter(range(1,bufnr('$')),'buflisted(v:val)'))}]%#StatusLine_7#
            setlocal statusline+=%#StatusLine_8#%{len(filter(range(1,bufnr('$')),'getbufvar(v:val,''&modified'')'))>0?'\ [+:'.len(filter(range(1,bufnr('$')),'getbufvar(v:val,''&modified'')')).']':''}%#StatusLine_8#

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'output')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#[%{cheerful#StructStatusname()}]%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_7#%{exists('w:quickfix_title')?'\ ['.w:quickfix_title.']':''}%#StatusLine_7#

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'info')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#[%{cheerful#StructStatusname()}]%#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'other')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_2#%F%#StatusLine_2#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %12.(%l,%c%V%)\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        elseif (l:stacon == 'main')
            setlocal  statusline=%#StatusLine_0#
            setlocal statusline+=%#StatusLine_1#\ %{(has_key(g:set_status_list['modelist'],mode())?g:set_status_list['modelist'][mode()]:mode())}\ %#StatusLine_1#
            setlocal statusline+=%#StatusLine_2#\ %F\ %#StatusLine_2#
            setlocal statusline+=%#StatusLine_0#%<

            setlocal statusline+=%#StatusLine_3#\ %{(!empty(&filetype)?&filetype:'unkonw')}\ %#StatusLine_3#
            setlocal statusline+=%#StatusLine_4#\ %{(&fileencoding).(&bomb?',BOM':'').(':'.&fileformat)}\ %#StatusLine_4#
            setlocal statusline+=%#StatusLine_5#\ %r%m\ %#StatusLine_5#

            setlocal statusline+=%#StatusLine_0#\ %=\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %([%b\ 0x%B]%)\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %12.(%l,%c%V%)\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#\ %5.P\ %#StatusLine_0#
            setlocal statusline+=%#StatusLine_0#
        endif
        return &statusline
    endfunction

    " --------------------------------------------------
    " cheerful#StructStatusname
    " --------------------------------------------------
    function! cheerful#StructStatusname(...)
        let l:filetype = getbufvar(bufnr('%'), '&filetype')
        let l:buftype = getbufvar(bufnr('%'), '&buftype')
        let l:staname = l:filetype
        for [kc, vc] in items(g:cheerful_struct_setname)
            if !empty(g:cheerful_struct_settype[kc]) && !empty(l:buftype) && g:cheerful_struct_settype[kc] == l:filetype
                let l:staname = g:cheerful_struct_setname[kc]
                break
            endif
        endfor
        return l:staname
    endfunction

    " --------------------------------------------------
    " cheerful#StructResize
    " --------------------------------------------------
    function cheerful#StructResize()
        call cheerful#StructInit()
        if g:cheerful_struct_mainwin > 0
            let l:winid_original = bufwinid('%')
            " check layout
            let l:winlist = getwininfo()
            for [kc, vc] in items(g:cheerful_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'info'
                        call win_execute(l:winid, 'silent wincmd L')
                        if g:cheerful_struct_setnohi[kc] == 1
                            call win_execute(l:winid, 'setlocal nocursorline')
                            call win_execute(l:winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'output'
                        call win_execute(l:winid, 'silent wincmd J')
                        if g:cheerful_struct_setnohi[kc] == 1
                            call win_execute(l:winid, 'setlocal nocursorline')
                            call win_execute(l:winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'tab'
                        call win_execute(l:winid, 'silent wincmd K')
                        if g:cheerful_struct_setnohi[kc] == 1
                            call win_execute(l:winid, 'setlocal nocursorline')
                            call win_execute(l:winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'tree'
                        call win_execute(l:winid, 'silent wincmd H')
                        if g:cheerful_struct_setnohi[kc] == 1
                            call win_execute(l:winid, 'setlocal nocursorline')
                            call win_execute(l:winid, 'setlocal nocursorcolumn')
                        endif
                        break
                    endif
                endfor
            endfor
            " check size
            for [kc, vc] in items(g:cheerful_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'info'
                        call win_execute(l:winid, 'vertical resize '.g:cheerful_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'output'
                        call win_execute(l:winid, 'resize '.g:cheerful_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'tab'
                        call win_execute(l:winid, 'resize '.g:cheerful_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            for [kc, vc] in items(g:cheerful_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'tree'
                        call win_execute(l:winid, 'vertical resize '.g:cheerful_struct_setsize[kc])
                        break
                    endif
                endfor
            endfor
            " fix size
            for [kc, vc] in items(g:cheerful_struct_setname)
                for il in l:winlist
                    let l:bufnr = il.bufnr
                    let l:winnr = il.winnr
                    let l:winid = il.winid
                    let l:filetype = getbufvar(il.bufnr, '&filetype')
                    let l:buftype = getbufvar(il.bufnr, '&buftype')
                    let l:bufname = bufname(il.bufnr)
                    if l:filetype == g:cheerful_struct_settype[kc] && g:cheerful_struct_setpart[kc] == 'info'
                        call win_execute(l:winid, 'vertical resize '.g:cheerful_struct_setsize[kc])
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
            let l:setshow = {}
            for [kc, vc] in items(g:cheerful_struct_setshow)
                let l:setshow[kc] = g:cheerful_struct_setshow[kc]
            endfor
            " handle close
            let l:winlist = getwininfo()
            for [kc, vc] in items(g:cheerful_struct_setname)
                if !empty(g:cheerful_struct_setcoth[a:name]) && index(g:cheerful_struct_setcoth[a:name], kc) != -1
                    if l:setshow[kc] == 1
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
                    if l:setshow[kc] == 1
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
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnr = il.bufnr
            let l:winnr = il.winnr
            let l:winid = il.winid
            let l:filetype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            let l:ifhave = 0
            for [kc, vc] in items(g:cheerful_struct_setname)
                if g:cheerful_struct_settype[kc] == l:filetype
                    let l:ifhave = 1
                    break
                endif
            endfor
            if l:ifhave != 1 && !empty(l:buftype)
                call win_execute(l:winid, 'close')
            endif
        endfor
        " operate win
        for [kc, vc] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[kc] == 'tree'
                call cheerful#StructOperate(kc, 'open')
                break
            endif
        endfor
        for [kc, vc] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[kc] == 'tab'
                call cheerful#StructOperate(kc, 'open')
                break
            endif
        endfor
        for [kc, vc] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[kc] == 'output'
                call cheerful#StructOperate(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[kc] == 'info'
                call cheerful#StructOperate(kc, 'close')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " cheerful#StructOutput
    " --------------------------------------------------
    function cheerful#StructOutput()
        call cheerful#StructInit()
        call win_gotoid(g:cheerful_struct_mainwin)
        for [kc, vc] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[kc] == 'output'
                if g:cheerful_struct_setshow[kc] == 0
                    call cheerful#StructOperate(kc, 'open')
                else
                    call cheerful#StructOperate(kc, 'close')
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
        for [kc, vc] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[kc] == 'info'
                if g:cheerful_struct_setshow[kc] == 0
                    call cheerful#StructOperate(kc, 'open')
                else
                    call cheerful#StructOperate(kc, 'close')
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
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnr = il.bufnr
            let l:winnr = il.winnr
            let l:winid = il.winid
            let l:filetype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            let l:ifhave = 0
            for [kc, vc] in items(g:cheerful_struct_setname)
                if g:cheerful_struct_settype[kc] == l:filetype
                    let l:ifhave = 1
                    break
                endif
            endfor
            if l:ifhave != 1 && !empty(l:buftype)
                call win_execute(l:winid, 'close')
            endif
        endfor
        " operate win
        for [kc, vc] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[kc] == 'tree'
                call cheerful#StructOperate(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[kc] == 'tab'
                call cheerful#StructOperate(kc, 'open')
            endif
        endfor
        for [kc, vc] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[kc] == 'output'
                call cheerful#StructOperate(kc, 'close')
            endif
        endfor
        for [kc, vc] in items(g:cheerful_struct_setname)
            if g:cheerful_struct_setpart[kc] == 'info'
                call cheerful#StructOperate(kc, 'close')
            endif
        endfor
    endfunction

    " --------------------------------------------------
    " cheerful#StructDebug
    " --------------------------------------------------
    function cheerful#StructDebug()
        echo printf("= %-8s = %-8s = %-8s = %-16s = %-16s = %-16s", 'bufnr', 'winnr', 'winid', 'filetype', 'buftype', 'bufname')
        let l:winlist = getwininfo()
        for il in l:winlist
            let l:bufnr = il.bufnr
            let l:winnr = il.winnr
            let l:winid = il.winid
            let l:filetype = getbufvar(il.bufnr, '&filetype')
            let l:buftype = getbufvar(il.bufnr, '&buftype')
            let l:bufname = bufname(il.bufnr)
            echo printf("> %-8d > %-8d > %-8d > %-16s > %-16s > %-16s", l:bufnr, l:winnr, l:winid, l:filetype, l:buftype, l:bufname)
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
            let l:savelist = []
            let l:bufname = fnamemodify(bufname(a:buf), ':p')
            let l:buflist = getbufinfo({'buflisted':1})
            let l:bnrlist = map(copy(l:buflist), 'v:val.bufnr')
            if index(l:bnrlist, a:buf) != -1
                for il in l:buflist
                    if !empty(il.name)
                        if il.name == l:bufname
                            call add(l:savelist, il.name."*C*1*1*1")
                        else
                            call add(l:savelist, il.name."*X*1*1*1")
                        endif
                    endif
                endfor
                let g:cheerful_reopen_data = l:savelist
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
            let l:savelist = []
            let g:cheerful_reopen_data = readfile(g:cheerful_reopen_file)
            for il in g:cheerful_reopen_data
                let l:rec = split(il, '*')
                if (l:rec[0] != a:buf)
                    call add(l:savelist, l:rec[0]."*X*".l:rec[2]."*".l:rec[3]."*".l:rec[4]."")
                endif
            endfor
            let g:cheerful_reopen_data = l:savelist
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
            let l:savelist = []
            let l:currfile = ''
            let g:cheerful_reopen_data = readfile(g:cheerful_reopen_file)
            for il in g:cheerful_reopen_data
                let l:rec = split(il, '*')
                if exists("l:rec[0]") && l:rec[0] != "" && filereadable(l:rec[0])
                    silent exe "edit ".l:rec[0]
                    if l:rec[1] == 'C'
                        let l:currfile = l:rec[0]
                    endif
                endif
            endfor
            if !empty(l:currfile)
                silent exe "edit ".l:currfile
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
