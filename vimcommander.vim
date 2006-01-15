" vimcommander - totalcommander-like file explorer for vim
"
" Author:  Leandro Penz
" Date:    2003/11/01
" Email:   lpenz AT terra DOT com DOT br
" Version: $Id: vimcommander.vim,v 1.2 2003/11/01 16:17:26 lpenz Exp $
"
" Heavily based on opsplorer.vim by Patrick Schiel.
"

" setup command
com! -nargs=* -complete=dir VimCommander cal VimCommander(<f-args>)
noremap <silent> <F12> :cal ToggleShowVimCommander()<CR>

fu! ToggleShowVimCommander()
	if exists("g:vimcommander_loaded")
		exe s:window_bufnrleft."bd"
		exe s:window_bufnrright."bd"
		unl g:vimcommander_loaded
	el
		cal VimCommander()
	en
endf

fu! VimCommander(...)
	" create explorer window
	" take argument as path, if given
	if a:0>0
		let path=a:1
	el
		" otherwise current dir
		let path=getcwd()
	en
	" substitute leading ~
	" (doesn't work with isdirectory() otherwise!)
	let path=fnamemodify(path,":p")
	" expand, if relative path
	if path[0]!="/"
		let path=getcwd()."/".path
	en
	let path2=path
	" setup options
	cal InitOptions()
	" create new window
	new
	" setup mappings, apply options, colors and draw tree
	cal InitCommonOptions()
	cal InitMappings()
	cal InitColors()
	cal BuildTree(path)
	let s:window_bufnrleft=winbufnr(0)
	vne
	cal InitCommonOptions()
	cal InitMappings()
	cal InitColors()
	cal BuildTree(path2)
	let s:window_bufnrright=winbufnr(0)
	let g:vimcommander_loaded=1
endf

fu! OtherBuff(thisbuff)
	if a:thisbuff == s:window_bufnrleft
		return s:window_bufnrright
	else
		return s:window_bufnrleft
	en
endf

fu! InitOptions()
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

fu! InitMappings()
	noremap <silent> <buffer> <LeftRelease> :cal OnClick()<CR>
	noremap <silent> <buffer> <2-LeftMouse> :cal OnDoubleClick(-1)<CR>
	noremap <silent> <buffer> <Space> :cal OnDoubleClick(0)<CR>
	noremap <silent> <buffer> <CR> :cal OnDoubleClick(1)<CR>
	noremap <silent> <buffer> <Down> :cal GotoNextEntry()<CR>
	noremap <silent> <buffer> <Up> :cal GotoPrevEntry()<CR>
	noremap <silent> <buffer> <S-Down> :cal GotoNextNode()<CR>
	noremap <silent> <buffer> <S-Up> :cal GotoPrevNode()<CR>
	noremap <silent> <buffer> <BS> :cal BuildParentTree()<CR>
	noremap <silent> <buffer> q :cal CloseExplorer()<CR>
	noremap <silent> <buffer> n :cal InsertFilename()<CR>
	noremap <silent> <buffer> p :cal InsertFileContent()<CR>
	noremap <silent> <buffer> s :cal FileSee()<CR>
	noremap <silent> <buffer> N :cal FileRename()<CR>
	noremap <silent> <buffer> D :cal FileDelete()<CR>
	noremap <silent> <buffer> C :cal FileCopy()<CR>
	noremap <silent> <buffer> O :cal FileMove()<CR>
	noremap <silent> <buffer> H :cal ToggleShowHidden()<CR>
	noremap <silent> <buffer> M :cal SetMatchPattern()<CR>
endf

fu! InitCommonOptions()
	setl noscrollbind
	setl nowrap
	setl nonu
endf

fu! InitColors()
	sy clear
	if s:use_colors
		syn match OpsPath "^/.*"
		syn match OpsNode "^\s*[+-]"
		syn match OpsFile "^\s*\w\w*.*$"
		syn match OpsSource "^\s*\w\w*.*\.c$"
		syn match OpsHeader "^\s*\w\w*.*\.h$"
		syn match OpsSpecial "^\s*\(Makefile\|config.mk\)$"
		hi link OpsPath Label
		hi link OpsNode Comment
		"hi link OpsFile Question
		hi link OpsFile Comment
		hi link OpsSource Question
		hi link OpsHeader Include
		hi link OpsSpecial Function
	en
endf

fu! Opsplore(...)
	" create explorer window
	" take argument as path, if given
	if a:0>0
		let path=a:1
	el
		" otherwise current dir
		let path=getcwd()
	en
	" substitute leading ~
	" (doesn't work with isdirectory() otherwise!)
	let path=fnamemodify(path,":p")
	" expand, if relative path
	if path[0]!="/"
		let path=getcwd()."/".path
	en
	" setup options
	cal InitOptions()
	" create new window
	let splitcmd='new'
	if s:split_vertical
		let splitcmd='vne'
	en
	let splitcmd=s:split_width.splitcmd
	exe splitcmd
	exe "setl wiw=".s:split_minwidth
	" remember buffer nr
	let s:window_bufnr=winbufnr(0)
	" setup mappings, apply options, colors and draw tree
	cal InitCommonOptions()
	cal InitMappings()
	cal InitColors()
	cal BuildTree(path)
	let g:opsplorer_loaded=1
