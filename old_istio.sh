#!/bin/sh


#-e Exit on Error
#-u Undefined Variable Check
#-o pipefail Pipeline Failure Handling
#set -euo pipefail

echo "\n📦 Installing Knative CRDs..."

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.12.2/serving-crds.yaml

echo "\n📦 Installing Knative Serving..."

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.12.2/serving-core.yaml

echo "\n📦 Installing IStio Ingress..."

#kubectl apply --filename https://github.com/knative/net-istio/releases/download/v0.16.0/release.yaml

kubectl apply -l knative.dev/crd-install=true -f https://github.com/knative/net-istio/releases/download/knative-v1.15.1/istio.yaml
kubectl apply -f https://github.com/knative/net-istio/releases/download/knative-v1.15.1/istio.yaml

kubectl apply -f https://github.com/knative/net-istio/releases/download/knative-v1.15.1/net-istio.yaml

kubectl --namespace istio-system get service istio-ingressgateway


echo "\n📦 Configuring DNS..."

#Magic DNS

#kubectl patch configmap/config-domain --namespace knative-serving --type merge --patch '{"data":{"127.0.0.1.sslip.io":""}}'

#kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.12.2/serving-default-domain.yaml


# No DNS

kubectl patch configmap/config-domain --namespace knative-serving --type merge --patch '{"data":{"example.com":""}}'

#kubectl get ksvc


#NAME            URL                                        LATESTCREATED         LATESTREADY           READY   REASON
#helloworld-go   http://helloworld-go.default.example.com   helloworld-go-vqjlf   helloworld-go-vqjlf   True

#curl -H "Host: helloworld-go.default.example.com" http://192.168.39.228:32198

echo "\n✅ Knative successfully installed!\n"