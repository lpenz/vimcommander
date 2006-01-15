" vimcommander - (hopefully) vim + totalcommander-like file explorer for vim
" vim: fdm=marker foldmarker=fu!,endf
"
" Author:  Leandro Penz
" Date:    2003/11/01
" Email:   lpenz AT terra DOT com DOT br
" Version: $Id: vimcommander.vim,v 1.35 2003/11/09 17:14:14 lpenz Exp $
"
" Shameless using opsplorer.vim by Patrick Schiel.
"


fu! <SID>CommanderMappings()
	"opsplorer legacy:
	noremap <silent> <buffer> <LeftRelease> :cal <SID>OnClick()<CR>
	noremap <silent> <buffer> <2-LeftMouse> :cal <SID>OnDoubleClick(-1)<CR>
	noremap <silent> <buffer> <Space> :cal <SID>OnDoubleClick(0)<CR>
	noremap <silent> <buffer> <CR> :cal <SID>OnDoubleClick(1)<CR>
	noremap <silent> <buffer> <Down> :cal <SID>GotoNextEntry()<CR>
	noremap <silent> <buffer> <Up> :cal <SID>GotoPrevEntry()<CR>
	noremap <silent> <buffer> <S-Down> :cal <SID>GotoNextNode()<CR>
	noremap <silent> <buffer> <S-Up> :cal <SID>GotoPrevNode()<CR>
	noremap <silent> <buffer> <BS> :cal <SID>BuildParentTree()<CR>

	"total-cmd keys:
    noremap <silent> <buffer> <TAB>      :cal <SID>SwitchBuffer()<CR>
    noremap <silent> <buffer> <F3>       :cal <SID>FileView()<CR>
    noremap <silent> <buffer> <F4>       :cal <SID>FileEdit()<CR>
    noremap <silent> <buffer> <S-F4>     :cal <SID>NewFileEdit()<CR>
    noremap <silent> <buffer> <F7>       :cal <SID>DirCreate()<CR>
    noremap <silent> <buffer> <C-Left>   :cal <SID>GetOrPutDir('l')<CR>
    noremap <silent> <buffer> <C-Right>  :cal <SID>GetOrPutDir('r')<CR>
    noremap <silent> <buffer> <S-Left>   :cal <SID>GetOrPutDir('l')<CR>
    noremap <silent> <buffer> <S-Right>  :cal <SID>GetOrPutDir('r')<CR>
    noremap <silent> <buffer> <M-O>      :cal <SID>PutDir()<CR>
    noremap <silent> <buffer> <F5>       :cal <SID>FileCopy()<CR>
    noremap <silent> <buffer> <F6>       :cal <SID>FileMove()<CR>
    noremap <silent> <buffer> <F8>       :cal <SID>FileDelete()<CR>
    noremap <silent> <buffer> <DEL>      :cal <SID>FileDelete()<CR>
    noremap <silent> <buffer> <C-U>      :cal <SID>ExchangeDirs()<CR>
    noremap <silent> <buffer> <C-R>      :cal <SID>RefreshDisplays()<CR>
    noremap <silent> <buffer> <F10>      :cal VimCommanderToggle()<CR>
    noremap <silent> <buffer> <F11>      :cal VimCommanderToggle()<CR>
	noremap <silent> <buffer> <Insert>   :cal <SID>Select()<CR>
	noremap <silent> <buffer> <C-kPlus>  :cal <SID>SelectPattern('*')<CR>
	noremap <silent> <buffer> <C-kMinus> :cal <SID>DeSelectPattern('*')<CR>
	noremap <silent> <buffer> <kPlus>  :cal <SID>SelectPatternAsk()<CR>
	noremap <silent> <buffer> <kMinus> :cal <SID>DeSelectPatternAsk()<CR>

    noremap <silent> <buffer> <C-F11>   :cal <SID>SetMatchPattern()<CR>
    noremap <silent> <buffer> <C-O>     :cal VimCommanderToggle()<CR>

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
	cal <SID>InitOptions()
	let s:path_left=getcwd()
	let s:path_right=getcwd()
	let s:line_right=2
	let s:line_left=2
	let g:lastside="VimCommanderLeft"
	cal <SID>VimCommanderShow()
endf

