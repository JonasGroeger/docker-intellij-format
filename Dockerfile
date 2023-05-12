FROM alpine:3.16 as builder

RUN apk add wget tar && \
    wget https://download-cdn.jetbrains.com/idea/ideaIC-2023.1.1.tar.gz -O /tmp/idea.tar.gz -q && \
    mkdir /tmp/idea && \
    tar -xf /tmp/idea.tar.gz --strip-components=1 -C /tmp/idea

# IntelliJ tries to write diagnostic data on exit.
# Move it to /tmp because its writable.
# Else we get an ugly (yet non-fatal) error on exit.
RUN echo 'idea.system.path=/tmp/' >> /tmp/idea/bin/idea.properties

# Make image smaller
# Trial and error until no more boot errors
RUN find /tmp/idea/plugins -mindepth 1 -maxdepth 1 \
        ! -name 'java' \
        ! -name 'java-ide-customization' \
        ! -name 'editorconfig' \
        -type d -exec rm -rf '{}' +

# Make image smaller
# Trial and error until no more ClassNotFoundException
RUN find /tmp/idea/lib -mindepth 1 -maxdepth 1 \
        ! -name 'app.jar' \
        ! -name 'util.jar' \
        ! -name 'util_rt.jar' \
        ! -name '3rd-party-rt.jar' \
        ! -name 'jna.jar' \
        ! -name 'dom-impl.jar' \
        ! -name 'jps-model.jar' \
        ! -name 'stats.jar' \
        ! -name 'protobuf.jar' \
        ! -name 'rd-core.jar' \
        ! -name 'forms_rt.jar' \
        ! -name 'dom-openapi.jar' \
        ! -name 'lz4-java.jar' \
        ! -name 'external-system-rt.jar' \
        ! -name 'jsp-base-openapi.jar' \
        -type f -exec rm -rf '{}' +

# Make image smaller
# Unnecessary folders. openjdk-17-jre-headless is smaller than the /tmp/idea/jbr directory
RUN rm -rf \
        /tmp/idea/bin/icons \
        /tmp/idea/lib/ant \
        /tmp/idea/jbr

FROM ubuntu:jammy-20230425

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get --yes update && \
    apt-get install --no-install-recommends --yes openjdk-17-jre-headless git && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/idea /idea
COPY myformat.sh /idea/bin/myformat.sh
WORKDIR /data

ENTRYPOINT ["/idea/bin/myformat.sh", "-settings"]
