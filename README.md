Sysbox-Powered Github Actions Runner
====================================

The GitHub-action runner image generated by this repository is expected to be powered by the [Sysbox](https://github.com/nestybox/sysbox) container runtime. The runner binary being utilized and the associated configuration process have been extracted and documented [here](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/hosting-your-own-runners).

There are similar containerized github-actions runners (GHA) out there, such as the one this repository is originally [based on](https://github.com/myoung34/docker-github-actions-runner). However, our main purpose is to offer differentiated value by utilizing the Sysbox runtime.

Finally, I'd like to point out that the scope of this repository is limited to Docker-generated GHA runner deployments. Please refer to the [GHA-controller](https://github.com/actions/actions-runner-controller) project for Kubernetes scenarios.

## Why Sysbox?

These are some of the issues we have identified to justify the creation of this repository:

* Equivalent solutions rely on the execution of `privileged` containers, which are known to pose serious security challenges.
* Other solutions bind-mount the host's docker-engine socket into the GHA runner container, representing a security threat.
* The above limitations constrain the use of one GHA runner per host. That is, `privileged` containers offer weak isolation among containers/host, and a single docker-engine can't be shared across multiple docker-clis.

Sysbox addresses the above challenges by providing stronger isolation among GHA runner instances and between runners and the host. Sysbox also allows the execution of Docker binaries (and plugins) within a container without resorting to `privileged` containers. In consequence, Sysbox can be used to host multiple GHA runners within the same machine.

## Quick-Start ##

* Install Sysbox runtime in a Linux VM as indicated [here](https://github.com/nestybox/sysbox#installing-sysbox). Alternatively (easiest approach), launch an EC2 instance using Docker's DinD AMI (todo: provide details), which already contains all the required components.

* Git clone this repo and execute the `gha_runner_create.sh` script with the following parameters:

```
$ ./gha_runner_create.sh <runner-name> <org> <repo-name> <runner-token>
```

Example:

```
$ ./gha_runner_create.sh gha-runner-1 nestybox sysbox-pkgr AEEK3VNZQDRMZVBWK5QFV6DFDCYMY
27dfce314877c7dcc19110d04b61a3904d24fa093aace80e63a9cff8676abede
$
```

Note 1: The runner-token must be previously generated by going through the simple steps depicted in this GH [guide](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners#adding-a-self-hosted-runner-to-a-repository). Notice that we only need to extract the `runner-token` displayed in the GH instructions, hence, there's no need to complete the suggested steps (our runner will take care of this process for us).

Note 2: This script can be easily modified to use a GH Personal-Access-Token, further simplifying the runner creation process since we wouldn't need to obtain a runner-token.
