help:
	@cat Makefile

build:
	docker build -t docker-intellij-format:latest .
