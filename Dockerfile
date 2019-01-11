ARG IMAGE_TAG="alpine"
FROM golang:${IMAGE_TAG}

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

RUN apk add git zip && \
    rm -rf /var/cache/apk/*

WORKDIR /go/src/lambda-app

ADD ./github/actions/go/lambda-app/* /go/src/lambda-app

RUN go version

RUN go get -v .
RUN go build lambda_handler.go
RUN zip handler.zip ./lambda_handler

RUN ls -alt