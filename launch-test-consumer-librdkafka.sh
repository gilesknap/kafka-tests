#!/bin/bash

if ! kubectl get pod kafka-test-consumer-lib ; then
    # includes override to avoid arm architecture nodes
    kubectl run kafka-test-consumer-lib --restart='Never' --image gcr.io/diamond-privreg/controls/work/tools/kafka-test --command -- sleep infinity
fi
kubectl wait  pod/kafka-test-consumer-lib --for condition=ready
kubectl exec  -it kafka-test-consumer-lib -- bash