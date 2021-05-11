#!/bin/bash

# kubectl create -f database_volume.yml
kubectl create -f ../secret.yml
kubectl create -f ../configmap.yml
kubectl create -f ../daemon-sets/database_ds.yml
kubectl create -f ../daemon-sets/redis_ds.yml
kubectl create -f ../deployment/rails_deployment.yml
kubectl create -f ../services/rails_svc.yml
kubectl create -f ../services/mysql_svc.yml
kubectl create -f ../services/redis_svc.yml
