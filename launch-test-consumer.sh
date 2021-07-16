#!/bin/bash

if ! kubectl get pod kafka-test-consumer ; then
    kubectl run kafka-test-consumer --restart='Never' --image docker.io/bitnami/kafka:2.8.0-debian-10-r0 --command -- sleep infinity
    echo "waiting for image to be pulled ..."
fi
kubectl wait pod/kafka-test-consumer --for condition=ready --timeout 60s
kubectl exec -it kafka-test-consumer -- bash

