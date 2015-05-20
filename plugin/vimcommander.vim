"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Name:         vimcommander
" Version:      $VERSION
" Description:  total-commander-like file manager for vim.
" Author:       Leandro Penz <lpenz AT terra DOT com DOT br>
" Maintainer:   Leandro Penz <lpenz AT terra DOT com DOT br>
" Url:          http://www.vim.org/scripts/script.php?script_id=808
" Licence:      This program is free software; you can redistribute it
"                   and/or modify it under the terms of the GNU General Public
"                   License.  See http://www.gnu.org/copyleft/gpl.txt
" Credits:      Patrick Schiel, the author of Opsplorer.vim
"                   (http://www.vim.org/scripts/script.php?script_id=362)
"                   in which this script is based,
"               Christian Ghisler, the author of Total Commander, for the best
"                   *-commander around. (http://www.ghisler.com)
"               Mathieu Clabaut <mathieu.clabaut at free dot fr>, the author
"                    of vimspell, from where I got how to autogenerate the
"                    help from within the script.
"               Diego Morales, fixes and suggestions.
"               Vladim�r Marek <vlmarek at volny dot cz>, fix for files with
"                    with spaces and refactoring.
"               Oleg Popov <dev-random at mail dot ru>, fix for browsing
"                    hidden files.
"               Lajos Zaccomer <lajos@zaccomer.org>, custom starting paths,
"                    change dir dialog, windows fixes, etc.
"               Zoltan Dezso <dezso.zoltan@gmail.co>, windows fix for parent
"                    directory traversal, add total commander-like C-PageUp
"               Denis <woofterrier@gmail.com>, for windows fixes.
"               Helmut Stiegler <helmut@stiegler.biz>, for cygwin fixes.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Documentation
"
" Documentation should be available by ":help vimcommander" command, once the
" script has been installed.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Code
"

" PROGRAM_NAME = "vimcommander"
" PROGRAM_VERSION = "1.0"

" Check if we should continue loading
if exists("g:loaded_vimcommander")
    finish
endif
let g:loaded_vimcommander = 1

noremap <silent> <unique> <Plug>VimCommanderBuildParentTree        :cal <SID>BuildParentTree()<CR>
noremap <silent> <unique> <Plug>VimCommanderBuildTreeHome          :cal <SID>BuildTree("$HOME")<CR>
noremap <silent> <unique> <Plug>VimCommanderBuildTreeRoot          :cal <SID>BuildTree("/")<CR>
noremap <silent> <unique> <Plug>VimCommanderChangeDir              :cal <SID>ChangeDir()<CR>
noremap <silent> <unique> <Plug>VimCommanderDeSelectPatternAsk     :cal <SID>DeSelectPatternAsk()<CR>
noremap <silent> <unique> <Plug>VimCommanderDeSelectPattern        :cal <SID>DeSelectPattern('*')<CR>
noremap <silent> <unique> <Plug>VimCommanderDirCreate              :cal <SID>DirCreate()<CR>
noremap <silent> <unique> <Plug>VimCommanderExchangeDirs           :cal <SID>ExchangeDirs()<CR>
noremap <silent> <unique> <Plug>VimCommanderFileCopy_0             :cal <SID>FileCopy(0)<CR>
noremap <silent> <unique> <Plug>VimCommanderFileCopy_1             :cal <SID>FileCopy(1)<CR>
noremap <silent> <unique> <Plug>VimCommanderFileDelete             :cal <SID>FileDelete()<CR>
noremap <silent> <unique> <Plug>VimCommanderFileEdit               :cal <SID>FileEdit()<CR>
noremap <silent> <unique> <Plug>VimCommanderFileMove_0             :cal <SID>FileMove(0)<CR>
noremap <silent> <unique> <Plug>VimCommanderFileMove_1             :cal <SID>FileMove(1)<CR>
noremap <silent> <unique> <Plug>VimCommanderFileView               :cal <SID>FileView()<CR>
noremap <silent> <unique> <Plug>VimCommanderGetOrPutDir_l          :cal <SID>GetOrPutDir('l')<CR>
noremap <silent> <unique> <Plug>VimCommanderGetOrPutDir_r          :cal <SID>GetOrPutDir('r')<CR>
noremap <silent> <unique> <Plug>VimCommanderGotoNextEntry          :cal <SID>GotoNextEntry()
noremap <silent> <unique> <Plug>VimCommanderGotoNextNode           :cal <SID>GotoNextNode()<CR>
noremap <silent> <unique> <Plug>VimCommanderGotoPrevEntry          :cal <SID>GotoPrevEntry()
noremap <silent> <unique> <Plug>VimCommanderGotoPrevNode           :cal <SID>GotoPrevNode()<CR>
noremap <silent> <unique> <Plug>VimCommanderNewFileEdit            :cal <SID>NewFileEdit()<CR>
noremap <silent> <unique> <Plug>VimCommanderNextDir                :cal <SID>NextDir()<CR>
noremap <silent> <unique> <Plug>VimCommanderPrevDir                :cal <SID>PrevDir()<CR>
noremap <silent> <unique> <Plug>VimCommanderPutDir                 :cal <SID>PutDir()<CR>
noremap <silent> <unique> <Plug>VimCommanderRefreshDisplays        :cal <SID>RefreshDisplays()<CR>
noremap <silent> <unique> <Plug>VimCommanderSelect                 :cal <SID>Select()<CR>
noremap <silent> <unique> <Plug>VimCommanderSelectPatternAsk       :cal <SID>SelectPatternAsk()<CR>
noremap <silent> <unique> <Plug>VimCommanderSelectPattern          :cal <SID>SelectPattern('*')<CR>
noremap <silent> <unique> <Plug>VimCommanderSetMatchPattern        :cal <SID>SetMatchPattern()<CR>
noremap <silent> <unique> <Plug>VimCommanderShowHiddenFilesToggle  :cal <SID>ShowHiddenFilesToggle()<CR>
noremap <silent> <unique> <Plug>VimCommanderSwitchBuffer           :cal <SID>SwitchBuffer()<CR>
noremap <silent> <unique> <Plug>VimCommanderSwitchOnClick          :cal <SID>OnClick()<CR>
noremap <silent> <unique> <Plug>VimCommanderSwitchOnDoubleClick    :cal <SID>OnDoubleClick()<CR>
noremap <silent> <unique> <Plug>VimCommanderToggle                 :cal VimCommanderToggle()<CR>

