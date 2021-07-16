#!/bin/bash

if ! kubectl get pod kafka-test-producer ; then
    kubectl run kafka-test-producer --restart='Never' --image docker.io/bitnami/kafka:2.8.0-debian-10-r0 --command -- sleep infinity
    echo "waiting for image to be pulled ..."
fi
kubectl wait pod/kafka-test-producer --for condition=ready --timeout 60s
kubectl exec -it kafka-test-producer -- bash
