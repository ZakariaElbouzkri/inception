FROM debian:buster

RUN apt-get update && apt-get install -y curl tar

RUN curl -LO https://github.com/portainer/portainer/releases/download/2.19.5/portainer-2.19.5-linux-amd64.tar.gz && \
    tar -xvf portainer-2.19.5-linux-amd64.tar.gz && \
    rm -rf portainer-2.19.5-linux-amd64.tar.gz

COPY tools/run.sh /run.sh

CMD ["/run.sh"]
