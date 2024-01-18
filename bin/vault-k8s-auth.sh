
#!/usr/bin/env bash
set -euo pipefail


JWT_ISSUER="https://kubernetes.default.svc"

VAULT_SA_NAME=${1:-none}
if [[ ${VAULT_SA_NAME} == "none" ]]; then
    echo "Please pass the VAULT_SA_NAME as 1st argument"
    exit 1
fi

NAMESPACE=${2:-none}
if [[ ${NAMESPACE} == "none" ]]; then
    echo "Please pass the NAMESPACE as 2nd argument"
    exit 1
fi



export SA_JWT_TOKEN=$(kubectl get secret ${VAULT_SA_NAME} -n ${NAMESPACE} --output 'go-template={{ .data.token }}'| base64 --decode)
export SA_CA_CRT=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)
export K8S_HOST=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.server}')


echo "Kubernetes Host: $K8S_HOST"
echo "Kubernetes Certificate: "
echo  $SA_CA_CRT
echo "Kubernetes Service Account JWT Token:"
echo $SA_JWT_TOKEN