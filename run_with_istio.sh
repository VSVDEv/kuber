#!/bin/sh


kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-crds.yaml


kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-core.yaml




kubectl apply -l knative.dev/crd-install=true -f https://github.com/knative/net-istio/releases/download/knative-v1.17.0/istio.yaml

kubectl apply -f https://github.com/knative/net-istio/releases/download/knative-v1.17.0/istio.yaml


kubectl apply -f https://github.com/knative/net-istio/releases/download/knative-v1.17.0/net-istio.yaml

kubectl --namespace istio-system get service istio-ingressgateway


kubectl get pods -n knative-serving



kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-default-domain.yaml



kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-hpa.yaml



  