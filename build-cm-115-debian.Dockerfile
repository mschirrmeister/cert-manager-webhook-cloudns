FROM golang:1.22-bookworm AS build_deps

RUN apt-get update && apt-get -y dist-upgrade && apt-get clean \
    && apt-get install -y --no-install-recommends \
       git

WORKDIR /workspace
ENV GO111MODULE=on

RUN git clone --single-branch --branch cm-115 https://github.com/mschirrmeister/cert-manager-webhook-cloudns .

COPY go.mod .
COPY go.sum .

RUN go mod download

FROM build_deps AS build

COPY . .

RUN CGO_ENABLED=0 go build -o webhook -ldflags '-w -extldflags "-static"' .

FROM debian:12-slim

RUN apt-get update && apt-get -y dist-upgrade && apt-get clean \
    && apt-get install -y --no-install-recommends \
       ca-certificates

COPY --from=build /workspace/webhook /usr/local/bin/webhook

ENTRYPOINT ["webhook"]
