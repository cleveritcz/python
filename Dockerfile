FROM rockylinux:9-minimal as base

ARG PYTHON_VERSION
# Builder
FROM base as builder

RUN echo -e "python:x:1000:" >> /etc/group && \
    echo -e "python:x:1000:1000:python:/app:/bin/sh" >> /etc/passwd && \  
    echo -e "python:*:19295:0:99999:7:::" >> /etc/shadow

RUN microdnf install -y which findutils tar clang git wget gcc llvm-devel zlib-devel openssl-devel bzip2-devel git libffi-devel && \
    wget -qq https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && tar -xvf Python-$PYTHON_VERSION.tgz && \
    mkdir ~/python$PYTHON_VERSION && cd Python-$PYTHON_VERSION && CC=clang LLVM_PROFDATA=/usr/bin/llvm-profdata \
    ./configure --prefix=/app/python$PYTHON_VERSION --enable-optimizations --with-ensurepip=install \
    && CC=clang make && CC=clang make install

FROM base

ENV PATH="/app/python$PYTHON_VERSION/bin:$PATH"

RUN microdnf update -y && microdnf clean all

COPY --from=builder /app/ /app/

WORKDIR /app

USER python

ENTRYPOINT ["python3"]