fu! <SID>CommanderMappings()
	map <silent> <buffer> <LeftRelease>    <Plug>VimCommanderOnClick
	map <silent> <buffer> <Insert>         <Plug>VimCommanderSelect
	map <silent> <buffer> <LeftRelease>    <Plug>VimCommanderOnClick
	map <silent> <buffer> <2-LeftMouse>    <Plug>VimCommanderSwitchOnDoubleClick
	map <silent> <buffer> <CR>             <Plug>VimCommanderSwitchOnDoubleClick
	map <silent> <buffer> <Down>           <Plug>VimCommanderGotoNextEntry
	map <silent> <buffer> <Up>             <Plug>VimCommanderGotoPrevEntry
	map <silent> <buffer> <S-Down>         <Plug>VimCommanderGotoNextNode
	map <silent> <buffer> <S-Up>           <Plug>VimCommanderGotoPrevNode
	map <silent> <buffer> <BS>             <Plug>VimCommanderBuildParentTree

	"total-cmd keys:
	map <silent> <buffer> <TAB>            <Plug>VimCommanderSwitchBuffer
	map <silent> <buffer> <C-\>            <Plug>VimCommanderBuildTreeHome
	map <silent> <buffer> <C-/>            <Plug>VimCommanderBuildTreeRoot
	map <silent> <buffer> <leader>/        <Plug>VimCommanderBuildTreeRoot
	"F-keys and aliases:
	map <silent> <buffer> <F3>             <Plug>VimCommanderFileView
	map <silent> <buffer> <F4>             <Plug>VimCommanderFileEdit
	map <silent> <buffer> <S-F4>           <Plug>VimCommanderFileEdit
	map <silent> <buffer> <leader><F4>     <Plug>VimCommanderFileEdit
	map <silent> <buffer> <leader>n        <Plug>VimCommanderFileEdit
	map <silent> <buffer> <F5>             <Plug>VimCommanderFileCopy_0
	map <silent> <buffer> <S-F5>           <Plug>VimCommanderFileCopy_1
	map <silent> <buffer> <F6>             <Plug>VimCommanderFileMove_0
	map <silent> <buffer> <S-F6>           <Plug>VimCommanderFileMove_1
	map <silent> <buffer> <F7>             <Plug>VimCommanderDirCreate
	map <silent> <buffer> <F8>             <Plug>VimCommanderFileDelete
	map <silent> <buffer> <DEL>            <Plug>VimCommanderFileDelete
	map <silent> <buffer> <F10>            <Plug>VimCommanderToggle
	map <silent> <buffer> <F11>            <Plug>VimCommanderToggle
	"Panel-dirs
	map <silent> <buffer> <leader><Left>   <Plug>VimCommanderGetOrPutDir_l
	map <silent> <buffer> <leader><Right>  <Plug>VimCommanderGetOrPutDir_r
	map <silent> <buffer> <C-Left>         <Plug>VimCommanderGetOrPutDir_l
	map <silent> <buffer> <C-Right>        <Plug>VimCommanderGetOrPutDir_r
	map <silent> <buffer> <S-Left>         <Plug>VimCommanderGetOrPutDir_l
	map <silent> <buffer> <S-Right>        <Plug>VimCommanderGetOrPutDir_r
	map <silent> <buffer> <leader>o        <Plug>VimCommanderPutDir
	map <silent> <buffer> <M-O>            <Plug>VimCommanderPutDir
	map <silent> <buffer> <C-U>            <Plug>VimCommanderExchangeDirs
	map <silent> <buffer> <leader>u        <Plug>VimCommanderExchangeDirs
	map <silent> <buffer> <C-R>            <Plug>VimCommanderRefreshDisplays
	map <silent> <buffer> <leader>r        <Plug>VimCommanderRefreshDisplays
	map <silent> <buffer> <leader>h        <Plug>VimCommanderShowHiddenFilesToggle
	"File-selection
	map <silent> <buffer> <C-kPlus>        <Plug>VimCommanderSelectPattern
	map <silent> <buffer> <leader><kPlus>  <Plug>VimCommanderSelectPattern
	map <silent> <buffer> <leader><kMinus> <Plug>VimCommanderDeSelectPattern
	map <silent> <buffer> <kPlus>          <Plug>VimCommanderSelectPatternAsk
	map <silent> <buffer> <kMinus>         <Plug>VimCommanderDeSelectPatternAsk
	map <silent> <buffer> +                <Plug>VimCommanderSelectPatternAsk
	map <silent> <buffer> -                <Plug>VimCommanderDeSelectPatternAsk
	"Dir history
	map <silent> <buffer> <C-t>            <Plug>VimCommanderPrevDir
	map <silent> <buffer> <leader>t        <Plug>VimCommanderPrevDir
	map <silent> <buffer> <C-y>            <Plug>VimCommanderNextDir
	map <silent> <buffer> <leader>y        <Plug>VimCommanderNextDir

	"Misc (some are Opsplorer's)
	map <silent> <buffer> <C-F11>          <Plug>VimCommanderSetMatchPattern
	map <silent> <buffer> <leader><F11>    <Plug>VimCommanderSetMatchPattern
	"map <silent> <buffer> <C-O>            <Plug>VimCommanderToggle
	"map <silent> <buffer> <leader>o        <Plug>VimCommanderToggle

	"ChangeDir dialog, required in windows:
	map <silent> <buffer> <leader>c        <Plug>VimCommanderChangeDir
	map <silent> <buffer> cd               <Plug>VimCommanderChangeDir

	"Directory Up/Down
	map <silent> <buffer> <C-PageUp>       <Plug>VimCommanderBuildParentTree
	map <silent> <buffer> <C-PageDown>     <Plug>VimCommanderSwitchOnDoubleClick
