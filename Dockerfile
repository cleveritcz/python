FROM rockylinux/rockylinux:9-minimal as base

# Builder
FROM base as builder

RUN microdnf install -y which findutils tar clang git wget gcc llvm-devel zlib-devel openssl-devel bzip2-devel git libffi-devel && \
    wget -qq https://www.python.org/ftp/python/3.6.15/Python-3.6.15.tgz && tar -xvf Python-3.6.15.tgz && \
    mkdir ~/python3.6 && cd Python-3.6.15 && CC=clang LLVM_PROFDATA=/usr/bin/llvm-profdata \
    ./configure --prefix=/app/python3.6 --enable-optimizations --with-ensurepip=install \
    && CC=clang make && CC=clang make install

FROM base

ENV PATH="/app/python3.6/bin:$PATH"

RUN microdnf update -y && microdnf clean all

COPY --from=builder /app/ /app/

WORKDIR /app

ENTRYPOINT ["python3"]
