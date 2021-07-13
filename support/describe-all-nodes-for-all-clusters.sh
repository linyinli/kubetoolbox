#/bin/bash
set -e
echo "Rancher RUL is ${RANCHER_URL}"
echo "Rancher API Key is ${RANCHER_TOKEN}"

CLUSTER_ID_LIST=$(
curl -kLSs \
-u "${RANCHER_TOKEN}" \
-X GET \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
${RANCHER_URL}/v3/clusters/ | jq -r .data[].id
)
echo "Cluster ID List: ${CLUSTER_ID_LIST}"

for CLUSTER_ID in ${CLUSTER_ID_LIST};
do

SYSTEM_PROJECT_ID=$(
curl -kLSs \
-u "${RANCHER_TOKEN}" \
-X GET \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
${RANCHER_URL}/v3/clusters/${CLUSTER_ID}/projects?name=System | jq -r ".data[].id"
)

CONFIGMAP_FULL_CLUSTER_STATE=$(
curl -kLSs \
-u "${RANCHER_TOKEN}" \
-X GET \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
${RANCHER_URL}/v3/project/${SYSTEM_PROJECT_ID}/configMaps/kube-system:full-cluster-state | \
jq -r .data.\"full-cluster-state\" | \
jq -r .currentState.certificatesBundle.\"kube-admin\".config
)

SECRETS_KUBE_ADMIN=$(
curl -kLSs \
-u "${RANCHER_TOKEN}" \
-X GET \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
${RANCHER_URL}/v3/project/${SYSTEM_PROJECT_ID}/namespacedSecrets/kube-system:kube-admin | \
jq -r .data.Config
)

if [[ ${CONFIGMAP_FULL_CLUSTER_STATE} != 'null' ]]; then
echo "${CONFIGMAP_FULL_CLUSTER_STATE}" > kube_config_${CLUSTER_ID}.yaml

elif [[ ${SECRETS_KUBE_ADMIN} != 'null' ]]; then
echo "${SECRETS_KUBE_ADMIN}" > kube_config_${CLUSTER_ID}.yaml

else
echo "Without full-cluster-state configMaps or kube-admin Secrets"
fi

# Describe all nodes and save the result to hostPath volume
mkdir -p /rancher-support-healthcheck/$CLUSTER_ID

for node in $(kubectl --kubeconfig=./kube_config_${CLUSTER_ID}.yaml get node -o custom-columns=:.metadata.name);
do
kubectl --kubeconfig=./kube_config_${CLUSTER_ID}.yaml describe node ${node} >/rancher-support-healthcheck/${CLUSTER_ID}/$node;
done

echo "Describe all nodes for ${CLUSTER_ID} cluster and save the result to hostPath volume /rancher-support-healthcheck/${CLUSTER_ID}."
done
echo "Done."
