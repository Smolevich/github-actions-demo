FROM gcr.io/cloud-builders/go

ENV GOPATH=/go

RUN mkdir -p /go/src/app

ADD ./*.go /go/src/app

WORKDIR /go/src/app

RUN pwd && ls -alt

RUN apk add zip

WORKDIR /go/src/app

RUN go get -v .
RUN go build lambda_handler.go
RUN zip handler.zip ./lambda_handler

RUN ls -alt