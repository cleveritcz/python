FROM rockylinux/rockylinux:9-minimal as base

# Builder
FROM base as builder

RUN microdnf install -y which findutils tar git wget gcc zlib-devel openssl-devel bzip2-devel git libffi-devel && \
    wget -qq https://www.python.org/ftp/python/3.8.16/Python-3.8.16.tgz && tar -xvf Python-3.8.16.tgz && \
    mkdir ~/python3.8 && cd Python-3.8.16 && ./configure --enable-optimizations \
    --with-ensurepip=install --prefix=/app/python3.8 && make && make install

FROM base

ENV PATH="/app/python3.8/bin:$PATH"

RUN microdnf update -y && microdnf clean all

COPY --from=builder /app/ /app/

WORKDIR /app

ENTRYPOINT ["python3"]
