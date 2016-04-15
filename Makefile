dir=YaST/Repos
INPUT=$(wildcard $(dir)/*.in)
OUTPUT=$(INPUT:%.in=%)
POFILES=$(wildcard po/*.po)

all: $(OUTPUT)

po/community-repositories.pot: $(INPUT)
	@for i in $^; do intltool-extract --type=gettext/xml $$i; done
	xgettext -kN_ -o $@ $(dir)/*.h
	sed -i -e '/#:/s/.in.h:/.in:/g' $@
	@rm -f $(dir)/*.h

%.po: po/community-repositories.pot
	@echo -n "$@ "
	@msgmerge --previous -U $@ $<
	@touch $@

%.xml: $(POFILES)
	@intltool-merge --xml-style po $@.in $@

publish:
	ssh root@ftp-opensuse.suse.de 'cd /srv/www-local/download; git pull'

.SUFFIXES: .xml .in .pot .po
.PHONY: all
