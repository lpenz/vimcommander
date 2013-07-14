
SOURCE += doc/vimcommander.txt
SOURCE += plugin/vimcommander.vim
NAME := $(shell sed -n 's/.*PROGRAM_NAME *=\? *"\([^ ]\+\)".*/\1/p' plugin/vimcommander.vim | head -1)
VERS := $(shell sed -n 's/.*PROGRAM_VERSION *=\? *"\([^ ]\+\)".*/\1/p' plugin/vimcommander.vim | head -1)


all:


vmb vba: $(NAME)_$(VERS).vmb


$(NAME)_$(VERS).vmb: $(SOURCE)
	vim -X --cmd 'let g:plugin_name="$(NAME)_$(VERS)"' -s build.vim


clean:
	rm -f $(NAME)_$(VERS).vba


