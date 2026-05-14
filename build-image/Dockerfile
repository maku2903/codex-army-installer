FROM opensuse/tumbleweed:latest

RUN zypper --non-interactive refresh \
    && zypper --non-interactive install --no-recommends \
        bash \
        ca-certificates \
        clang \
        curl \
        file \
        gcc \
        gcc-c++ \
        gawk \
        git \
        gzip \
        libopenssl-devel \
        make \
        pkgconf-pkg-config \
        rpm-build \
        tar \
        which \
        xz \
        zstd \
    && zypper clean --all

ENV RUSTUP_HOME=/opt/rustup
ENV CARGO_HOME=/opt/cargo
ENV PATH=/opt/cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --profile minimal --default-toolchain stable \
    && chmod -R a+w /opt/rustup /opt/cargo

