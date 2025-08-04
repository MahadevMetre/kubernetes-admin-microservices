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
