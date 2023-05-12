help:
	@cat Makefile

build:
	docker buildx build -t docker-intellij-format:latest .
