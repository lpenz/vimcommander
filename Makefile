
SOURCE += doc/vimcommander.txt
SOURCE += plugin/vimcommander.vim
PROGRAM_NAME = "vimcommander"
PROGRAM_VERSION = "0.80"
NAME = $(patsubst "%",%,$(PROGRAM_NAME))
VERS = $(patsubst "%",%,$(PROGRAM_VERSION))


all: $(SOURCE)


doc/vimcommander.txt: vimcommander.txt
	mkdir -p $(dir $@); sed 's/\$$VERSION/$(PROGRAM_VERSION)/g' $^ > $@


plugin/vimcommander.vim: vimcommander.vim
	mkdir -p $(dir $@); sed 's/\$$VERSION/$(PROGRAM_VERSION)/g' $^ > $@


vba: $(NAME)_$(VERS).vba


$(NAME)_$(VERS).vba: $(SOURCE)
	vim -X --cmd 'let g:plugin_name="$@"' -s build.vim > /dev/null


clean:
	rm -f $(NAME)_$(VERS).vba $(SOURCE)
	-rmdir doc plugin


