# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

ARG BASE_IMAGE=ghcr.io/ublue-os/bazzite-gnome:latest
FROM ${BASE_IMAGE}
ARG BASE_IMAGE

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN bootc container lint
