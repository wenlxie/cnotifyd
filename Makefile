GO_BIN ?= go
ENV_BIN ?= env
OUT_BIN = cnotifyd

export PATH := $(PATH):/usr/local/go/bin

all: clean build

build:
	$(GO_BIN) mod tidy
	$(ENV_BIN) CGO_ENABLED=1 GOOS=linux $(GO_BIN) build -ldflags '-s -w -extldflags "-static"' -o $(OUT_BIN) -v

update:
	$(ENV_BIN) GOPROXY=direct $(GO_BIN) get -u
	$(GO_BIN) get -u github.com/golangci/golangci-lint/cmd/golangci-lint
	$(GO_BIN) get -u github.com/mgechev/revive
	$(GO_BIN) mod tidy

clean:
	$(GO_BIN) clean
	rm -f $(OUT_BIN)

test:
	$(GO_BIN) test -failfast ./...

lint:
	golangci-lint run ./...
	revive -config revive.toml -exclude ./vendor/... ./...