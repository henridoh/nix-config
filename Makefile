HOST ?= $(shell hostname)
HOSTS = solo c2

.PHONY: all switch $(addprefix, _swtich_,${HOSTS}) _swtich_
.SUFFIXES:

all:
	@echo "Run \`make switch\` as root to rebuild and switch"
	@true

switch: _switch_${HOST}

apply:
	colmena apply

_switch_:
	@echo "ERROR: couldn't find hostname"
	@false
_switch_%:
	@if [ "$(shell whoami)" != "root" ]; then \
		echo "ERROR: Run as root!"; \
		false; \
	fi
	nixos-rebuild switch --flake .#$*
