# Containerized Kubelet

This repository contains Docker images for all kubelet versions currently supported by upstream.
Both amd64 and arm64 are provided as multiarch images.

## Images

The published Docker images can be found on quay.io: https://quay.io/kubermatic/kubelet

Currently the following images are available:

<!-- versions_start -->
| Minor | Latest Version | multi-arch | amd64 | arm64 |
| ----- | ------- | ---------- | ----- | ----- |
| 1.28 | v1.28.0-alpha.3 | [`v1.28.0-alpha.3`](https://quay.io/kubermatic/kubelet:v1.28.0-alpha.3) | [`v1.28.0-alpha.3-amd64`](https://quay.io/kubermatic/kubelet:v1.28.0-alpha.3-amd64) | [`v1.28.0-alpha.3-arm64`](https://quay.io/kubermatic/kubelet:v1.28.0-alpha.3-arm64) |
| 1.27 | v1.27.3 | [`v1.27.3`](https://quay.io/kubermatic/kubelet:v1.27.3) | [`v1.27.3-amd64`](https://quay.io/kubermatic/kubelet:v1.27.3-amd64) | [`v1.27.3-arm64`](https://quay.io/kubermatic/kubelet:v1.27.3-arm64) |
| 1.26 | v1.26.6 | [`v1.26.6`](https://quay.io/kubermatic/kubelet:v1.26.6) | [`v1.26.6-amd64`](https://quay.io/kubermatic/kubelet:v1.26.6-amd64) | [`v1.26.6-arm64`](https://quay.io/kubermatic/kubelet:v1.26.6-arm64) |
| 1.25 | v1.25.11 | [`v1.25.11`](https://quay.io/kubermatic/kubelet:v1.25.11) | [`v1.25.11-amd64`](https://quay.io/kubermatic/kubelet:v1.25.11-amd64) | [`v1.25.11-arm64`](https://quay.io/kubermatic/kubelet:v1.25.11-arm64) |
| 1.24 | v1.24.15 | [`v1.24.15`](https://quay.io/kubermatic/kubelet:v1.24.15) | [`v1.24.15-amd64`](https://quay.io/kubermatic/kubelet:v1.24.15-amd64) | [`v1.24.15-arm64`](https://quay.io/kubermatic/kubelet:v1.24.15-arm64) |
| 1.23 (EOL) | v1.23.17 | [`v1.23.17`](https://quay.io/kubermatic/kubelet:v1.23.17) | [`v1.23.17-amd64`](https://quay.io/kubermatic/kubelet:v1.23.17-amd64) | [`v1.23.17-arm64`](https://quay.io/kubermatic/kubelet:v1.23.17-arm64) |
| 1.22 (EOL) | v1.22.15 | [`v1.22.15`](https://quay.io/kubermatic/kubelet:v1.22.15) | [`v1.22.15-amd64`](https://quay.io/kubermatic/kubelet:v1.22.15-amd64) | [`v1.22.15-arm64`](https://quay.io/kubermatic/kubelet:v1.22.15-arm64) |
| 1.21 (EOL) | v1.21.14 | [`v1.21.14`](https://quay.io/kubermatic/kubelet:v1.21.14) | [`v1.21.14-amd64`](https://quay.io/kubermatic/kubelet:v1.21.14-amd64) | [`v1.21.14-arm64`](https://quay.io/kubermatic/kubelet:v1.21.14-arm64) |
| 1.20 (EOL) | v1.20.15 | [`v1.20.15`](https://quay.io/kubermatic/kubelet:v1.20.15) | [`v1.20.15-amd64`](https://quay.io/kubermatic/kubelet:v1.20.15-amd64) | [`v1.20.15-arm64`](https://quay.io/kubermatic/kubelet:v1.20.15-arm64) |
| 1.19 (EOL) | v1.19.16 | [`v1.19.16`](https://quay.io/kubermatic/kubelet:v1.19.16) | [`v1.19.16-amd64`](https://quay.io/kubermatic/kubelet:v1.19.16-amd64) | [`v1.19.16-arm64`](https://quay.io/kubermatic/kubelet:v1.19.16-arm64) |
| 1.18 (EOL) | v1.18.20 | [`v1.18.20`](https://quay.io/kubermatic/kubelet:v1.18.20) | [`v1.18.20-amd64`](https://quay.io/kubermatic/kubelet:v1.18.20-amd64) | [`v1.18.20-arm64`](https://quay.io/kubermatic/kubelet:v1.18.20-arm64) |


<!-- versions_end -->

## Contributing

Thanks for taking the time to join our community and start contributing!

### Before you start

* Please familiarize yourself with the [Code of Conduct][3] before contributing.
* See [CONTRIBUTING.md][2] for instructions on the developer certificate of origin that we require.

### Pull requests

* We welcome pull requests. Feel free to dig through the [issues][1] and jump in.

[1]: https://github.com/kubermatic/kubelet/issues
[2]: https://github.com/kubermatic/kubelet/blob/main/CONTRIBUTING.md
[3]: https://github.com/kubermatic/kubelet/blob/main/CODE_OF_CONDUCT.md

[11]: https://groups.google.com/forum/#!forum/kubermatic-dev
[12]: https://kubermatic.slack.com/messages/kubelet