fu! <SID>VimCommanderShow()
	if exists("g:vimcommander_loaded") && g:vimcommander_loaded==1 " on screen
		return
	end
	"close all windows
	let s:orig_buffer=bufname("")
	let v:errmsg=''
	while v:errmsg==''
		silent! close
	endwhile
	"reset aucmd
	autocmd! BufEnter VimCommanderLeft
	autocmd! BufEnter VimCommanderRight
	autocmd! BufWinLeave VimCommanderLeft
	autocmd! BufWinLeave VimCommanderRight
	" create new window
	let winsize=&lines
	exe winsize." split VimCommanderRight"
	let s:bufnr_right=winbufnr(0)
	" setup mappings, apply options, colors and draw tree
	cal <SID>InitCommanderOptions()
	cal <SID>CommanderMappings()
	cal <SID>InitCommanderColors()
	cal <SID>BuildTree(s:path_right)
	exe s:line_right
	exe "vs VimCommanderLeft"
	let s:bufnr_left=winbufnr(0)
	cal <SID>InitCommanderOptions()
	cal <SID>CommanderMappings()
	cal <SID>InitCommanderColors()
	cal <SID>BuildTree(s:path_left)
	exe s:line_left
	let g:vimcommander_loaded=1
	"Goto vimcommander window
	winc j
	hide
	let winnum = bufwinnr(g:lastside)
	if winnum != -1
		" Jump to the existing window
		if winnr() != winnum
			exe winnum . 'wincmd w'
		endif
	endif
	norm z-
	autocmd BufEnter    VimCommanderLeft  let g:lastside="VimCommanderLeft"
	autocmd BufEnter    VimCommanderRight let g:lastside="VimCommanderRight"
	autocmd BufWinLeave VimCommanderLeft  cal VimCommanderToggle()
	autocmd BufWinLeave VimCommanderRight cal VimCommanderToggle()
endf

fu! <SID>Close()
	autocmd! BufEnter VimCommanderLeft
	autocmd! BufEnter VimCommanderRight
	autocmd! BufWinLeave VimCommanderLeft 
	autocmd! BufWinLeave VimCommanderRight
	let winnum = bufwinnr("VimCommanderLeft")
	if winnum != -1
		" Jump to the existing window
		if winnr() != winnum
			exe winnum . 'wincmd w'
		endif
	endif
	let s:line_left=line('.')
	silent! close
	let winnum = bufwinnr("VimCommanderRight")
	if winnum != -1
		" Jump to the existing window
		if winnr() != winnum
			exe winnum . 'wincmd w'
		endif
	endif
	let s:line_right=line('.')
	silent! close
	let g:vimcommander_loaded=0
	if bufwinnr("VimCommanderRight")!=-1
		exe "new +buffer ".s:orig_buffer
		exe 'wincmd w'
		close
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
endf

fu! <SID>InitCommanderColors()
	sy clear
	if s:use_colors
		syntax match VimCommanderSelectedFile '^\s*<.*>$'
		syntax match VimCommanderSelectedDir '<\w.*>$' contained
		syntax match VimCommanderPath "^/.*"
		syntax match VimCommanderDirLine "^[+-].*" transparent contains=VimCommanderSelectedDir,VimCommanderNode
		syntax match VimCommanderNode "^[+-]" contained
		syntax match VimCommanderFileLine "^\s*\w\w*.*$" transparent contains=ALL
		syntax match VimCommanderFile "\w.*" contained
		syntax match VimCommanderSource "^\s*\w\w*.*\.c$" contained
		syntax match VimCommanderHeader "^\s*\w\w*.*\.h$" contained
		syntax match VimCommanderSpecial "^\s*\(Makefile\|config.mk\)$" contained
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

fu! <SID>GetPathName(xpos,ypos)
	let xpos=a:xpos
	let ypos=a:ypos
	" check for directory..
	let line=getline(ypos)
	" check selected
	if line=~"\s*<.*>$"
		let xpos=xpos+1
	end
	if getline(ypos)[xpos]=~"[+-]"
		let path=strpart(getline(ypos),xpos+1,col('$'))
	el
		" otherwise filename
		let path=strpart(getline(ypos),xpos,col('$'))
		let xpos=xpos-1
	en
	if line=~"\s*<.*>$"
		let path=strpart(path, 0, strlen(path)-1)
	end
	let path='/'.path
	" walk up tree and append subpaths
	" add base path
	" not needed, if in root
	if getline(1)!='/'
		let path=getline(1).path
	en
	retu path
