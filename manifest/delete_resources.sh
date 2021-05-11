#!/bin/bash

kubectl delete svc --all
kubectl delete deploy --all
kubectl delete ds --all
kubectl delete secret --all
kubectl delete configMap --all
kubectl delete pvc --all
kubectl delete pv --all