endf

fu! <SID>CustomMappings()
	if filereadable(expand("~/.vimcommander.custom"))
		source ~/.vimcommander.custom
	endif
endf

fu! <SID>ShallUseUnixCmds()
	return has("unix") || exists('+shellslash') && &shellslash
endf

fu! <SID>MsDos(filename)
   return substitute(shellescape(a:filename),'/','\\','g')
endf

fu! <SID>SSHConnect()
	" Created by <Alukardd>
	"
	let g:ssh_dir_list = "/tmp/ssh_dir.list"
	cal system("which sshfs")
 	if v:shell_error
		echo "You should install sshfs utility previously to use this function!"
		return
	endif

	" readfile is called every time that there were no problems in parallel using the function
	if !filereadable(g:ssh_dir_list)
		cal writefile([],g:ssh_dir_list)
	endif

	let start_ssh = 1
	while start_ssh == 1
		let action = input("What are you want to do (mount/dismount/abort) sshfs? [mda]: ")
		if action == "a"
			echo "SSHConnect aborted by keystroke."
			let start_ssh = 0
		elseif action == "d"
			if readfile(g:ssh_dir_list) == []
				echo "No remote host mounted!"
			else
				if readfile(g:ssh_dir_list) == [""]
					echo "No remote host mounted!"
				else
					echo "Choose which mount point you want to dismont: ".readfile(g:ssh_dir_list)[0]
					let ans = input("Enter sequence number of choosen moint point: ")
					if ans =~ '^\d\{1,2\}$'
						if ans > system("gawk -F\\; '{print NF}' ".g:ssh_dir_list)
							echo "Number out of bound!"
							return
						endif
						let ssh_udir = system("gawk -F\\; '{gsub(/\\([^)]*\\)/,\"\",$".ans."); printf $".ans."}' ".g:ssh_dir_list)
						let ssh_udir_name = system("gawk -F\\; '{printf $".ans."}' ".g:ssh_dir_list)
						cal system("fusermount -u ".ssh_udir)
						cal system("rm -rf ".shellescape(ssh_udir))
						" here may be do substitute + readfile + writefile, but i decided to use sed
						cal system("sed --in-place 's/;\\?".escape(ssh_udir_name,'/')."//;s/^;//' ".g:ssh_dir_list)
						cal <SID>RefreshDisplays()
						echo ssh_udir_name." dismounted."
					else
						echo "You're failed."
					endif
				endif
			endif
			let start_ssh = 0
		elseif action == "m"
			let start_ssh = 0
			let cmd = input("Enter remote host address ([identity,][user@]host[:port]): ")
			if cmd == ""
				cal <SID>RefreshDisplays()
				return
			else
				exe "set magic"

				let ssh_cmd = "sshfs "
				let options_line = ""

				" validate ssh address
				if cmd !~ '^\([^,]\+,\|\)\([^@,:]\+@\|\)\([^@,:]\+\)\(:\d\{1,5\}\|\)$'
					echo "Invalid address! You type: ".cmd
					return
				end

				" parse connect string
				let Identity = substitute(cmd,'^\([^,]*,\).*$','\1','')
				let User = substitute(cmd,'^\([^,]\+,\|\)\([^@,:]\+@\|\)\([^@,:]\+\)\(:\d\{1,5\}\|\)$','\2','')
				let Host = substitute(cmd,'^\([^,]\+,\|\)\([^@,:]\+@\|\)\([^@,:]\+\)\(:\d\{1,5\}\|\)$','\3','')
				let Port = substitute(cmd,'^[^:]*:\?\([[:digit:]]\{0,5\}\)$','\1','')

				if Identity != cmd
					"let Identity = ""
				"else
					let Identity = substitute(Identity,",","","")
					let options_line = "-o IdentityFile=\"".Identity."\""
				end
				if User == cmd
					let User = ""
				end
				if Port != ""
					if options_line == ""
						let options_line = "-o Port=".Port
					else
						let options_line = options_line.",Port=".Port
					endif
				end
				
				" Create tmp dir for new mount
				let ssh_dir = "/tmp/".system("cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 12")
				cal system("mkdir ".shellescape(ssh_dir))

				" try to mount
				let ssh_cmd = ssh_cmd.options_line." ".User.Host.":/ ".shellescape(ssh_dir)
				cal system(ssh_cmd)
			 	if !v:shell_error
					if readfile(g:ssh_dir_list) == []
						call writefile([ssh_dir."(".Host.")"],g:ssh_dir_list)
					else
						if readfile(g:ssh_dir_list) == [""]
							call writefile([ssh_dir."(".Host.")"],g:ssh_dir_list)
						else
							call writefile([readfile(g:ssh_dir_list)[0].";".ssh_dir."(".Host.")"],g:ssh_dir_list)
						endif
					end
					cal <SID>BuildTree(ssh_dir)
					cal <SID>RefreshDisplays()
				else
					echo "Failed connect to host.\nYou try: ".ssh_cmd
				endif
			endif
		endif
	endwhile
endf

fu! VimCommanderToggle()
	if exists("g:vimcommander_loaded")
		if(g:vimcommander_loaded==1) " its on screen - close
			cal <SID>Close()
		el " its loaded, but not on screen
			cal <SID>VimCommanderShow()
		end
	el
		cal <SID>First()
	en
endf

fu!<SID>First()
  if <SID>ShallUseUnixCmds()
    let s:slash_char = "/"
  else
    let s:slash_char = "\\"
  endif
	cal <SID>SaveOpts()
	cal <SID>InitOptions()
	let s:path_left = getcwd()
	if exists("g:vimcommander_first_path_left")
		let s:path_left = g:vimcommander_first_path_left
	end
	let s:path_right = getcwd()
	if exists("g:vimcommander_first_path_right")
		let s:path_right = g:vimcommander_first_path_right
	end
	let s:line_right=2
	let s:line_left=2
	let g:vimcommander_lastside="VimCommanderLeft"
	let g:vimcommander_shallcd=0
	cal <SID>VimCommanderShow()
endf

