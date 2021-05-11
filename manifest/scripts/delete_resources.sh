#!/bin/bash

kubectl delete svc --all -n k8s
kubectl delete deploy --all -n k8s
kubectl delete ds --all -n k8s
kubectl delete job --all -n k8s
kubectl delete secret --all -n k8s
kubectl delete configMap --all -n k8s
kubectl delete pvc --all -n k8s
kubectl delete pv --all -n k8s
