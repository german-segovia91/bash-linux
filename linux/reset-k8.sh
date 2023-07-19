#!/bin/bash
kubectl delete -f estres-deployment.yml;sleep 30
kubectl delete -f weave-daemonset-k8s.yaml;sleep 30
systemctl restart kubelet.service;sleep 30
kubectl apply -f weave-daemonset-k8s.yaml;sleep 30
kubectl apply -f estres-deployment.yml
echo -e 'Se completo el proceso'