fu! <SID>VimCommanderShow()
	if exists("g:vimcommander_loaded") && g:vimcommander_loaded==1 " on screen
		return
	end
	"close all windows
	let s:buffer_to_load=expand("%:p")
	"let v:errmsg=''
	"while v:errmsg==''
	"	silent! close
	"endwhile
	"reset aucmd
	autocmd! BufEnter VimCommanderLeft
	autocmd! BufEnter VimCommanderRight
	autocmd! BufWinLeave VimCommanderLeft
	autocmd! BufWinLeave VimCommanderRight
	" create new window
	let winsize=&lines
	let s:split_tmp = &l:splitright
	setlocal nosplitright
	exe winsize." split VimCommanderRight"
	resize +999
	let s:bufnr_right=winbufnr(0)
	" setup mappings, apply options, colors and draw tree
	cal <SID>InitCommanderOptions()
	cal <SID>CommanderMappings()
	cal <SID>CustomMappings()
	cal <SID>InitCommanderColors()
	cal <SID>BuildTree(s:path_right)
	cal <SID>GotoEntry(s:line_right)
	exe "vs VimCommanderLeft"
	let s:bufnr_left=winbufnr(0)
	let &l:splitright = s:split_tmp
	cal <SID>InitCommanderOptions()
	cal <SID>CommanderMappings()
	cal <SID>CustomMappings()
	cal <SID>InitCommanderColors()
	cal <SID>BuildTree(s:path_left)
	cal <SID>GotoEntry(s:line_left)
	let g:vimcommander_loaded=1
	"Goto vimcommander window
	let winnum = bufwinnr(s:bufnr_left)
	if winnum != -1
		" Jump to the existing window
		if winnr() != winnum
			exe winnum . 'wincmd w'
		endif
	endif
	if g:vimcommander_lastside=="VimCommanderRight"
		cal <SID>SwitchBuffer()
	end
	"norm! z-
	autocmd BufEnter    VimCommanderLeft  cal <SID>LeftBufEnter()
	autocmd BufEnter    VimCommanderRight cal <SID>RightBufEnter()
	autocmd BufWinLeave VimCommanderLeft  cal VimCommanderToggle()
	autocmd BufWinLeave VimCommanderRight cal VimCommanderToggle()
endf

fu! <SID>GotoEntry(line)
	exe a:line
	norm! 4|
endf

fu! <SID>LeftBufEnter()
	if g:vimcommander_shallcd==1
		exe "cd ".<SID>MyPath()
	end
	let g:vimcommander_lastside="VimCommanderLeft"
endf

fu! <SID>RightBufEnter()
	if g:vimcommander_shallcd==1
		exe "cd ".<SID>MyPath()
	end
	let g:vimcommander_lastside="VimCommanderRight"
endf

fu! <SID>Close()
	autocmd! BufEnter VimCommanderLeft
	autocmd! BufEnter VimCommanderRight
	autocmd! BufWinLeave VimCommanderLeft
	autocmd! BufWinLeave VimCommanderRight
	let winnum = bufwinnr(s:bufnr_left)
	if winnum != -1
		" Jump to the existing window
		if winnr() != winnum
			exe winnum . 'wincmd w'
		endif
	endif
	let s:line_left=line('.')
	silent! close
	let winnum = bufwinnr(s:bufnr_right)
	if winnum != -1
		" Jump to the existing window
		if winnr() != winnum
			exe winnum . 'wincmd w'
		endif
	endif
	let s:line_right=line('.')
	silent! close
	let g:vimcommander_loaded=0
	"if strlen(s:buffer_to_load)>0
	"	exe "edit +buffer ".s:buffer_to_load
	"else
	"	if bufwinnr(s:bufnr_right)!=-1
	"		"exe "new +buffer ".s:buffer_to_load
	"		"exe 'wincmd w'
	"		close
	"	end
	"end
	cal <SID>LoadOpts()
endf

fu! <SID>SaveOpts()
	let s:scrollbind=&scrollbind
	let s:wrap=&wrap
	let s:nu=&nu
	let s:buflisted=&buflisted
	let s:number=&number
	let s:incsearch=&incsearch
endf

fu! <SID>LoadOpts()
	if s:scrollbind==1
		set scrollbind
	else
		set noscrollbind
	end
	if s:wrap==1
		set wrap
	else
		set nowrap
	end
	if s:nu==1
		set nu
	else
		set nonu
	end
	if s:buflisted==1
		set buflisted
	else
		set nobuflisted
	end
	if s:number==1
		set number
	else
		set nonumber
	end
	if s:incsearch==1
		set incsearch
	else
		set noincsearch
	end
endf

fu! <SID>InitCommanderOptions()
	silent! setlocal noscrollbind
	silent! setlocal nowrap
	silent! setlocal nonu
	silent! setlocal buftype=nofile
	silent! setlocal bufhidden=delete
	silent! setlocal noswapfile
	silent! setlocal nobuflisted
	silent! setlocal nonumber
	silent! setlocal incsearch
	let b:vimcommander_selected=""
	let b:vimcommander_prev=""
	let b:vimcommander_next=""
endf

fu! <SID>InitCommanderColors()
	sy clear
	if s:use_colors
		syntax match VimCommanderSelectedFile '^.> .*'
		syntax match VimCommanderSelectedDir '^.>+\w*.*' contained contains=VimCommanderNode
		syntax match VimCommanderPath "^/.*"
		syntax match VimCommanderDirLine "^..+.*" transparent contains=VimCommanderSelectedDir
		syntax match VimCommanderFileLine "^.. \w.*" transparent contains=ALL
		syntax match VimCommanderFile "\w.*" contained
		syntax match VimCommanderSource "^.. \w*.*\.c$" contained
		syntax match VimCommanderHeader "^.. \w*.*\.h$" contained
		syntax match VimCommanderSpecial "^.. \(Makefile\|config.mk\)$" contained
		hi link VimCommanderPath Label
		hi link VimCommanderNode Comment
		"hi link OpsFile Question
		hi link VimCommanderFile Comment
		hi link VimCommanderSource Question
		hi link VimCommanderHeader Include
		hi link VimCommanderSpecial Function
		hi link VimCommanderSelectedFile Visual
		hi link VimCommanderSelectedDir Visual
	en
