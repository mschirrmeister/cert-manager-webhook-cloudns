variable "DEFAULT_TAG" {
  default = "cert-manager-webhook-cloudns:local"
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
  tags = ["${DEFAULT_TAG}"]
}

// Default target if none specified
group "default" {
  targets = ["image-local"]
}

// https://docs.docker.com/build/bake/reference/#target
// show config as: docker buildx bake --print image-basic
target "image-basic" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "Dockerfile"
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

// must check by parent image support multi-platform
// doc: https://docs.docker.com/reference/cli/docker/buildx/build/#platform
// most of can as: linux/amd64 linux/386 linux/arm64/v8 linux/arm/v7 linux/arm/v6 linux/ppc64le linux/s390x
target "image-basic-all" {
  inherits = ["image-basic"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

target "image-debian" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "build-cm-114-debian.Dockerfile"
  tags = ["${DEFAULT_TAG}-debian"]
}

// show config as: docker buildx bake --print image-debian-all
target "image-debian-all" {
  inherits = ["image-debian"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

target "image-alpine" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "build-cm-114-alpine.Dockerfile"
  tags = ["${DEFAULT_TAG}-alpine"]
}

// show config as: docker buildx bake --print image-alpine-all
target "image-alpine-all" {
  inherits = ["image-alpine"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

