#!/bin/bash

if ! kubectl get pod kafka-test-producer ; then
    # includes override to avoid arm architecture nodes
    kubectl run kafka-test-producer --restart='Never' --image gcr.io/diamond-privreg/controls/work/tools/kafka-test --namespace controls-kafka --command -- sleep infinity
fi
kubectl wait pod/kafka-test-producer --for condition=ready
kubectl exec -it kafka-test-producer -- bash
