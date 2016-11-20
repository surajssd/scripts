#######################################################
# on master

sudo -i
cd /etc/kubernetes/addons/
mkdir registry
cd registry

cat > rc.yaml <<EOF
apiVersion: v1
kind: ReplicationController
metadata:
  name: kube-registry-v0
  namespace: kube-system
  labels:
    k8s-app: kube-registry
    version: v0
    kubernetes.io/cluster-service: "true"
spec:
  replicas: 1
  selector:
    k8s-app: kube-registry
    version: v0
  template:
    metadata:
      labels:
        k8s-app: kube-registry
        version: v0
        kubernetes.io/cluster-service: "true"
    spec:
      containers:
      - name: registry
        image: registry:2
        resources:
          limits:
            cpu: 100m
            memory: 100Mi
        env:
        - name: REGISTRY_HTTP_ADDR
          value: :5000
        - name: REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY
          value: /var/lib/registry
        volumeMounts:
        - name: image-store
          mountPath: /var/lib/registry
        ports:
        - containerPort: 5000
          name: registry
          protocol: TCP
      volumes:
      - name: image-store
        emptyDir: {}
EOF

cat > svc.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: kube-registry
  namespace: kube-system
  labels:
    k8s-app: kube-registry
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "KubeRegistry"
spec:
  selector:
    k8s-app: kube-registry
  ports:
  - name: registry
    port: 5000
    protocol: TCP

EOF

#######################################################
# from host machine where kubectl can be used

cat > registry-proxy.yaml <<EOF
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: kube-registry-proxy
  namespace: kube-system
spec:
  template:
    metadata:
      labels:
        k8s-app: kube-registry
        kubernetes.io/name: "kube-registry-proxy"
    spec:
      containers:
      - name: kube-registry-proxy
        image: gcr.io/google_containers/kube-registry-proxy:0.3
        resources:
          limits:
            cpu: 100m
            memory: 50Mi
        env:
        - name: REGISTRY_HOST
          value: kube-registry.kube-system.svc.cluster.local
        - name: REGISTRY_PORT
          value: "5000"
        - name: FORWARD_PORT
          value: "5000"
        ports:
        - name: registry
          containerPort: 5000
          hostPort: 5000
EOF

kubectl create -f registry-proxy.yaml

####################################

POD=$(kubectl get pods --namespace kube-system -l k8s-app=kube-registry \
            -o template --template '{{range .items}}{{.metadata.name}} {{.status.phase}}{{"\n"}}{{end}}' \
            | grep Running | head -1 | cut -f1 -d' ')

kubectl port-forward --namespace kube-system $POD 5000:5000 &

######################################################

# build image and then tag it as
# docker tag <built Image name> localhost:5000/vagrant/<build image name>
# docker push localhost:5000/vagrant/<build image name>

