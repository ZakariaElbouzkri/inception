FROM debian:buster

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get clean

COPY conf/index.html .

CMD ["python3", "-m", "http.server", "8000"]
