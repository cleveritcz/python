FROM rockylinux/rockylinux:9-minimal as base

# Builder
FROM base as builder

RUN microdnf install -y tar git wget gcc zlib-devel openssl-devel bzip2-devel git libffi-devel

RUN wget -qq https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz && tar -xvf Python-3.9.16.tgz

RUN mkdir ~/python3.9 && cd Python-3.9.16 && ./configure --prefix=/app/python3.9 && make && make install

FROM base

ENV PATH="/app/python3.9/bin:$PATH"
COPY --from=builder /app/ /app/

RUN microdnf update -y && microdnf clean all

WORKDIR /app

ENTRYPOINT ["python3"]
