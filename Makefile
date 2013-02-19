INSTALL?=install

SETUP_SCRIPT = git-qsh-setup
GITQ_SCRIPTS = $(filter-out $(wildcard *~) $(SETUP_SCRIPT), $(wildcard git-q*))
GIT_EXEC_PATH = $(shell git --exec-path)

.PHONY: all 
all:
	@echo "Nothing to build, it is all bash :)"
	@echo "Try make install"

.PHONY: install
install:
	$(INSTALL) -m 755 $(GITQ_SCRIPTS) $(GIT_EXEC_PATH)
	$(INSTALL) -m 644 $(SETUP_SCRIPT) $(GIT_EXEC_PATH)
