#!/bin/sh


kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-crds.yaml


kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-core.yaml


kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.17.0/kourier.yaml


kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'


 kubectl --namespace kourier-system get service kourier


  kubectl get pods -n knative-serving



  kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-default-domain.yaml



  kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-hpa.yaml



  