endf

fu! <SID>SwitchBuffer()
	if winbufnr(0) == s:bufnr_left
		winc l
	else
		winc h
	end
endf

fu! <SID>ProvideBuffer()
	"winc j
	"new
	"cal <SID>LoadOpts()
endf

fu! <SID>FileView()
	let path=<SID>PathUnderCursor()
	if(isdirectory(path))
		return
	end
	let opt=""
	while strlen(name)>0
		if filereadable(filename)
			if <SID>ShallUseUnixCmds()
				cal system("(see ".shellescape(filename).") &")
			else
				exec "silent ! start \"\" \"".substitute(filename, "/", "\\", "g")."\""
			endif
		en
		if strlen(b:vimcommander_selected)>0
			let name=<SID>SelectedNum(b:vimcommander_selected, i)
			let filename=<SID>MyPath().name
			let i=i+1
		else
			let name=""
		end
	endwhile
	let b:vimcommander_selected=""
	cal <SID>RefreshDisplays()
endf

fu! <SID>FileEdit()
	let path=<SID>PathUnderCursor()
	if(isdirectory(path))
		return
	end
	"cal <SID>ProvideBuffer()
	let s:buffer_to_load=path
	"cal <SID>Close()
	exe "tabedit ".<SID>VimEscape(path)
endf

fu! <SID>NewFileEdit()
	let path=<SID>MyPath()
	let newfile=<SID>PathUnderCursor()
	if(isdirectory(newfile))
		let newfile=path
	end
	let newfile=input("File to edit: ", newfile)
	if newfile==""
		return
	end
	if(isdirectory(newfile))
		echo "Unable to edit file: directory with same name exists"
		return
	end
	"cal <SID>ProvideBuffer()
	let s:buffer_to_load=newfile
	cal <SID>Close()
	exe "edit ".<SID>VimEscape(newfile)
endf

fu! <SID>MyPath()
	if exists("s:bufnr_left")
		if winbufnr(0) == s:bufnr_left
			return s:path_left."/"
		else
			return s:path_right."/"
		en
	else
		if winbufnr(0) == s:bufnr_right
			return s:path_left."/"
		else
			return s:path_right."/"
		en
	end
endf

fu! <SID>BuildTreeNoPrev(path)
	let path=expand(a:path)
	let oldpath=<SID>MyPath()
	let b:vimcommander_selected=""
	" clean up
	setl ma
	norm! ggVG"_xo
	" check if no unneeded trailing / is there
  let l:path_len = strlen(path)
	if l:path_len > 1 && path[l:path_len - 1] == s:slash_char
		let path = strpart(path, 0, l:path_len - 1)
	en
	if(winbufnr(0)==s:bufnr_right)
		let s:path_right=path
	else
		let s:path_left=path
	end
	if g:vimcommander_shallcd==1
		exe "cd ".<SID>MyPath()
	end
	cal setline(1,path)
	setl noma nomod
	" pass -1 as xpos to start at column 0
	cal <SID>TreeExpand(-1,1,path)
	" move to first entry
	norm! ggj4|
endf

fu! <SID>BuildTree(path)
	let oldpath=<SID>MyPath()
	cal <SID>BuildTreeNoPrev(a:path)
	if oldpath!=<SID>GetNextLine(b:vimcommander_prev)
		let b:vimcommander_prev=oldpath."\n".b:vimcommander_prev
	end
	let b:vimcommander_next=""
endf

fu! <SID>RefreshDisplays()
	let line=line('.')
	cal <SID>BuildTree(<SID>MyPath())
	exec line
	norm 4|
	cal <SID>SwitchBuffer()
	let line=line('.')
	cal <SID>BuildTree(<SID>MyPath())
	exec line
	norm 4|
	cal <SID>SwitchBuffer()
endf

fu! <SID>DirCreate()
	let newdir=""
	let newdir=input("New directory name: ","")
	if filereadable(newdir)
		echo "File with that name exists."
		return
	end
	if isdirectory(newdir)
		echo "Directory already exists."
		return
	end
	let i=system("mkdir ".shellescape(<SID>MyPath().newdir))
	cal <SID>RefreshDisplays()
	norm! gg1j
	cal search("^  +".newdir."$")
	norm! 4|
endf

fu! <SID>OtherPath()
	if winbufnr(0) == s:bufnr_left
		return s:path_right."/"
	else
		return s:path_left."/"
	en
endf

fu! <SID>GetLine()
	let line=getline(line('.'))
	retu strpart(line, 1)
endf

fu! <SID>FilenameUnderCursor()
	let path=<SID>GetLine()
	let path=strpart(path, 2)
	return path
endf

fu! <SID>GetPathName(xpos,ypos)
	let xpos=a:xpos
	let ypos=a:ypos
	" check for directory..
	let line=getline(ypos)
	" check selected
	let path=<SID>FilenameUnderCursor()
	let path='/'.path
	" add base path
	" not needed, if in root
	if getline(1)!='/'
		let path=getline(1).path
	en
	let l:path = substitute(l:path,'\\','/','g')
	retu path
endf

fu! <SID>PathUnderCursor()
	let xpos=2
	let ypos=line('.')
	if ypos>1 "not on line 1
		return <SID>GetPathName(xpos,ypos)
	end
	return ""
endf

fu! <SID>VimEscape(name)
	return escape(a:name, " '()\\\"|#%*?+")
endf

