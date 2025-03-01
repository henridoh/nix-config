HOST ?= $(shell hostname)
HOSTS = solo c2

_all:
	@true
.PHONY: _all $(addprefix, _swtich_,${HOSTS}) _swtich_
.SUFFIXES:

switch: _switch_${HOST}

_switch_:
	@echo "ERROR: couldn't find hostname"
	@false
_switch_%:
	nixos-rebuild switch --flake .#$*