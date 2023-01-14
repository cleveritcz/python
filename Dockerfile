FROM rockylinux:9-minimal as base

ARG PYTHON_VERSION

# Builder
FROM base as builder

RUN echo -e "python:x:1000:" >> /etc/group && \
    echo -e "python:x:1000:1000:python:/app:/usr/sbin/nologin" >> /etc/passwd && \  
    echo -e "python:*:19295:0:99999:7:::" >> /etc/shadow

RUN microdnf install -y which findutils tar git wget gcc zlib-devel openssl-devel bzip2-devel git libffi-devel && \
    wget -qq https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && tar -xvf Python-${PYTHON_VERSION}.tgz && \
    mkdir ~/python${PYTHON_VERSION} && cd Python-${PYTHON_VERSION} && ./configure --enable-optimizations \
    --with-ensurepip=install --prefix=/app/python${PYTHON_VERSION} && make && make install

FROM base

ENV PATH="/app/python${PYTHON_VERSION}/bin:$PATH"

RUN microdnf update -y && microdnf clean all

COPY --from=builder /app/ /app/

USER python

WORKDIR /app

ENTRYPOINT ["python3"]
