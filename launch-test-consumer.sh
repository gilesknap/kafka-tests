#!/bin/bash

if ! kubectl get pod kafka-test-consumer ; then
    # includes override to avoid arm architecture nodes
    kubectl run kafka-test-consumer --restart='Never' --image gcr.io/diamond-privreg/controls/work/tools/kafka-test --namespace controls-kafka --command -- sleep infinity
fi
kubectl wait pod/kafka-test-consumer --for condition=ready
kubectl exec -it kafka-test-consumer -- bash
