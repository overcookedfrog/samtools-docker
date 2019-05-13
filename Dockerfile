FROM alpine:3.9 as builder
RUN apk add --no-cache build-base curl zlib-dev bzip2-dev xz-dev curl-dev openssl-dev ncurses-dev
WORKDIR /bcftools
RUN curl -L https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 | tar jx --strip-components=1 \
    && ./configure \
    && make -j \
    && make install \
    && cd htslib-1.9 \
    && make -j \
    && make install
WORKDIR /samtools
RUN curl -L https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 | tar jx --strip-components=1 \
    && ./configure \
    && make -j \
    && make install


FROM alpine:3.9
RUN apk add --no-cache zlib libbz2 xz-libs libcurl ncurses-libs openssl
COPY --from=builder /usr/local/bin/* /usr/local/bin/
