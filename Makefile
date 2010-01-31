
PLUGIN = vimcommander
SOURCE += doc/vimcommander.txt
SOURCE += plugin/vimcommander.vim
PROGRAM_VERSION = "0.78"


all:


doc/vimcommander.txt: vimcommander.txt
	mkdir -p $(dir $@); sed 's/\$$VERSION/$(PROGRAM_VERSION)/g' $^ > $@


plugin/vimcommander.vim: vimcommander.vim
	mkdir -p $(dir $@); sed 's/\$$VERSION/$(PROGRAM_VERSION)/g' $^ > $@


${PLUGIN}.vba: ${SOURCE}
	vim -X --cmd 'let g:plugin_name="${PLUGIN}"' -s build.vim > /dev/null


clean:
	rm -f ${PLUGIN}.vba
	rm -f doc/vimcommander.txt plugin/vimcommander.vim
	-rmdir doc plugin