endf

fu! <SID>PathUnderCursor()
	let xpos=col('.')-1
	let ypos=line('.')
	if ypos>1 "not on line 1
		norm 1|g^
		let xpos=col('.')-1
		let rv=<SID>GetPathName(xpos,ypos)
		return rv
	end
	return ""
endf

fu! <SID>ProvideBuffer()
	"winc j
	new
endf

fu! <SID>FileView()
	let path=<SID>PathUnderCursor()
	if(isdirectory(path))
		return
	end
	cal <SID>ProvideBuffer()
	exe "edit ".path
	setl noma
	setl ro
	cal <SID>Close()
endf

fu! <SID>FileEdit()
	let path=<SID>PathUnderCursor()
	if(isdirectory(path))
		return
	end
	cal <SID>ProvideBuffer()
	exe "edit ".path
	setl ma
	setl noro
	cal <SID>Close()
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
	cal <SID>ProvideBuffer()
	exe "edit ".newfile
	setlocal ma
	setlocal noro
	cal <SID>Close()
endf

fu! <SID>MyPath()
	if winbufnr(0) == s:bufnr_left
		return s:path_left."/"
	else
		return s:path_right."/"
	en
endf

fu! <SID>BuildTree(path)
	let path=a:path
	let b:vimcommander_selected=""
	" clean up
	setl ma
	norm ggVGxo
	" check if no unneeded trailing / is there
	if strlen(path)>1&&path[strlen(path)-1]=="/"
		let path=strpart(path,0,strlen(path)-1)
	en
	if(winbufnr(0)==s:bufnr_right)
		let s:path_right=path
	else
		let s:path_left=path
	end
	cal setline(1,path)
	setl noma nomod
	" pass -1 as xpos to start at column 0
	cal <SID>TreeExpand(-1,1,path)
	" move to first entry
	norm ggj1|g^
endf

fu! <SID>RefreshDisplays()
	let line=line('.')
	cal <SID>BuildTree(<SID>MyPath())
	exec line
	cal <SID>SwitchBuffer()
	let line=line('.')
	cal <SID>BuildTree(<SID>MyPath())
	exec line
	cal <SID>SwitchBuffer()
endf

fu! <SID>DirCreate()
	norm 1|g^
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
	let i=system("mkdir ".<SID>MyPath().newdir)
	cal <SID>RefreshDisplays()
	norm gg1j
	cal search("^+".newdir."$")
endf

fu! <SID>OtherPath()
	if winbufnr(0) == s:bufnr_left
		return s:path_right."/"
	else
		return s:path_left."/"
	en
endf

fu! <SID>GetName(xpos,ypos)
	let xpos=a:xpos
	let ypos=a:ypos
	" check for directory..
	if getline(ypos)[xpos]=~"[+-]"
		let path=strpart(getline(ypos),xpos+1,col('$'))
	el
		" otherwise filename
		let path=strpart(getline(ypos),xpos,col('$'))
		let xpos=xpos-1
	en
	retu path
endf

fu! <SID>FilenameUnderCursor()
	norm 1|g^
	let path=<SID>GetName(col('.')-1,line('.'))
	if path=~"^<.*>$"
		let path=strpart(path, 1, strlen(path)-2)
	end
	return path
endf

fu! <SID>NameUnderCursor()
	norm 1|g^
	return <SID>GetName(col('.')-1,line('.'))
endf

fu! <SID>FileCopy()
	let i=0
	if strlen(b:vimcommander_selected)>0
		let name=<SID>SelectedNum(b:vimcommander_selected, i)
		let filename=<SID>MyPath().name
		let otherfilename=<SID>OtherPath().name
		let i=i+1
	else
		let name=" "
		let filename=<SID>PathUnderCursor()
		let otherfilename=<SID>OtherPath().<SID>FilenameUnderCursor()
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
				echo "Can't overwrite directory ".newfilename." with file"
				return
			end
			if isdirectory(filename) && filereadable(newfilename)
				echo "Can't overwrite file ".newfilename." with directory"
				return
			end
			if filereadable(newfilename)
				if opt!~"^[AakK]$"
					let opt=input("File ".newfilename." exists, overwrite? [nkya] ","y")
					if opt==""
						return
					end
				end
				if opt=~"^[yYAa]$"
					" copy file
					cal system('cp -Rf "'.filename.'" "'.newfilename.'"')
				en
			el
				" copy file
				cal system('cp -Rf "'.filename.'" "'.newfilename.'"')
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

