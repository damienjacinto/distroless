apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  url: https://argocd-distroless.ddns.net
  statusbadge.enabled: 'true'
  # Dex handles OAuth single-sign-on (SSO).
  dex.config: |
    connectors:
      # Auth using GitHub.
      # See https://dexidp.io/docs/connectors/github/
      # For example, we can authorize only members of certain teams in orgs.
      - type: github
        id: github
        name: GitHub
        config:
          clientID: 2595f4cc1c9547209007
          clientSecret: $dex.github.clientSecret
  # Git repositories that Argo CD monitors.
  repositories: []
    #- url: https://github.com/argoproj/argocd-example-apps.git
  # Non-standard Helm chart repositories.
  helm.repositories: []
    # New default stable Helm chart repository
    #- url: https://charts.helm.sh/stable
    #  name: stable