endf

fu! ToggleShowExplorer()
	if exists("g:opsplorer_loaded")
		exe s:window_bufnr."bd"
		unl g:opsplorer_loaded
	el
		cal Opsplore()
	en
endf

fu! CloseExplorer()
	winc c
endf

fu! BuildTree(path)
	let path=a:path
	" clean up
	setl ma
	norm ggVGxo
	" check if no unneeded trailing / is there
	if strlen(path)>1&&path[strlen(path)-1]=="/"
		let path=strpart(path,0,strlen(path)-1)
	en
	cal setline(1,path)
	setl noma nomod
	" pass -1 as xpos to start at column 0
	cal TreeExpand(-1,1,path)
	" move to first entry
	norm ggj1|g^
endf

fu! InsertFilename()
	norm 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	winc p
	exe "norm a".filename
endf

fu! InsertFileContent()
	norm 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		winc p
		exe "r ".filename
	en
endf

fu! FileSee()
	norm 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		let i=system("see ".filename."&")
	en
endf

fu! FileRename()
	norm 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		let newfilename=input("Rename to: ",filename)
		if filereadable(newfilename)
			if input("File exists, overwrite?")=~"^[yY]"
				setl ma
				let i=system("mv -f ".filename." ".newfilename)
				" refresh display
				norm gg$
				cal OnDoubleClick(-1)
			en
		el
			" rename file
			setl ma
			let i=system("mv ".filename." ".newfilename)
			norm gg$
			cal OnDoubleClick(-1)
		en
	en
endf

fu! FileMove()
	norm 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		let newfilename=input("Move to: ",filename)
		if filereadable(newfilename)
			if input("File exists, overwrite?")=~"^[yY]"
				" move file
				let i=system("mv -f ".filename." ".newfilename)
				" refresh display
				norm gg$
				cal OnDoubleClick(-1)
			en
		el
			" move file
			let i=system("mv ".filename." ".newfilename)
			" refresh display
			norm gg$
			cal OnDoubleClick(-1)
		en
	en
endf

fu! FileCopy()
	norm 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		let newfilename=input("Copy to: ",filename)
		if filereadable(newfilename)
			if input("File exists, overwrite?")=~"^[yY]"
				" copy file
				let i=system("cp -f ".filename." ".newfilename)
				" refresh display
				norm gg$
				cal OnDoubleClick(-1)
			en
		el
			" copy file
			let i=system("cp ".filename." ".newfilename)
			" refresh display
			norm gg$
			cal OnDoubleClick(-1)
		en
	en
endf

fu! FileDelete()
	norm 1|g^
	let filename=GetPathName(col('.')-1,line('.'))
	if filereadable(filename)
		if input("OK to delete ".fnamemodify(filename,":t")."? ")[0]=~"[yY]"
			let i=system("rm -f ".filename)
			setl ma
			norm ddg^
			setl noma
		en
	en
endf

fu! BuildParentTree()
	norm gg$F/
	cal OnDoubleClick(0)
endf

fu! GotoNextNode()
	" in line 1 like next entry
	if line('.')==1
		cal GotoNextEntry()
	el
		norm j1|g^
		wh getline('.')[col('.')-1] !~ "[+-]" && line('.')<line('$')
			norm j1|g^
		endw
	en
endf

fu! GotoPrevNode()
	" entering base path section?
	if line('.')<3
		cal GotoPrevEntry()
	el
		norm k1|g^
		wh getline('.')[col('.')-1] !~ "[+-]" && line('.')>1
			norm k1|g^
		endw
	en
endf

fu! GotoNextEntry()
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

fu! GotoPrevEntry()
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

fu! OnClick()
	let xpos=col('.')-1
	let ypos=line('.')
	if IsTreeNode(xpos,ypos)
		cal TreeNodeAction(xpos,ypos)
	elsei s:single_click_to_edit
		cal OnDoubleClick()
	en
endf

fu! OnDoubleClick(close_explorer)
	let s:close_explorer=a:close_explorer
	if s:close_explorer==-1
		let s:close_explorer=s:close_explorer_after_open
	en
	let xpos=col('.')-1
	let ypos=line('.')
	" clicked on node
	if IsTreeNode(xpos,ypos)
		cal TreeNodeAction(xpos,ypos)
	el
		" go to first non-blank when line>1
		if ypos>1
			norm 1|g^
			let xpos=col('.')-1
			" check, if it's a directory
			let path=GetPathName(xpos,ypos)
			if isdirectory(path)
				" build new root structure
				cal BuildTree(path)
				exe "cd ".getline(1)
			el
				" try to resolve filename
				" and open in other window
				let path=GetPathName(xpos,ypos)
				if filereadable(path)
					" go to last accessed buffer
					winc p
					" append sequence for opening file
					exe "cd ".fnamemodify(path,":h")
					exe "e ".path
					setl ma
				en
				if s:close_explorer==1
					cal ToggleShowExplorer()
				en
			en
		el
			" we're on line 1 here! getting new base path now...
			" advance to next slash
			if getline(1)[xpos]!="/"
				norm f/
				" no next slash -> current directory, just rebuild
				if col('.')-1==xpos
					cal BuildTree(getline(1))
					exe "cd ".getline(1)
					retu
				en
			en
			" cut ending slash
			norm h
			" rebuild tree with new path
			cal BuildTree(strpart(getline(1),0,col('.')))
		en
	en
