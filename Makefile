.PHONY: all
all:

install:
	install lib/junit.sh /usr/lib/junit.sh
	install lib/tunit.sh /usr/lib/tunit.sh
	install shunit /usr/bin/shunit

uninstall:
	rm /usr/lib/[tj]unit.sh /usr/bin/shunit