fu! <SID>FileMove()
	let i=0
	if strlen(b:vimcommander_selected)>0
		let name=<SID>SelectedNum(b:vimcommander_selected, i)
		let filename=<SID>MyPath().name
		let otherfilename=<SID>OtherPath().name
		let i=i+1
	else
		let name=" "
		let filename=<SID>PathUnderCursor()
		let otherfilename=<SID>OtherPath().<SID>FilenameUnderCursor()
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
				echo "Can't overwrite directory with file"
				return
			end
			if isdirectory(filename) && filereadable(newfilename)
				echo "Can't overwrite file with directory"
				return
			end
			if isdirectory(filename) && isdirectory(newfilename)
				echo "Can't overwrite directory with directory"
				return
			end
			if filereadable(newfilename)
				if opt!~"^[AakK]$"
					let opt=input("File ".newfilename." exists, overwrite? [nkya] ","y")
					if opt==""
						return
					end
				end
				if opt=~"^[yYAa]$"
					" move file
					system('mv -f "'.filename.'" "'.newfilename.'"')
				en
			el
				" move file
				system('mv "'.filename.'" "'.newfilename.'"')
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
					return
				end
			end
			if opt=~"^[yYAa]$"
				cal system('rm -rf "'.filename.'"')
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
	let mypath=<SID>MyPath()
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

fu! <SID>SelectedNum(str,idx)
	let mystr=a:str
	let i=0
	wh i<a:idx
		let mystr=strpart(mystr,1)
		let pos=stridx(mystr, "<")
		if pos==-1
			return ""
		end
		let mystr=strpart(mystr, pos)
		let i=i+1
	endwh
	let pos=stridx(mystr, ">")
	let mystr=strpart(mystr, 1, pos-1)
	return mystr
endf

fu! <SID>Select()
	let name=<SID>NameUnderCursor()
	if  name =~ "^+*<\w*.*>$" " deselected
		let name=strpart(name, 1, strlen(name)-2)
		let tmp=""
		let found=<SID>SelectedNum(b:vimcommander_selected, 0)
		let i=1
		while found!=""
			if found!=name
				if tmp!=""
					let tmp=tmp.' '
				end
				let tmp=tmp.'<'.found.'>'
			end
			let found=<SID>SelectedNum(b:vimcommander_selected, i)
			let i=i+1
		endwhile
		let b:vimcommander_selected=tmp
		setl ma
		norm 1|g^
		if getline(line('.'))[0]=='+'
			norm l
		end
		norm x
		norm $x
		norm 1|g^
		setl noma
		norm j
	else " select
		if b:vimcommander_selected==""
			let b:vimcommander_selected='<'.<SID>NameUnderCursor().'>'
		else
			let b:vimcommander_selected=b:vimcommander_selected." <".<SID>NameUnderCursor().">"
		end
		setl ma
		norm ^
		if getline(line('.'))[0]=='+'
			norm l
		end
		norm i<
		norm A>
		setl noma
		norm 1|g^
		norm j
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
	norm G
	let lastline=line('.')
	norm gg
	norm j
	while line('.')<lastline
		let dirlist=strpart(origdirlist,0)
		wh strlen(dirlist)>0
			" get next line
			let entry=<SID>GetNextLine(dirlist)
			let dirlist=<SID>CutFirstLine(dirlist)
			" only files
			if entry!="." && entry!=".." && entry!=""
				"echo "cursor in ".<SID>PathUnderCursor()." entry ".entry." len ".strlen(dirlist)
				if entry==<SID>PathUnderCursor()
					cal <SID>Select()
					norm k
					let dirlist=""
					continue
				end
			en
		endw
		norm j
	endwhile
	exe myline
endf

