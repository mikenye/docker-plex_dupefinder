# mikenye/plex_dupefinder

This is a docker image containing the [`plex_dupefinder`](https://github.com/l3uddz/plex_dupefinder) utility and all of its prerequisites.

[Plex DupeFinder](https://github.com/l3uddz/plex_dupefinder) is a python script that finds duplicate versions of media (TV episodes and movies) in your Plex Library and tells Plex to remove the lowest rated files/versions (based on user-specified scoring) to leave behind a single file/version.

It is a fantastically useful utility created by [l3uddz](https://github.com/l3uddz).

## Multi Architecture Support

This image should pull and run on the following architectures:

* `linux/amd64` (`x86_64`): Built on Linux x86-64
* `linux/arm/v7` (`armv7l`, `armhf`, `arm32v7`): Built on Odroid HC2 running ARMv7 32-bit
* `linux/arm64` (`aarch64`, `arm64v8`): Built on a Raspberry Pi 4 Model B running ARMv8 64-bit

## Quick Start

**NOTE**: The docker command provided in this quick start is given as an example, and parameters should be adjusted to your needs.

It is suggested to configure an alias as follows (and place into your `.bash_aliases` file):

```shell
alias plex_dupefinder='docker run \
                 --rm -it \
                 -e PGID=$(id -g) \
                 -e PUID=$(id -u) \
                 -v /opt/plex_dupefinder:/config:rw \
                 mikenye/plex_dupefinder'
```

This will:

* Launch `plex_dupefinder` using the UID and GID of the current user.
* Map `/opt/plex_dupefinder` on the host through to the container at `/config`.

## First run

When first run, `plex_dupefinder` will ask a set of questions, allowing a `config.json` file to be generated, and stored under `/config` within the container. You'll see in the alias above, we're mapping this through to the host at `/opt/plex_dupefinder`.

See below for an example of the first run:

```text
$ plex_dupefinder
[s6-init] making user provided files available at /var/run/s6/etc...exited 0.
[s6-init] ensuring user provided files have correct perms...exited 0.
[fix-attrs.d] applying ownership & permissions fixes...
[fix-attrs.d] done.
[cont-init.d] executing container initialization scripts...
[cont-init.d] 01-plex_dupefinder: executing...
[cont-init.d] 01-plex_dupefinder: exited 0.
[cont-init.d] done.
[services.d] starting services
[services.d] done.

Dumping default config to: /opt/plex_dupefinder/config.json
Plex Server URL: http://10.0.0.42:32400
Plex Username: johnny.tightlips
Plex Password:
Auto Delete duplicates? [y/n]: n
Please edit the default configuration before running again!

[cmd] /usr/local/bin/plex_dupefinder exited 0
[cont-finish.d] executing container finish scripts...
[cont-finish.d] 99-plex_dupefinder: executing...
[cont-finish.d] 99-plex_dupefinder: exited 0.
[cont-finish.d] done.
[s6-finish] waiting for services.
[s6-finish] sending all processes the TERM signal.
[s6-finish] sending all processes the KILL signal and exiting.
```

After the first run, you'll need to edit your `config.json` file to include the libraries you'd like `plex_dupefinder` to check for duplicates.

I would recommend reading [the `plex_dupefinder` documentation](https://github.com/l3uddz/plex_dupefinder/blob/master/README.md#configuration) for more information on this.

**Note**: a Plex token for your library is stored within the config.json, so be sure to adjust permissions accordingly.

## Environment Variables

To customize some properties of the container, the following environment variables can be passed via the `-e` parameter (one for each variable). This paramater has the format `<VARIABLE_NAME>=<VALUE>`.

| Variable | Description | Recommended Setting | Default Setting |
|----------|-------------|---------------------|-----------------|
| PGID     | The Group ID that the `plex_dupefinder` process will run as | `$(id -u)` for the current user's GID | 1000 |
| PUID     | The User ID that the `plex_dupefinder` process will run as | `$(id -g)` for the current user's UID | 1000 |

## Data Volumes

There are no data volumes explicity set in the Dockerfile, however:

| Container Path | Permissions | Description |
|----------------|-------------|-------------|
| `/config`      | rw          | Holds the `config.json` file for `plex_dupefinder`. |

## Ports

No port mappings are required for this container.

## Docker Image Update

If the system on which the container runs doesn't provide a way to easily update the Docker image (eg: watchtower), simply pull the latest version of the container:

```shell
docker pull mikenye/plex_dupefinder
```

## Shell access

To get shell access to a running container, execute the following command:

```shell
docker exec -ti CONTAINER sh
```

Where `CONTAINER` is the name of the running container.

To start a container with a shell (instead of `plex_dupefinder`), execute the following command:

```shell
docker run --rm -ti --entrypoint=/bin/sh mikenye/plex_dupefinder
```

## Support or Contact

Having troubles with the container or have questions? Please [create a new issue](https://github.com/mikenye/docker-plex_dupefinder/issues).