fu! <SID>FileCopy(samedir)
	let i=0
	if strlen(b:vimcommander_selected)>0
		let name=<SID>SelectedNum(b:vimcommander_selected, i)
		let filename=<SID>MyPath().name
		if a:samedir == 0
			let otherfilename=<SID>OtherPath().name
		else
			let otherfilename=<SID>MyPath().name
		end
		let i=i+1
	else
		let name=" "
		let filename=<SID>PathUnderCursor()
		if a:samedir == 0
			let otherfilename=<SID>OtherPath().<SID>FilenameUnderCursor()
		else
			let otherfilename=<SID>MyPath().<SID>FilenameUnderCursor()
		end
	end
	let opt="y"
	while strlen(name)>0
		if filereadable(filename) || isdirectory(filename)
			if strlen(b:vimcommander_selected)==0
				let newfilename=input("Copy ".filename." to: ",otherfilename)
			else
				let newfilename=otherfilename
			end
			if filereadable(filename) && isdirectory(newfilename)
				cal <SID>RefreshDisplays()
				echo "Can't overwrite directory ".newfilename." with file"
				return
			end
			if isdirectory(filename) && filereadable(newfilename)
				cal <SID>RefreshDisplays()
				echo "Can't overwrite file ".newfilename." with directory"
				return
			end
			let do_copy=1
			if filereadable(newfilename)
				if opt!~"^[AakK]$"
					let opt=input("File ".newfilename." exists, overwrite? [nkya] ","y")
					if opt==""
						cal <SID>RefreshDisplays()
						return
					end
				end
				let do_copy = opt=~"^[yYAa]$"
			end

			if (do_copy)
				" copy file
              if <SID>ShallUseUnixCmds()
				cal system("cp -Rf ".shellescape(filename)." ".shellescape(newfilename))
			  else
                cal system("copy ".<SID>MsDos(filename)." ".<SID>MsDos(newfilename))
              end
			en
		en
		if strlen(b:vimcommander_selected)>0
			let name=<SID>SelectedNum(b:vimcommander_selected, i)
			let filename=<SID>MyPath().name
			let otherfilename=<SID>OtherPath().name
			let i=i+1
		else
			let name=""
		end
	endwhile
	let b:vimcommander_selected=""
	cal <SID>RefreshDisplays()
endf

fu! <SID>FileMove(rename)
	let i=0
	if strlen(b:vimcommander_selected)>0
		let name=<SID>SelectedNum(b:vimcommander_selected, i)
		let filename=<SID>MyPath().name
		if a:rename == 1
			let otherfilename=<SID>MyPath().name
		else
			let otherfilename=<SID>OtherPath().name
		end
		let i=i+1
	else
		let name=" "
		let filename=<SID>PathUnderCursor()
		if a:rename == 1
			let otherfilename=<SID>MyPath().<SID>FilenameUnderCursor()
		else
			let otherfilename=<SID>OtherPath().<SID>FilenameUnderCursor()
		end
	end
	let opt='y'
	while strlen(name)>0
		if filereadable(filename) || isdirectory(filename)
			if strlen(b:vimcommander_selected)==0
				let newfilename=input("Move ".filename." to: ",otherfilename)
			else
				let newfilename=otherfilename
			end
			if filereadable(filename) && isdirectory(newfilename)
				cal <SID>RefreshDisplays()
				echo "Can't overwrite directory with file"
				return
			end
			if isdirectory(filename) && filereadable(newfilename)
				cal <SID>RefreshDisplays()
				echo "Can't overwrite file with directory"
				return
			end
			if isdirectory(filename) && isdirectory(newfilename)
				cal <SID>RefreshDisplays()
				echo "Can't overwrite directory with directory"
				return
			end
			let do_move=1
			if filereadable(newfilename)
				if opt!~"^[AakK]$"
					let opt=input("File ".newfilename." exists, overwrite? [nkya] ","y")
					if opt==""
						cal <SID>RefreshDisplays()
						return
					end
				end

				do_move = opt=~"^[yYAa]$"
			en

			if (do_move)
				" move file
              if <SID>ShallUseUnixCmds()
				cal system('mv '.shellescape(filename).' '.shellescape(newfilename))
			  else
                cal system('move '.<SID>MsDos(filename).' '.<SID>MsDos(newfilename))
              end
			en
		en
		if strlen(b:vimcommander_selected)>0
			let name=<SID>SelectedNum(b:vimcommander_selected, i)
			let filename=<SID>MyPath().name
			let otherfilename=<SID>OtherPath().name
			let i=i+1
		else
			let name=""
		end
	endwhile
	let b:vimcommander_selected=""
	cal <SID>RefreshDisplays()
endf

fu! <SID>FileDelete()
	let i=0
	if strlen(b:vimcommander_selected)>0
		let name=<SID>SelectedNum(b:vimcommander_selected, i)
		let filename=<SID>MyPath().name
		let i=i+1
	else
		let name=" "
		let filename=<SID>PathUnderCursor()
	end
	let opt=""
	while strlen(name)>0
		if filereadable(filename) || isdirectory(filename)
			if opt!~"^[AakK]$"
				let opt=input("OK to delete ".fnamemodify(filename,":t")."? [nkya] ","y")
				if opt==""
					cal <SID>RefreshDisplays()
					return
				end
			end
			if opt=~"^[yYAa]$"
              if <SID>ShallUseUnixCmds()
				cal system("rm -rf ".shellescape(filename))
		      else
                  if isdirectory(filename)
                    cal system("rmdir /s /q ".<SID>MsDos(filename))
                  else
                    cal system("del /q ".<SID>MsDos(filename))
                  end
              end
			en
		en
		if strlen(b:vimcommander_selected)>0
			let name=<SID>SelectedNum(b:vimcommander_selected, i)
			let filename=<SID>MyPath().name
			let i=i+1
		else
			let name=""
		end
	endwhile
	let b:vimcommander_selected=""
	cal <SID>RefreshDisplays()
endf

fu! <SID>PutDir()
	if winbufnr(0)==s:bufnr_left
		let mypath=s:path_left
	else
		let mypath=s:path_right
	end
	cal <SID>SwitchBuffer()
	cal <SID>BuildTree(mypath)
	cal <SID>SwitchBuffer()
	cal <SID>RefreshDisplays()
endf

