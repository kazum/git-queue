INSTALL?=install

SCRIPTS = $(filter-out $(wildcard *~),$(wildcard git-q*))
GIT_EXEC_PATH = $(shell git --exec-path)

.PHONY: all 
all:
	@echo "Nothing to build, it is all bash :)"
	@echo "Try make install"

.PHONY: install
install:
	$(INSTALL) -m 755 $(SCRIPTS) $(GIT_EXEC_PATH)
