# vim-cheerful

## A Vim Plugin for Enhanced Window Management
Cheerful.vim is a Vim plugin designed to provide enhanced window management capabilities, helping users maintain an organized and efficient workspace. The plugin offers two main features:
- Window Structure Management: Helps organize different types of windows (tree, tab, output, info) in a consistent layout.
- Session Restoration: Remembers and restores your open files.

## Features
- Window Structure Management (cheerful_struct)
    - Organizes windows into different parts: tree, tab, output, info panels
    - Automatically resizes and positions windows
    - Maintains window layout consistency
    - Provides commands to toggle different window types
    - Customizable window behaviors and appearances

- Session Restoration (cheerful_reopen)
    - Saves and restores open files between sessions
    - Configurable storage location for session files

## Screenshot
![Viewmap Screenshot](https://github.com/bleakwind/vim-cheerful/blob/main/vim-cheerful-struct.png)

## Requirements
Recommended Vim 8.1+

## Installation
```vim
" Using Vundle
Plugin 'bleakwind/vim-cheerful'
```

And Run:
```vim
:PluginInstall
```
## Configuration
Add these to your `.vimrc`:

cheerful_struct
```vim
" Set 1 enable cheerful_struct (default: 0)
let g:cheerful_struct_enabled = 1
" Mapping of component identifiers to display names
let g:cheerful_struct_setname[xxx]  = ''
" Filetype associations for each component
let g:cheerful_struct_settype[xxx]  = ''
" Window position type: 'tree' (left), 'info' (right), 'output' (bottom), 'tab' (top)
let g:cheerful_struct_setpart[xxx]  = ''
" Buffer names for specific component identification
let g:cheerful_struct_setbuff[xxx]  = ''
" Related components that should be operated together
let g:cheerful_struct_setcoth[xxx]  = []
" Initial size (rows/columns) for each component
let g:cheerful_struct_setsize[xxx]  = xx
" Commands to open specific components
let g:cheerful_struct_setopen[xxx]  = ''
" Commands to close specific components
let g:cheerful_struct_setclse[xxx]  = ''
" Disable cursor highlighting in window (1=disable, 0=enable)
let g:cheerful_struct_setnohi[xxx] = xx
" Show special status in statusline (1=show, 0=hide)
let g:cheerful_struct_setstat[xxx] = xx
" Current visibility state of components (1=visible, 0=hidden)
let g:cheerful_struct_setshow[xxx] = xx
```

cheerful_struct: For example, I used these 4 Vim plugins: Nerdtree, Minibufexpl, Quickfix, Vim Viewmap. Here is my config:
```vim
let g:cheerful_struct_setname                       = {}
let g:cheerful_struct_settype                       = {}
let g:cheerful_struct_setpart                       = {}
let g:cheerful_struct_setbuff                       = {}
let g:cheerful_struct_setcoth                       = {}
let g:cheerful_struct_setsize                       = {}
let g:cheerful_struct_setopen                       = {}
let g:cheerful_struct_setclse                       = {}
let g:cheerful_struct_setnohi                       = {}
let g:cheerful_struct_setstat                       = {}
let g:cheerful_struct_setshow                       = {}

let g:cheerful_struct_setname['nerdtree']           = 'Filelist'
let g:cheerful_struct_settype['nerdtree']           = 'nerdtree'
let g:cheerful_struct_setpart['nerdtree']           = 'tree'
let g:cheerful_struct_setbuff['nerdtree']           = ''
let g:cheerful_struct_setcoth['nerdtree']           = []
let g:cheerful_struct_setsize['nerdtree']           = 30
let g:cheerful_struct_setopen['nerdtree']           = 'NERDTree'
let g:cheerful_struct_setclse['nerdtree']           = 'NERDTreeClose'
let g:cheerful_struct_setnohi['nerdtree']           = 0
let g:cheerful_struct_setstat['nerdtree']           = 0
let g:cheerful_struct_setshow['nerdtree']           = 0

let g:cheerful_struct_setname['minibufexpl']        = 'Bufferlist'
let g:cheerful_struct_settype['minibufexpl']        = 'minibufexpl'
let g:cheerful_struct_setpart['minibufexpl']        = 'tab'
let g:cheerful_struct_setbuff['minibufexpl']        = ''
let g:cheerful_struct_setcoth['minibufexpl']        = []
let g:cheerful_struct_setsize['minibufexpl']        = 1
let g:cheerful_struct_setopen['minibufexpl']        = 'MBEOpen'
let g:cheerful_struct_setclse['minibufexpl']        = 'MBEClose'
let g:cheerful_struct_setnohi['minibufexpl']        = 1
let g:cheerful_struct_setstat['minibufexpl']        = 0
let g:cheerful_struct_setshow['minibufexpl']        = 0

let g:cheerful_struct_setname['quickfix']           = 'Quickfix'
let g:cheerful_struct_settype['quickfix']           = 'qf'
let g:cheerful_struct_setpart['quickfix']           = 'output'
let g:cheerful_struct_setbuff['quickfix']           = ''
let g:cheerful_struct_setcoth['quickfix']           = []
let g:cheerful_struct_setsize['quickfix']           = 10
let g:cheerful_struct_setopen['quickfix']           = 'botright copen '.g:cheerful_struct_setsize['quickfix']
let g:cheerful_struct_setclse['quickfix']           = 'cclose'
let g:cheerful_struct_setnohi['quickfix']           = 0
let g:cheerful_struct_setstat['quickfix']           = 1
let g:cheerful_struct_setshow['quickfix']           = 0

let g:cheerful_struct_setname['viewmap']            = 'Codemap'
let g:cheerful_struct_settype['viewmap']            = 'viewmap'
let g:cheerful_struct_setpart['viewmap']            = 'info'
let g:cheerful_struct_setbuff['viewmap']            = 'vim-viewmap'
let g:cheerful_struct_setcoth['viewmap']            = []
let g:cheerful_struct_setsize['viewmap']            = 20
let g:cheerful_struct_setopen['viewmap']            = 'ViewmapOpen'
let g:cheerful_struct_setclse['viewmap']            = 'ViewmapClose'
let g:cheerful_struct_setnohi['viewmap']            = 1
let g:cheerful_struct_setstat['viewmap']            = 1
let g:cheerful_struct_setshow['viewmap']            = 0
```

cheerful_reopen
```vim
" Set 1 enable cheerful_reopen (default: 0)
let g:cheerful_reopen_enabled = 1
" Set cheerful_reopen save place
let g:cheerful_reopen_setpath = g:config_dir_data.'cheerful'
```

## Usage
| Command                         | Description                       |
| ------------------------------- | --------------------------------- |
| `:call cheerful#StructTree()`   | Display only tree and tab windows |
| `:call cheerful#StructOutput()` | Toggle output window visibility   |
| `:call cheerful#StructInfo()`   | Toggle info window visibility     |
| `:call cheerful#StructClear()`  | Display only tab windows          |

For example, I would like map these:
| Command                                      | Description                       |
| -------------------------------------------- | --------------------------------- |
| `map <F5> :call cheerful#StructTree()<CR>`   | Display only tree and tab windows |
| `map <F6> :call cheerful#StructOutput()<CR>` | Toggle output window visibility   |
| `map <F7> :call cheerful#StructInfo()<CR>`   | Toggle info window visibility     |
| `map <F8> :call cheerful#StructClear()<CR>`  | Display only tab windows          |

## License
BSD 2-Clause - See LICENSE file

