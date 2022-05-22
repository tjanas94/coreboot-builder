.PHONY: build run

build:
	docker build -t coreboot-builder .

run:
	docker run --rm -it -v $(PWD):/workspace coreboot-builder bash
