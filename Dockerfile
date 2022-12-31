FROM rockylinux/rockylinux:9-minimal as base

# Builder
FROM base as builder

RUN microdnf install -y which findutils tar git wget gcc zlib-devel openssl-devel bzip2-devel git libffi-devel && \
    wget -qq https://www.python.org/ftp/python/3.10.9/Python-3.10.9.tgz && tar -xvf Python-3.10.9.tgz && \
    mkdir ~/python3.10 && cd Python-3.10.9 && ./configure --enable-optimizations \
    --with-ensurepip=install --prefix=/app/python3.10 && make && make install

FROM base

ENV PATH="/app/python3.10/bin:$PATH"

RUN microdnf update -y && microdnf clean all

COPY --from=builder /app/ /app/

WORKDIR /app

ENTRYPOINT ["python3"]