fu! <SID>DeSelectPattern(pattern)
	let origdirlist=''
	let path=<SID>MyPath()
	if s:show_hidden_files
		let dirlistorig=glob(path.'/.*'.a:pattern)."\n"
	en
	let origdirlist=origdirlist.globpath(path, a:pattern)."\n"
	let myline=line('.')
	norm G
	let lastline=line('.')
	norm gg
	norm j
	while line('.')<lastline
		let dirlist=strpart(origdirlist,0)
		let path=<SID>NameUnderCursor()
		if path=~"^<.*>$"
			let path=<SID>MyPath().strpart(path,1,strlen(path)-2)
			wh strlen(dirlist)>0
				" get next line
				let entry=<SID>GetNextLine(dirlist)
				let dirlist=<SID>CutFirstLine(dirlist)
				" only files
				if entry!="." && entry!=".." && entry!=""
					" echo "cursor in ".path." entry ".entry." len ".strlen(dirlist)
					if entry==path
						cal <SID>Select()
						norm k
						let dirlist=""
						continue
					end
				end
			endw
		end
		norm j
	endwhile
	exe myline
endf

fu! <SID>SelectPatternAsk()
	let pattern=input("Select with pattern: ",'*')
	cal <SID>SelectPattern(pattern)
	echo ""
endf

fu! <SID>DeSelectPatternAsk()
	let pattern=input("Deselect with pattern: ",'*')
	cal <SID>DeSelectPattern(pattern)
	echo ""
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

fu! <SID>InsertFilename()
	norm 1|g^
	let filename=<SID>GetPathName(col('.')-1,line('.'))
	winc p
	exe "norm a".filename
endf

fu! <SID>InsertFileContent()
	norm 1|g^
	let filename=<SID>GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		winc p
		exe "r ".filename
	en
endf

fu! <SID>FileSee()
	norm 1|g^
	let filename=<SID>GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		let i=system("see ".filename."&")
	en
endf

fu! <SID>BuildParentTree()
	norm gg$F/
	let mydir=getline(line('.'))
	let mypos="^+".strpart(mydir, strridx(mydir,'/')+1)."$"
	cal <SID>OnDoubleClick(0)
	call search(mypos)
endf

fu! <SID>GotoNextNode()
	" in line 1 like next entry
	if line('.')==1
		cal <SID>GotoNextEntry()
	el
		norm j1|g^
		wh getline('.')[col('.')-1] !~ "[+-]" && line('.')<line('$')
			norm j1|g^
		endw
	en
endf

fu! <SID>GotoPrevNode()
	" entering base path section?
	if line('.')<3
		cal <SID>GotoPrevEntry()
	el
		norm k1|g^
		wh getline('.')[col('.')-1] !~ "[+-]" && line('.')>1
			norm k1|g^
		endw
	en
endf

fu! <SID>GotoNextEntry()
	let xpos=col('.')
	" different movement in line 1
	if line('.')==1
		" if over slash, move one to right
		if getline('.')[xpos-1]=='/'
			norm l
			" only root path there, move down
			if col('.')==1
				norm j1|g^
			en
		el
			" otherwise after next slash
			norm f/l
			" if already last path, move down
			if col('.')==xpos
				norm j1|g^
			en
		en
	el
		" next line, first nonblank
		norm j1|g^
	en
endf

fu! <SID>GotoPrevEntry()
	" different movement in line 1
	if line('.')==1
		" move after prev slash
		norm hF/l
	el
		" enter line 1 at the end
		if line('.')==2
			norm k$F/l
		el
			" prev line, first nonblank
			norm k1|g^
		en
	en
endf

fu! <SID>OnClick()
	let xpos=col('.')-1
	let ypos=line('.')
	if <SID>IsTreeNode(xpos,ypos)
		cal <SID>TreeNodeAction(xpos,ypos)
	elsei s:single_click_to_edit
		cal <SID>OnDoubleClick()
	en
endf

