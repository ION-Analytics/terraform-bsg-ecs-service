`container_definitions` module
-----------------------------

[![Build Status](https://travis-ci.org/mergermarket/tf_ecs_container_definition.svg?branch=master)](https://travis-ci.org/mergermarket/tf_ecs_container_definition)

This module should contain the logic that generates our default set of container definitions,
providing the rendered definitions as an output.

Input variables
---------------

 * `container_name` - (string) **REQUIRED** - Name/name prefix to apply to the resources in the module.
 * `image` - (string) **REQUIRED** - The docker image in use
 * `container_port` - (string) OPTIONAL -App port to expose in the container. Default 8080.
 * `cpu`- (string) OPTIONAL -The CPU limit for this container definition
 * `privileged`- (boolean) OPTIONAL - The container has privileged access to the hosts, default is false.
 * `memory`- (string) OPTIONAL - The memory limit for this container definition
 * `stop_timeout`- (number) OPTIONAL - Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own.
 * `env`: (map) OPTIONAL - map with environment variables
 * `metadata`: (map) OPTIONAL - Set of metadata for this container. It will be passed as environment variables (key uppercased) and labels.
 * `mountpoint`: (map) OPTIONAL - Configuration of one mountpoint for this volume. Map with the values `sourceVolume`, `containerPath` and (optional) `readOnly` .
 * `extra_hosts`: list(object({name=string, ipAdress=string})) OPTIONAL - List of extra hosts to add to the container's /etc/hosts file.

Usage
-----

```hcl
module "container_defintions" {
  source = "mergermarket/ecs-container-definition/acuris"

  name           = "some-app"
  image          = "repo/image"
  container_port = "8080"
  cpu            = 1024
  memory         = 256

  container_env = {
    VAR1 = "value1"
    VAR2 = "value2"
  }

  metadata = {
    "label1" = "label.one"
    "label2" = "label.two"
  }

  mountpoint = {
    sourceVolume  = 'data_volume',
    containerPath = '/mnt/data',
    readOnly      = true
  }
  extraHosts = [{"hostname": "host1", "ipAddress": "10.0.0.1"}]
}
```

Outputs
-------

 * `rendered`: rendered container definition
