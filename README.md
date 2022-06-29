# Containerized Kubelet

This repository contains Docker images for all kubelet versions currently supported by upstream.
Both amd64 and arm64 are provided as multiarch images.

## Images

The published Docker images can be found on quay.io: https://quay.io/kubermatic/kubelet

Currently the following images are available:

<!-- versions_start -->
| Minor | Latest Version | multi-arch | amd64 | arm64 |
| ----- | ------- | ---------- | ----- | ----- |
| 1.25 | v1.25.0-alpha.2 | [`v1.25.0-alpha.2`](https://quay.io/kubermatic/kubelet:v1.25.0-alpha.2) | [`v1.25.0-alpha.2-amd64`](https://quay.io/kubermatic/kubelet:v1.25.0-alpha.2-amd64) | [`v1.25.0-alpha.2-arm64`](https://quay.io/kubermatic/kubelet:v1.25.0-alpha.2-arm64) |
| 1.24 | v1.24.2 | [`v1.24.2`](https://quay.io/kubermatic/kubelet:v1.24.2) | [`v1.24.2-amd64`](https://quay.io/kubermatic/kubelet:v1.24.2-amd64) | [`v1.24.2-arm64`](https://quay.io/kubermatic/kubelet:v1.24.2-arm64) |
| 1.23 | v1.23.8 | [`v1.23.8`](https://quay.io/kubermatic/kubelet:v1.23.8) | [`v1.23.8-amd64`](https://quay.io/kubermatic/kubelet:v1.23.8-amd64) | [`v1.23.8-arm64`](https://quay.io/kubermatic/kubelet:v1.23.8-arm64) |
| 1.22 | v1.22.11 | [`v1.22.11`](https://quay.io/kubermatic/kubelet:v1.22.11) | [`v1.22.11-amd64`](https://quay.io/kubermatic/kubelet:v1.22.11-amd64) | [`v1.22.11-arm64`](https://quay.io/kubermatic/kubelet:v1.22.11-arm64) |
| 1.21 | v1.21.14 | [`v1.21.14`](https://quay.io/kubermatic/kubelet:v1.21.14) | [`v1.21.14-amd64`](https://quay.io/kubermatic/kubelet:v1.21.14-amd64) | [`v1.21.14-arm64`](https://quay.io/kubermatic/kubelet:v1.21.14-arm64) |
| 1.20 (EOL) | v1.20.15 | [`v1.20.15`](https://quay.io/kubermatic/kubelet:v1.20.15) | [`v1.20.15-amd64`](https://quay.io/kubermatic/kubelet:v1.20.15-amd64) | [`v1.20.15-arm64`](https://quay.io/kubermatic/kubelet:v1.20.15-arm64) |
| 1.19 (EOL) | v1.19.16 | [`v1.19.16`](https://quay.io/kubermatic/kubelet:v1.19.16) | [`v1.19.16-amd64`](https://quay.io/kubermatic/kubelet:v1.19.16-amd64) | [`v1.19.16-arm64`](https://quay.io/kubermatic/kubelet:v1.19.16-arm64) |
| 1.18 (EOL) | v1.18.20 | [`v1.18.20`](https://quay.io/kubermatic/kubelet:v1.18.20) | [`v1.18.20-amd64`](https://quay.io/kubermatic/kubelet:v1.18.20-amd64) | [`v1.18.20-arm64`](https://quay.io/kubermatic/kubelet:v1.18.20-arm64) |


<!-- versions_end -->

## Contributing

Thanks for taking the time to join our community and start contributing!

### Before you start

* Please familiarize yourself with the [Code of Conduct][3] before contributing.
* See [CONTRIBUTING.md][2] for instructions on the developer certificate of origin that we require.
* Read how [we're using ZenHub][13] for project and roadmap planning

### Pull requests

* We welcome pull requests. Feel free to dig through the [issues][1] and jump in.

[1]: https://github.com/kubermatic/kubelet/issues
[2]: https://github.com/kubermatic/kubelet/blob/master/CONTRIBUTING.md
[3]: https://github.com/kubermatic/kubelet/blob/master/CODE_OF_CONDUCT.md

[11]: https://groups.google.com/forum/#!forum/kubermatic-dev
[12]: https://kubermatic.slack.com/messages/kubelet
[13]: https://github.com/kubermatic/kubelet/blob/master/Zenhub.md
[15]: http://slack.kubermatic.io/
