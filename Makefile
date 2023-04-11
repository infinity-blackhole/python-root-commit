.PHONY: all
all: sync

.PHONY: sync
sync:
	@hatch dep show requirements --project-only > requirements.txt