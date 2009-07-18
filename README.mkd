vimcommander
============


This is an adaptation of opsplorer
([vimscript #362](http://www.vim.org/scripts/script.php?script_id=808)),
intended to be more like the [Total Commander](http://www.ghisler.com) file
explorer.



Installation
------------

- Drop *vimcommander.vim* in *~/.vim/plugin*
- Put in you *.vimrc* a map to *VimCommanderToggle()* like this:  
    `noremap <silent> <F11> :cal VimCommanderToggle()<CR>`




Usage
-----

vimcommander opens two panels of file explorers on the top half of the vim screen.  
Targets for moving and copying defaults to the other panel, like totalcmd.  
TAB switches between panels.

Vimcommander keys are mostly totalcommander's:

- F3 - view
- F4 - edit
- F5 - copy
- F6 - move
- F7 - create dir
- F8 - del
- Others: C-U, C-Left/C-Right, C-R, BS, DEL, C-H, etc.
- Selection of files/dirs also works: INS, +, -.
    Then copy/move/del selected files.

Suggested binding is  
`noremap <silent> <F11> :cal VimCommanderToggle()<CR>`

Tested on Linux. I have reports that it doesn't work on Windows.


