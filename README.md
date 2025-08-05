# Kubernetes Production-Grade E-commerce App

## Overview
This project simulates a production-grade e-commerce system deployed on Kubernetes.  
It includes microservices (auth, product, order, frontend), MongoDB database,  
Ingress with SSL, autoscaling, logging, monitoring, CI/CD, and disaster recovery.

## Architecture
- **Frontend**: React/Angular
- **Backend Services**: Auth, Product, Order (Helm charts)
- **Database**: MongoDB StatefulSet
- **Ingress**: NGINX + Cert-Manager (Let's Encrypt)
- **Monitoring**: Prometheus + Grafana
- **Logging**: EFK Stack (Elasticsearch, Fluentd, Kibana)
- **CI/CD**: Jenkins pipeline with Helm deployments

![Architecture Diagram](docs/architecture.png)

## Folder Structure



## 🏗️ Kubernetes Architecture Diagram

```mermaid
graph TD
    subgraph Cluster[Kubernetes Cluster]
        subgraph ControlPlane[Control Plane]
            KubeAPI[Kube API Server]
            ETCD[ETCD Database]
            Scheduler[Scheduler]
            Controller[Controller Manager]
        end

        subgraph Workers[Worker Nodes]
            Worker1[Worker Node 1]
            Worker2[Worker Node 2]
            Worker3[Worker Node 3]
        end
        
        subgraph MongoDB[MongoDB StatefulSet]
            M0[MongoDB Pod 0]
            M1[MongoDB Pod 1]
            M2[MongoDB Pod 2]
        end

        subgraph Microservices
            Auth[Auth Service]
            Product[Product Service]
            Order[Order Service]
            Frontend[Frontend UI]
        end

        subgraph Networking[Networking]
            Ingress[NGINX Ingress Controller]
            Service1[Service Objects]
        end

        subgraph Monitoring[Monitoring]
            Prometheus[Prometheus]
            Grafana[Grafana]
        end

        subgraph Logging[Logging]
            Elasticsearch[Elasticsearch]
            Fluentd[Fluentd]
            Kibana[Kibana]
        end

        subgraph Security[Security]
            CertManager[Cert-Manager]
            NetworkPolicies[Network Policies]
        end

        subgraph CICD[CI/CD]
            Jenkins[Jenkins Pipeline]
        end
    end

    Ingress -->|Routes /auth /products /orders| Auth
    Ingress --> Product
    Ingress --> Order
    Ingress --> Frontend

    Frontend --> Auth
    Frontend --> Product
    Frontend --> Order

    Auth --> MongoDB
    Product --> MongoDB
    Order --> MongoDB

    Monitoring --> Prometheus
    Monitoring --> Grafana
    Logging --> Elasticsearch
    Logging --> Fluentd
    Logging --> Kibana

    Security --> CertManager
    Security --> NetworkPolicies

    CICD --> Jenkins
    Jenkins -->|Helm Deployments| Microservices