fu! <SID>GetOrPutDir(dir)
	if a:dir=='l' && winbufnr(0)==s:bufnr_left " left and left - getdir
		cal <SID>BuildTree(<SID>OtherPath())
		return
	end
	if a:dir=='r' && winbufnr(0)==s:bufnr_right " right and right - getdir
		cal <SID>BuildTree(<SID>OtherPath())
		return
	end
	" Crossed - putdir
	let path=<SID>PathUnderCursor()
	if !isdirectory(path)
		return
	end
	cal <SID>SwitchBuffer()
	cal <SID>BuildTree(path)
	cal <SID>SwitchBuffer()
	cal <SID>RefreshDisplays()
endf

fu! <SID>ExchangeDirs()
	let pathtmp=s:path_left
	let s:path_left=s:path_right
	let s:path_right=pathtmp
	let myline=line('.')
	cal <SID>BuildTree(<SID>MyPath())
	cal <SID>SwitchBuffer()
	cal <SID>BuildTree(<SID>MyPath())
	exec myline
	cal <SID>RefreshDisplays()
endf

fu! <SID>GetNextLine(text)
	let pos=match(a:text,"\n")
	retu strpart(a:text,0,pos)
endf

fu! <SID>CutFirstLine(text)
	let pos=match(a:text,"\n")
	if pos==-1
		return ""
	end
	retu strpart(a:text,pos+1,strlen(a:text))
endf

fu! <SID>SelectedNum(str,idx)
	let mystr=a:str
	let i=0
	wh i<a:idx
		let mystr=<SID>CutFirstLine(mystr)
		let i=i+1
	endwh
	let pos=stridx(mystr, "\n")
	if pos!=-1
		let mystr=strpart(mystr, 0, pos)
	end
	return mystr
endf

fu! <SID>IsSelected(line)
	let rv=(a:line=~"^>.*")
	retu rv
endf

fu! <SID>Select()
	let name=<SID>GetLine()
	if  <SID>IsSelected(name)
		let name=<SID>FilenameUnderCursor()
		let tmp=""
		let found=<SID>SelectedNum(b:vimcommander_selected, 0)
		let i=1
		while found!=""
			if found!=name
				let tmp=tmp.found."\n"
			end
			let found=<SID>SelectedNum(b:vimcommander_selected, i)
			let i=i+1
		endwhile
		let b:vimcommander_selected=tmp
		setl ma
		norm! |l
		norm! s
		setl noma
		cal <SID>GotoNextEntry()
	else " select
		let b:vimcommander_selected=b:vimcommander_selected.<SID>FilenameUnderCursor()."\n"
		setl ma
		norm! |
		norm! l
		norm! s>
		setl noma
		cal <SID>GotoNextEntry()
	end
endf

fu! <SID>SelectPattern(pattern)
	let origdirlist=''
	let path=<SID>MyPath()
	if s:show_hidden_files
		let dirlistorig=glob(path.'/.*'.a:pattern)."\n"
	en
	let origdirlist=origdirlist.globpath(path, a:pattern)."\n"
	let myline=line('.')
	norm! G
	let lastline=line('.')
	norm! gg
	norm! j
	while line('.')<lastline
		let dirlist=strpart(origdirlist,0)
		let line=<SID>GetLine()
		if(! (<SID>IsSelected(line)))
			wh strlen(dirlist)>0
				" get next line
				let entry=<SID>GetNextLine(dirlist)
				let dirlist=<SID>CutFirstLine(dirlist)
				" only files
				if entry!="." && entry!=".." && entry!=""
					if entry==<SID>PathUnderCursor()
						cal <SID>Select()
						norm! k
						let dirlist=""
						continue
					end
				en
			endw
		end
		norm! j
	endwhile
	cal <SID>GotoEntry(myline)
endf

fu! <SID>DeSelectPattern(pattern)
	let origdirlist=''
	let path=<SID>MyPath()
	if s:show_hidden_files
		let dirlistorig=glob(path.'/.*'.a:pattern)."\n"
	en
	let origdirlist=origdirlist.globpath(path, a:pattern)."\n"
	let myline=line('.')
	norm! G
	let lastline=line('.')
	norm! gg
	norm! j
	while line('.')<lastline
		let dirlist=strpart(origdirlist,0)
		let path=<SID>GetLine()
		if <SID>IsSelected(path)
			let path=<SID>MyPath().<SID>FilenameUnderCursor()
			wh strlen(dirlist)>0
				" get next line
				let entry=<SID>GetNextLine(dirlist)
				let dirlist=<SID>CutFirstLine(dirlist)
				" only files
				if entry!="." && entry!=".." && entry!=""
					"echo "cursor in ".path." entry ".entry." len ".strlen(dirlist)
					if entry==path
						cal <SID>Select()
						norm! k
						let dirlist=""
						continue
					end
				end
			endw
		end
		norm! j
	endwhile
	cal <SID>GotoEntry(myline)
endf

fu! <SID>SelectPatternAsk()
	let pattern=input("Select with pattern: ")
	cal <SID>SelectPattern(pattern)
	echo ""
endf

fu! <SID>DeSelectPatternAsk()
	let pattern=input("Deselect with pattern: ")
	cal <SID>DeSelectPattern(pattern)
	echo ""
endf

fu! <SID>GotoNextEntry()
	let xpos=col('.')
	" different movement in line 1
	if line('.')==1
		" if over slash, move one to right
		if getline('.')[xpos-1]=='/'
			norm! l
			" only root path there, move down
			if col('.')==1
				norm! j4
			en
		el
			" otherwise after next slash
			norm! f/l
			" if already last path, move down
			if col('.')==xpos
				norm! j4
			en
		en
	el
		norm! j4|
	en
endf

fu! <SID>GotoPrevEntry()
	" different movement in line 1
	if line('.')==1
		" move after prev slash
		norm! hF/l
	el
		" enter line 1 at the end
		if line('.')==2
			norm! k$F/l
		el
			norm! k4|
		en
	en
endf

fu! <SID>PrevDir()
	let newpath=<SID>GetNextLine(b:vimcommander_prev)
	let oldpath=<SID>MyPath()
	let b:vimcommander_prev=<SID>CutFirstLine(b:vimcommander_prev)
	if strlen(newpath)>0
		cal <SID>BuildTreeNoPrev(newpath)
		if oldpath!=<SID>GetNextLine(b:vimcommander_next)
			let b:vimcommander_next=oldpath."\n".b:vimcommander_next
		end
	end
