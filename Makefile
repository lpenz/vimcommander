
REVISION:=$(shell bzr revno)

all: vimcommander.vim $(HOME)/.vim/plugin/vimcommander.vim

clean:
	rm -f vimcommander.vim

vimcommander.vim: vimcommander.novers.vim
	sed -e "s/\$$Id:.*\$$/\$$Id: $@ version $(REVISION) $$/" -e "s/\$$Revision:.*\$$/\$$Revision: $(REVISION) $$/" $^ > $@

$(HOME)/.vim/plugin/vimcommander.vim: vimcommander.vim
	cp $^ $@

