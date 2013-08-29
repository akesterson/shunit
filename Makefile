.PHONY: all
all:

install:
	install lib/junit.sh /usr/lib/junit.sh
	install lib/tunit.sh /usr/lib/tunit.sh

uninstall:
	rm /usr/lib/[tj]unit.sh
