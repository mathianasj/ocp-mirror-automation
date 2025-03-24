## Build Release

`podman build -t cmirror -v ${pwd}/pullsecret.json:/root/.docker/config.json:Z -v ${pwd}/imagesetconfig.yaml:/home/cmirror/imagesetconfig.yaml:Z .`
