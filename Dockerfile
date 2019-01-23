FROM gcr.io/cloud-builders/go

ENV GOPATH=/go
ENV GOOS=linux
ENV CC=/usr/bin/x86_64-alpine-linux-musl-gcc

WORKDIR /go/src/app

ADD ./*.go /go/src/app

RUN pwd && ls -alt

RUN apk add zip

RUN go get -v .
RUN go build \
      -x -ldflags '-linkmode external -extldflags "-static"' \
      -o lambda_handler lambda_handler.go
RUN zip handler.zip ./lambda_handler

RUN ls -alt