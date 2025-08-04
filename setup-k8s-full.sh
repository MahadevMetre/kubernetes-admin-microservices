#!/bin/bash

set -e

CLUSTER_NAME="ecommerce-cluster"
HELM_CHARTS_DIR="./helm-charts"

echo "🔄 Deleting old cluster (if exists)..."
kind delete cluster --name $CLUSTER_NAME || true

echo "🚀 Creating new KIND cluster with port mappings..."
cat <<EOF | kind create cluster --name $CLUSTER_NAME --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF

echo "✅ Cluster created. Nodes:"
kubectl get nodes

echo "📥 Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "⏳ Waiting for Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

echo "✅ Ingress Controller is ready."

echo "🛠️ Deploying MongoDB StatefulSet..."
kubectl apply -f mongodb/pv-pvc.yaml
kubectl apply -f mongodb/statefulset.yaml
kubectl apply -f mongodb/service.yaml

echo "⏳ Waiting for MongoDB pods..."
kubectl wait --for=condition=ready pod -l app=mongodb --timeout=180s

echo "📦 Deploying Helm microservices..."
helm upgrade --install auth-service "$HELM_CHARTS_DIR/auth-service"
helm upgrade --install product-service "$HELM_CHARTS_DIR/product-service"
helm upgrade --install order-service "$HELM_CHARTS_DIR/order-service"
helm upgrade --install frontend "$HELM_CHARTS_DIR/frontend"

echo "⏳ Waiting for all microservice pods..."
kubectl wait --for=condition=ready pod -l app=auth-service --timeout=180s
kubectl wait --for=condition=ready pod -l app=product-service --timeout=180s
kubectl wait --for=condition=ready pod -l app=order-service --timeout=180s
kubectl wait --for=condition=ready pod -l app=frontend --timeout=180s

echo "📝 Creating Ingress rules for frontend and services..."
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ecommerce-ingress
  namespace: default
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: ecommerce.local
    http:
      paths:
      - path: /auth
        pathType: Prefix
        backend:
          service:
            name: auth-service
            port:
              number: 80
      - path: /products
        pathType: Prefix
        backend:
          service:
            name: product-service
            port:
              number: 80
      - path: /orders
        pathType: Prefix
        backend:
          service:
            name: order-service
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend
            port:
              number: 80
EOF

echo "✅ Ingress created:"
kubectl get ingress

echo "🖊️ Adding hostname to /etc/hosts..."
if ! grep -q "ecommerce.local" /etc/hosts; then
    echo "127.0.0.1 ecommerce.local" | sudo tee -a /etc/hosts
fi

echo "🎉 Setup complete!"
echo "👉 Access your app via: http://ecommerce.local"
