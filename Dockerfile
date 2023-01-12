FROM rockylinux:9-minimal as base

ENV PYTHON_VERSION=3.9.16

# Builder
FROM base as builder

RUN microdnf install -y which findutils tar git wget gcc zlib-devel openssl-devel bzip2-devel git libffi-devel && \
    wget -qq https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && tar -xvf Python-$PYTHON_VERSION.tgz && \
    mkdir ~/python$PYTHON_VERSION && cd Python-$PYTHON_VERSION && ./configure --enable-optimizations \
    --with-ensurepip=install --prefix=/app/python$PYTHON_VERSION && make && make install

FROM base

ENV PATH="/app/python$PYTHON_VERSION/bin:$PATH"

RUN microdnf update -y && microdnf clean all

COPY --from=builder /app/ /app/

WORKDIR /app

ENTRYPOINT ["python3"]
