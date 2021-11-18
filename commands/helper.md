```bash
# step 1
dive europe-central2-docker.pkg.dev/distroless-329216/distroless/node-etape1
trivy europe-central2-docker.pkg.dev/distroless-329216/distroless/node-etape1
trivy -s HIGH,CRITICAL -f json -o /tmp/analyse.json  europe-central2-docker.pkg.dev/distroless-329216/distroless/node-etape1
jq '.[1].Vulnerabilities[].VulnerabilityID, .[1].Vulnerabilities[].PkgName' /tmp/analyse.json

# step 2
dive europe-central2-docker.pkg.dev/distroless-329216/distroless/node-etape2

# step distroless
dive europe-central2-docker.pkg.dev/distroless-329216/distroless/node-distroless

k create ns app
k run node-distroless --image=europe-central2-docker.pkg.dev/distroless-329216/distroless/node-distroless:latest
k exec -it node-distroless -- env
k debug -it node-distroless --image=paimpozhil/busybox-nano --copy-to=test --share-processes=true -- /bin/sh

# step CNB
docker build . -t base-cnb:1.0.1
docker tag base-cnb:1.0.1 europe-central2-docker.pkg.dev/distroless-329216/distroless/base-cnb:1.0.1
docker push europe-central2-docker.pkg.dev/distroless-329216/distroless/base-cnb:1.0.1
```