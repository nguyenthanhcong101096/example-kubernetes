#!/bin/bash

kubectl create -f secret.yml
kubectl create -f configmap.yml
kubectl create -f database_volume.yml
kubectl create -f deployment/rails_deployment.yml
kubectl create -f deployment/psql_deployment.yml
kubectl create -f services/rails_svc.yml
kubectl create -f services/psql_svc.yml
