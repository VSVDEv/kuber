#!/bin/sh


#-e Exit on Error
#-u Undefined Variable Check
#-o pipefail Pipeline Failure Handling
#set -euo pipefail

echo "\n📦 Installing Knative CRDs..."

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.12.2/serving-crds.yaml

echo "\n📦 Installing Knative Serving..."

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.12.2/serving-core.yaml

echo "\n📦 Installing Kourier Ingress..."

kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.12.1/kourier.yaml

kubectl patch configmap/config-network --namespace knative-serving --type merge --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

echo "\n📦 Configuring DNS..."

#kubectl patch configmap/config-domain --namespace knative-serving --type merge --patch '{"data":{"127.0.0.1.sslip.io":""}}'

#kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.12.2/serving-default-domain.yaml

# No DNS

kubectl patch configmap/config-domain --namespace knative-serving --type merge --patch '{"data":{"example.com":""}}'

echo "\n✅ Knative successfully installed!\n"