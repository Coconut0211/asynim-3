FROM nimlang/nim:2.0.8

WORKDIR /app

COPY . .

RUN apt-get update
RUN apt-get install -y libpq-dev
RUN nimble install norm
RUN nimble install jester
RUN nim c -o:asynim_server asynim.nim

CMD ["./asynim_server"]