endf

fu! <SID>NextDir()
	let newpath=<SID>GetNextLine(b:vimcommander_next)
	let oldpath=<SID>MyPath()
	let b:vimcommander_next=<SID>CutFirstLine(b:vimcommander_next)
	if strlen(newpath)>0
		cal <SID>BuildTreeNoPrev(newpath)
		if oldpath!=<SID>GetNextLine(b:vimcommander_prev)
			let b:vimcommander_prev=oldpath."\n".b:vimcommander_prev
		end
	end
endf

fu! <SID>ShowHiddenFilesToggle()
	if (s:show_hidden_files==0)
		let s:show_hidden_files=1
	el
		let s:show_hidden_files=0
	en
	cal <SID>RefreshDisplays()
endf

"== From Opsplorer: ==========================================================

fu! <SID>InitOptions()
	let s:single_click_to_edit=0
	let s:file_match_pattern="*"
	"let s:file_match_pattern="\"`ls -d * | egrep -v \"(\.d$|\.o$|^tags$)\";ls config.mk`\""
	let s:show_hidden_files=0
	let s:split_vertical=1
	let s:split_width=20
	let s:split_minwidth=1
	let s:use_colors=1
	let s:close_explorer_after_open=0
endf

fu! <SID>FileSee()
	norm! 4|
	let filename=<SID>GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		let i=system("see ".shellescape(filename)."&")
	en
endf

fu! <SID>BuildParentTree()
	if <SID>ShallUseUnixCmds()
		norm! gg$F/
	else
		norm! gg$F\
	end
	let mydir=getline(line('.'))
	let mypos="^..+".strpart(mydir, strridx(mydir,s:slash_char)+1)."$"
	cal <SID>OnDoubleClick()
	call search(mypos)
	norm! 4|
endf

fu! <SID>GotoNextNode()
	" in line 1 like next entry
	if line('.')==1
		cal <SID>GotoNextEntry()
	el
		norm! j4|
		wh getline('.')[col('.')-1] !~ "[+-]" && line('.')<line('$')
			norm! j4|
		endw
	en
endf

fu! <SID>GotoPrevNode()
	" entering base path section?
	if line('.')<3
		cal <SID>GotoPrevEntry()
	el
		norm! k4|
		wh getline('.')[col('.')-1] !~ "[+-]" && line('.')>1
			norm! k4|
		endw
	en
endf

fu! <SID>OnClick()
	let xpos=col('.')-1
	let ypos=line('.')
	if s:single_click_to_edit
		cal <SID>OnDoubleClick()
	en
endf

fu! <SID>OnDoubleClick()
	let xpos=col('.')-1
	let ypos=line('.')
	" go to first non-blank when line>1
	if ypos>1
		let xpos=2
		" check, if it's a directory
		let path=<SID>GetPathName(xpos,ypos)
		if isdirectory(path)
			" build new root structure
			cal <SID>BuildTree(path)
		el
			" try to resolve filename
			" and open in other window
			if filereadable(path)
				cal <SID>FileEdit()
			en
		en
	el
		" we're on line 1 here! getting new base path now...
		" advance to next slash
		if getline(1)[xpos]!=s:slash_char
      if <SID>ShallUseUnixCmds()
			  norm! f/
      else
        norm! f\
      endif
		  " no next slash -> current directory, just rebuild
			if col('.')-1==xpos
				cal <SID>BuildTree(getline(1))
				retu
			en
		en
		" cut ending slash
		norm! h
		" rebuild tree with new path
		cal <SID>BuildTree(strpart(getline(1),0,col('.')))
	en
endf

fu! <SID>ChangeDir()
	let l:oldpath = <SID>MyPath()
	let l:path = input("Change directory: ", "", "file")
  if l:path == ""
    let l:path = l:oldpath
  endif
  if !<SID>ShallUseUnixCmds()
	  let l:path = substitute(l:path,'\\','/','g')
  endif
	cal <SID>BuildTree(l:path)
endf

fu! <SID>TreeExpand(xpos,ypos,path)
	let path=a:path
	setl ma
	" first get all subdirectories
	let dirlist=""
	" extra globbing for hidden files
	if s:show_hidden_files
		let dirlist=glob(path.'/.*')."\n"
	en
	" add norm! entries
	let dirlist=dirlist.glob(path.'/*')."\n"
	" remember where to append
	let row=a:ypos
	wh strlen(dirlist)>0
		" get next line
		let entry=<SID>GetNextLine(dirlist)
		let dirlist=<SID>CutFirstLine(dirlist)
		" add to tree if directory
		if isdirectory(entry)
			let entry=substitute(entry,".*".s:slash_char,'','')
			if entry!="." && entry!=".."
				" indent, mark as node and append
				let entry="  "."+".entry
				cal append(row,entry)
				let row=row+1
			en
		en
	endw
	" now get files
	let dirlist=""
	" extra globbing for hidden files
	if s:show_hidden_files
		let dirlist=glob(path.'/.'.s:file_match_pattern)."\n"
	en
	let dirlist=dirlist.globpath(path, s:file_match_pattern)."\n"
	wh strlen(dirlist)>0
		" get next line
		let entry=<SID>GetNextLine(dirlist)
		let dirlist=<SID>CutFirstLine(dirlist)
		" only files
		if entry!="." && entry!=".." && entry!=""
			if !isdirectory(entry)&&filereadable(entry)
				let entry=substitute(entry,".*".s:slash_char,'','')
				" indent and append
				let entry="   ".entry
				cal append(row,entry)
				let row=row+1
			en
		en
	endw
	setl noma nomod
endf

fu! <SID>ToggleShowHidden()
	let s:show_hidden_files = 1-s:show_hidden_files
	cal <SID>BuildTree(getline(1))
endf

fu! <SID>SetMatchPattern()
	let s:file_match_pattern=input("Match pattern: ",s:file_match_pattern)
	cal <SID>BuildTree(getline(1))
endf

" vim: ft=vim fdm=marker foldmarker=fu!,endf