endf

fu! GetPathName(xpos,ypos)
	let xpos=a:xpos
	let ypos=a:ypos
	" check for directory..
	if getline(ypos)[xpos]=~"[+-]"
		let path='/'.strpart(getline(ypos),xpos+1,col('$'))
	el
		" otherwise filename
		let path='/'.strpart(getline(ypos),xpos,col('$'))
		let xpos=xpos-1
	en
	" walk up tree and append subpaths
	let row=ypos-1
	let indent=xpos
	wh indent>0
		" look for prev ident level
		let indent=indent-1
		wh getline(row)[indent] != '-'
			let row=row-1
			if row == 0
				retu ""
			en
		endw
		" subpath found, append
		let path='/'.strpart(getline(row),indent+1,strlen(getline(row))).path
	endw 
	" finally add base path
	" not needed, if in root
	if getline(1)!='/'
		let path=getline(1).path
	en
	retu path
endf

fu! TreeExpand(xpos,ypos,path)
	let path=a:path
	setl ma
	" turn + into -
	norm r-
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
		let entry=GetNextLine(dirlist)
		let dirlist=CutFirstLine(dirlist)
		" add to tree if directory
		if isdirectory(entry)
			let entry=substitute(entry,".*/",'','')
			if entry!="." && entry!=".."
				" indent, mark as node and append
				let entry=SpaceString(a:xpos+1)."+".entry
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
		let entry=GetNextLine(dirlist)
		let dirlist=CutFirstLine(dirlist)
		" only files
		if entry!="." && entry!=".." && entry!=""
			if !isdirectory(entry)&&filereadable(entry)
				let entry=substitute(entry,".*/",'','')
				" indent and append
				let entry=SpaceString(a:xpos+2).entry
				cal append(row,entry)
				let row=row+1
			en
		en
	endw
	setl noma nomod
endf

fu! TreeCollapse(xpos,ypos)
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

fu! TreeNodeAction(xpos,ypos)
	if getline(a:ypos)[a:xpos] == '+'
		cal TreeExpand(a:xpos,a:ypos,GetPathName(a:xpos,a:ypos))
	elsei getline(a:ypos)[a:xpos] == '-'
		cal TreeCollapse(a:xpos,a:ypos)
	en
endf

fu! IsTreeNode(xpos,ypos)
	if getline(a:ypos)[a:xpos] =~ '[+-]'
		" is it a directory or file starting with +/- ?
		if isdirectory(GetPathName(a:xpos,a:ypos))
			retu 1
		el
			retu 0
		en
	el
		retu 0
	en
endf

fu! ToggleShowHidden()
	let s:show_hidden_files = 1-s:show_hidden_files
	cal BuildTree(getline(1))
endf

fu! SetMatchPattern()
	let s:file_match_pattern=input("Match pattern: ",s:file_match_pattern)
	cal BuildTree(getline(1))
endf

fu! GetNextLine(text)
	let pos=match(a:text,"\n")
	retu strpart(a:text,0,pos)
endf

fu! CutFirstLine(text)
	let pos=match(a:text,"\n")
	retu strpart(a:text,pos+1,strlen(a:text))
endf

fu! GetPathName(xpos,ypos)
	let xpos=a:xpos
	let ypos=a:ypos
	" check for directory..
	if getline(ypos)[xpos]=~"[+-]"
		let path='/'.strpart(getline(ypos),xpos+1,col('$'))
	el
		" otherwise filename
		let path='/'.strpart(getline(ypos),xpos,col('$'))
		let xpos=xpos-1
	en
	" walk up tree and append subpaths
	let row=ypos-1
	let indent=xpos
	wh indent>0
		" look for prev ident level
		let indent=indent-1
		wh getline(row)[indent] != '-'
			let row=row-1
			if row == 0
				retu ""
			en
		endw
		" subpath found, append
		let path='/'.strpart(getline(row),indent+1,strlen(getline(row))).path
	endw 
	" finally add base path
	" not needed, if in root
	if getline(1)!='/'
		let path=getline(1).path
	en
	retu path
endf

fu! SpaceString(width)
	let spacer=""
	let width=a:width
	wh width>0
		let spacer=spacer." "
		let width=width-1
	endw
	retu spacer
endf