fu! <SID>OnDoubleClick(close_explorer)
	let s:close_explorer=a:close_explorer
	if s:close_explorer==-1
		let s:close_explorer=s:close_explorer_after_open
	en
	let xpos=col('.')-1
	let ypos=line('.')
	" clicked on node
	"if <SID>IsTreeNode(xpos,ypos)
	"	cal <SID>TreeNodeAction(xpos,ypos)
	"el
	" go to first non-blank when line>1
	if ypos>1
		norm 1|g^
		let xpos=col('.')-1
		" check, if it's a directory
		let path=<SID>GetPathName(xpos,ypos)
		if isdirectory(path)
			" build new root structure
			cal <SID>BuildTree(path)
			"exe "cd ".getline(1)
		el
			" try to resolve filename
			" and open in other window
			let path=<SID>GetPathName(xpos,ypos)
			if filereadable(path)
				" go to last accessed buffer
				winc j
				" append sequence for opening file
				"exe "cd ".fnamemodify(path,":h")
				exe "e ".path
				if s:close_explorer==2 "eh view
					setl noma
					setl ro
				else
					setl ma
					setl noro
				end
			en
			if s:close_explorer==1
				cal VimCommanderToggle()
			en
		en
	el
		" we're on line 1 here! getting new base path now...
		" advance to next slash
		if getline(1)[xpos]!="/"
			norm f/
			" no next slash -> current directory, just rebuild
			if col('.')-1==xpos
				cal <SID>BuildTree(getline(1))
				"exe "cd ".getline(1)
				retu
			en
		en
		" cut ending slash
		norm h
		" rebuild tree with new path
		cal <SID>BuildTree(strpart(getline(1),0,col('.')))
	en
	"en
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
	" add norm entries
	let dirlist=dirlist.glob(path.'/*')."\n"
	" remember where to append
	let row=a:ypos
	wh strlen(dirlist)>0
		" get next line
		let entry=<SID>GetNextLine(dirlist)
		let dirlist=<SID>CutFirstLine(dirlist)
		" add to tree if directory
		if isdirectory(entry)
			let entry=substitute(entry,".*/",'','')
			if entry!="." && entry!=".."
				" indent, mark as node and append
				let entry=<SID>SpaceString(a:xpos+1)."+".entry
				cal append(row,entry)
				let row=row+1
			en
		en
	endw
	" now get files
	let dirlist=""
	" extra globbing for hidden files
	if s:show_hidden_files
		let dirlist=glob(path.'/.*'.s:file_match_pattern)."\n"
	en
	let dirlist=dirlist.globpath(path, s:file_match_pattern)."\n"
	wh strlen(dirlist)>0
		" get next line
		let entry=<SID>GetNextLine(dirlist)
		let dirlist=<SID>CutFirstLine(dirlist)
		" only files
		if entry!="." && entry!=".." && entry!=""
			if !isdirectory(entry)&&filereadable(entry)
				let entry=substitute(entry,".*/",'','')
				" indent and append
				let entry=<SID>SpaceString(a:xpos+2).entry
				cal append(row,entry)
				let row=row+1
			en
		en
	endw
	setl noma nomod
endf

fu! <SID>TreeCollapse(xpos,ypos)
	setl ma
	" turn - into +, go to next line
	norm r+j
	" delete lines til next line with same indent
	wh (getline('.')[a:xpos+1] =~ '[ +-]') && (line('$') != line('.'))
		norm dd
	endw
	" go up again
	norm k
	setl noma nomod
endf

fu! <SID>TreeNodeAction(xpos,ypos)
	if getline(a:ypos)[a:xpos] == '+'
		cal <SID>TreeExpand(a:xpos,a:ypos,<SID>GetPathName(a:xpos,a:ypos))
	elsei getline(a:ypos)[a:xpos] == '-'
		cal <SID>TreeCollapse(a:xpos,a:ypos)
	en
endf

fu! <SID>IsTreeNode(xpos,ypos)
	if getline(a:ypos)[a:xpos] =~ '[+-]'
		" is it a directory or file starting with +/- ?
		if isdirectory(<SID>GetPathName(a:xpos,a:ypos))
			retu 1
		el
			retu 0
		en
	el
		retu 0
	en
endf

fu! <SID>ToggleShowHidden()
	let s:show_hidden_files = 1-s:show_hidden_files
	cal <SID>BuildTree(getline(1))
endf

fu! <SID>SetMatchPattern()
	let s:file_match_pattern=input("Match pattern: ",s:file_match_pattern)
	cal <SID>BuildTree(getline(1))
endf

fu! <SID>GetNextLine(text)
	let pos=match(a:text,"\n")
	retu strpart(a:text,0,pos)
endf

fu! <SID>CutFirstLine(text)
	let pos=match(a:text,"\n")
	retu strpart(a:text,pos+1,strlen(a:text))
endf

fu! <SID>SpaceString(width)
	let spacer=""
	let width=a:width
	wh width>0
		let spacer=spacer." "
		let width=width-1
	endw
	retu spacer
endf


