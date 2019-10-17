FROM debian:latest

RUN apt-get update && apt-get install -y \
	build-essential \
    devscripts \
    dh-exec

