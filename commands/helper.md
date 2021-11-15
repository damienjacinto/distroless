dive europe-central2-docker.pkg.dev/distroless-329216/distroless/node-etape1

trivy -s HIGH,CRITICAL -f json -o analyse.json  europe-central2-docker.pkg.dev/distroless-329216/distroless/node-etape1
cat analyse.json | jq '.[1].Vulnerabilities[].VulnerabilityID, .[1].Vulnerabilities[].PkgName'

dive europe-central2-docker.pkg.dev/distroless-329216/distroless/node-etape2
dive europe-central2-docker.pkg.dev/distroless-329216/distroless/node-distroless