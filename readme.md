# Knative K8s


## Run K8s using docker desktop

https://www.docker.com/blog/how-kubernetes-works-under-the-hood-with-docker-desktop/

https://docs.docker.com/desktop/features/kubernetes/

https://www.docker.com/blog/how-to-set-up-a-kubernetes-cluster-on-docker-desktop/

Docker Desktop -> Configuration -> Kubernetes -> turn on kubernetes -> Apply & restart


kubectl apply -f tutorial.yaml

kubectl get svc

kubectl delete -f tutorial.yaml


### for minikube


minikube start --cpus=2 --memory=8gb --disk-size=2gb

minikube image load vsvdevua/knative:0.0.1  load from local docker

kubectl create deployment vsvdev --image=vsvdevua/knative:0.0.1

kubectl expose deployment vsvdev --type=NodePort --port=9000

kubectl port-forward service/vsvdev 7080:9000

http://localhost:7080/allOrders



kubectl expose deployment vsvdev --type=LoadBalancer --port=9000

minikube tunnel

http://localhost:9000/allOrders

## Install knative

```shell

#!/bin/sh


#-e Exit on Error
#-u Undefined Variable Check
#-o pipefail Pipeline Failure Handling
set -euo pipefail

echo "\n📦 Installing Knative CRDs..."

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.12.2/serving-crds.yaml

echo "\n📦 Installing Knative Serving..."

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.12.2/serving-core.yaml

echo "\n📦 Installing Kourier Ingress..."

kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.12.1/kourier.yaml

kubectl patch configmap/config-network --namespace knative-serving --type merge --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

echo "\n📦 Configuring DNS..."

kubectl patch configmap/config-domain --namespace knative-serving --type merge --patch '{"data":{"127.0.0.1.sslip.io":""}}'

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.12.2/serving-default-domain.yaml

echo "\n✅ Knative successfully installed!\n"
```


## Run minikube and destroy

### Run

```shell
#!/bin/sh

echo "\n📦 Initializing Kubernetes cluster...\n"

minikube start --cpus=2 --memory=4g --driver=docker

minikube start --cpus 2 --memory 4g --driver docker --profile knative

echo "\n🔌 Enabling NGINX Ingress Controller...\n"

minikube addons enable ingress --profile knative

sleep 30

echo "\n📦 Deploying Polar UI..."

kubectl apply -f services/knative-ui.yml

sleep 5

echo "\n⌛ Waiting for Polar UI to be deployed..."

while [ $(kubectl get pod -l app=knative-ui | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for Polar UI to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=app=polar-ui \
  --timeout=180s

echo "\n⛵ Happy Sailing!\n"

```

### Destroy

```shell
#!/bin/sh

echo "\n🏴️ Destroying Kubernetes cluster...\n"

minikube stop --profile knative

minikube delete --profile knative

echo "\n🏴️ Cluster destroyed\n"


```


## Knative

### Commands

kn service create orders-function --image vsvdevua/knative:0.0.1 --port 9000

answear `is available at URL:` copy and use url (http://orders-function.default.127.0.0.1.sslip.io)

!!!NOTE IF USE MINIKUBE!!!
The first time you run this command, you might be asked to input your machine password to
authorize the tunneling to the cluster:

 minikube tunnel --profile knative



Delete

kn service delete orders-function


### Manifest

```yaml

apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: orders-function
spec:
  template:
    spec:
      containers:
        - name: orders-function
          image: vsvdevua/knative:0.0.1
          ports:
            - containerPort: 9000
          resources:
            requests:
              cpu: '0.1'
              memory: '128Mi'
            limits:
              cpu: '2'
              memory: '512Mi'
```

`kubectl apply -f services/kservice.yml`

kubectl get ksvc


Knative takes care of scaling the application without any further configuration. For
each request, it determines whether more instances are required. When an instance
stays idle for a specific time period (30 seconds, by default), Knative will shut it down.
If no request is received for more than 30 seconds, Knative will scale the application to
zero, meaning there will be no instances of Quote Function running.
When a new request is eventually received, Knative starts a new instance and uses it
to handle the request. 

### Scaling to zero prevention

We could use the autoscaling.knative.dev/minScale annotation to mark the applications we don’t want to be scaled to zero:


```yaml

apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: orders-function
annotations:
  autoscaling.knative.dev/minScale: "1"
spec:
  template:
    spec:
      containers:
        - name: orders-function
          image: vsvdevua/knative:0.0.1
          ports:
            - containerPort: 9000
          resources:
            requests:
              cpu: '0.1'
              memory: '128Mi'
            limits:
              cpu: '2'
              memory: '512Mi'
```

choco install httpie

https httpie.io/hello

http http://orders-function.default.127.0.0.1.sslip.io:9000/allOrders





kubectl delete pods --all





kubectl patch configmap/config-network --namespace knative-serving --type merge --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'



## Run angular and backend


### Doker

Normal app: vsvdevua/k8angular-app:1


Knative app: vsvdevua/kangular-app:1


vsvdevua/knative:0.0.1

vsvdevua/knative:1.0.0

vsvdevua/knative-dynamo:0.0.1

vsvdevua/knative-dynamo:1.0.0

docker run --rm -p 9000:9000 vsvdev/knative:0.0.1



minikube delete --all

minikube profile list

minikube start --cpus=2 --memory=6gb --disk-size=2gb

docker tag knative:0.0.1 vsvdevua/knative:0.0.1

minikube image load vsvdevua/knative:0.0.1

clone

git clone https://github.com/vsvdevua/aws.git

cd aws

git checkout knative_test

npm install

ng build --configuration=development

docker build -t kangular-app:1 .

//docker run -p 8080:80 kangular-app:1

docker tag kangular-app:1 vsvdevua/kangular-app:1

minikube image load vsvdev/kangular-app:1

minikube ssh -- docker images

cd ..

kubectl apply -f services/kconf.yml

kubectl apply -f services/back.yml



kubectl apply -f services/knative-ui.yml

kubectl get svc knative-service -o jsonpath='{.metadata.name}.{.metadata.namespace}.svc.cluster.local'


minikube tunnel


kubectl port-forward service/knative-service 7080:9000

kubectl port-forward service/kangular-app-service 7080:80


kubectl delete svc service/kangular-app-service


docker login

docker push vsvdevua/kangular-app:1

docker push vsvdevua/knative:0.0.1