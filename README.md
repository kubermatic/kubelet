# Containerized Kubelet

This repository contains Docker images for all kubelet versions currently supported by upstream.
Both amd64 and arm64 are provided as multiarch images.

## Images

The published Docker images can be found on quay.io: https://quay.io/kubermatic/kubelet

Currently the following images are available:

<!-- versions_start -->
| Minor | Version | Type | Image |
| ----- | ------- | ---- | ----- |
| 1.22 | v1.22.0-rc.0 | multi-arch | [`quay.io/kubermatic/kubelet:v1.22.0-rc.0`](https://quay.io/kubermatic/kubelet:v1.22.0-rc.0) |
| | | amd64 | [`quay.io/kubermatic/kubelet:v1.22.0-rc.0-amd64`](https://quay.io/kubermatic/kubelet:v1.22.0-rc.0-amd64) |
| | | arm64 | [`quay.io/kubermatic/kubelet:v1.22.0-rc.0-arm64`](https://quay.io/kubermatic/kubelet:v1.22.0-rc.0-arm64) |
| 1.21 | v1.21.3 | multi-arch | [`quay.io/kubermatic/kubelet:v1.21.3`](https://quay.io/kubermatic/kubelet:v1.21.3) |
| | | amd64 | [`quay.io/kubermatic/kubelet:v1.21.3-amd64`](https://quay.io/kubermatic/kubelet:v1.21.3-amd64) |
| | | arm64 | [`quay.io/kubermatic/kubelet:v1.21.3-arm64`](https://quay.io/kubermatic/kubelet:v1.21.3-arm64) |
| 1.20 | v1.20.9 | multi-arch | [`quay.io/kubermatic/kubelet:v1.20.9`](https://quay.io/kubermatic/kubelet:v1.20.9) |
| | | amd64 | [`quay.io/kubermatic/kubelet:v1.20.9-amd64`](https://quay.io/kubermatic/kubelet:v1.20.9-amd64) |
| | | arm64 | [`quay.io/kubermatic/kubelet:v1.20.9-arm64`](https://quay.io/kubermatic/kubelet:v1.20.9-arm64) |
| 1.19 | v1.19.13 | multi-arch | [`quay.io/kubermatic/kubelet:v1.19.13`](https://quay.io/kubermatic/kubelet:v1.19.13) |
| | | amd64 | [`quay.io/kubermatic/kubelet:v1.19.13-amd64`](https://quay.io/kubermatic/kubelet:v1.19.13-amd64) |
| | | arm64 | [`quay.io/kubermatic/kubelet:v1.19.13-arm64`](https://quay.io/kubermatic/kubelet:v1.19.13-arm64) |
| 1.18 | v1.18.20 | multi-arch | [`quay.io/kubermatic/kubelet:v1.18.20`](https://quay.io/kubermatic/kubelet:v1.18.20) |
| | | amd64 | [`quay.io/kubermatic/kubelet:v1.18.20-amd64`](https://quay.io/kubermatic/kubelet:v1.18.20-amd64) |
| | | arm64 | [`quay.io/kubermatic/kubelet:v1.18.20-arm64`](https://quay.io/kubermatic/kubelet:v1.18.20-arm64) |


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
