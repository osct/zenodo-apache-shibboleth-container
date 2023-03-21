## Overview
This Docker image is zenodo software from CERN with Apache 2.4 and Shibboleth SP 3.0.3 installed running on CentOS 7.

This image can be used as a base image overriding the configuration with local changes.

Ports 80 and 443 are exposed for traffic.

The image is built to be used mainly inside a kubernetes deployment because it requires several background service to work properly. An example of kubernetes deployment can be found at

  https://github.com/osct/zenodo-kubernetes


## Building

From source:

```
$ docker build --tag="<org_id>/zenodo" github.com/osct/zenodo-apache-shibboleth-container
```

A container built with this repository is available on INFN container registry for this project

  https://baltig.infn.it/infnct/dev/zenodo/container_registry

and on docker hub at

  https://hub.docker.com/r/infnct/zenodo


## Author

  * Marco Fargetta (<marco.fargetta@ct.infn.it>)
  * Riccardo Rotondo (<riccardo.rotondo@ct.infn.it>)

### Based on

The Apache and Shibboleth installation and configuration is based on the work of:

  * John Gasper (<jgasper@unicon.net>)

Code available at

  https://github.com/Unicon/shibboleth-sp-dockerized

## LICENSE

Copyright 2016 Unicon, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
