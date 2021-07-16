# Kafka Test IOC and utilities

## Initial setup
First get connected to the argus cluster. This will ask you for your fedID and
password the first time (and occasionally when the cached creds time out).


```
git clone https://github.com/gilesknap/kafka-tests.git
cd kafka-tests

source ./kube-login.sh
```

## Deploy the IOC bl45p-ea-ioc-05

This IOC comes with a sim detector plus kafka, tiff and pva plugins.

To Deploy into your own namespace in the argus Kubernetes cluster:

```
./deploy-bl45p-ea-ioc-05
```
## Check the status of your 'beamline' or list resources

```
# list every resource in the bl45p beamline
k8s-ioc beamline bl45p

# list your ioc's resources
k8s-ioc list bl45p-ea-ioc-05

```


## Modify the IOC

The IOC runs in a container and is entirely defined in its startup script
in iocs/bl45p-ea-ioc-05/config/ioc.boot

Edit this file as required and redeploy with the above command.

You may then need to restart the IOC with:
```
k8s-ioc restart bl45p-ea-ioc-05
```

## Explore the available IOC commands

This command lists all of the k8s-ioc sub commands available

```
k8s-ioc
```

## Get an edm GUI for the IOC

First you need to discover which cluster node IP address the IOC is using:

```

(main) [hgv27681@pc0116 kafka-tests]$ k8s-ioc beamline bl45p
DEPLOYMENT        VERSION    REPLICAS   IMAGE
bl45p-ea-ioc-05   2021.2.0   1          ghcr.io/epics-containers/ioc-adsimdetector:2.10r3.0.run

IOC               VERSION    STATE    RESTARTS   STARTED
bl45p-ea-ioc-05   2021.2.0   <none>   0          2021-07-15T16:20:25Z

configMaps
NAME              DATA   AGE
bl45p-ea-ioc-05   4      27m

Peristent Volume Claims
NAME                   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
bl45p-ea-ioc-05-data   Bound    pvc-dcab2cdf-e1b7-4dac-86b9-a2ebf157bdfe   1000Mi     RWX            local-path     27m

Services
NAME                  TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)          AGE
bl45p-ea-ioc-05-tcp   LoadBalancer   10.99.205.80     172.23.169.18   5064:32176/TCP   27m
bl45p-ea-ioc-05-udp   LoadBalancer   10.111.245.225   172.23.169.18   5064:32007/UDP   27m
```

Note the External-IP address in the services section and then substitute that
into the following command:

```
export EPICS_CA_ADDR_LIST=172.23.169.18
./gui-bl45p-ea-ioc-05
```

## Copy data into the container

First discover the pod name for the container then use `kubectl cp` commmand
as shown below. There is a persistent data store mounted at /data which
will survive upgrades of the IOC (but not helm delete bl45p-ea-ioc-05).

```
(main) [hgv27681@pc0116 kafka-tests]$ k8s-ioc ps -w
IOC                                VERSION    STATE    RESTARTS   STARTED                IP           IMAGE
bl45p-ea-ioc-05-69bb59bff6-bml9v   2021.2.0   <none>   0          2021-07-15T16:20:25Z   10.40.0.17   ghcr.io/epics-containers/ioc-adsimdetector:2.10r3.0.run

# copy the contents of this folder to /data/myFolder
kubectl cp .  bl45p-ea-ioc-05-69bb59bff6-bml9v:/data/myfolder
```

## Contect to the IOC shell

```
# connect to ioc shell
k8s-ioc attach bl45p-ea-ioc-05
```


## Connect to a bash shell and run tests

To connect to a bash shell in the container use this command.

```
k8s-ioc exec bl45p-ea-ioc-05

```

The shell has limited capabilities but includes busybox which has many useful
tools including vi. It is easiest to work outside of the container to work
on test scripts and then use `kubectl cp` to copy your test script in.

Use this command to get access to all busybox commands inside the container
bash shell.

```
busybox sh
help
```

Giles has provided a test script example_tiff_read.sh. However it does not
work yet, the following error is returned when sending to TiffRead

```
BL45P-EA-AND-01:TIFF:WriteMessage Error  file /data/tiffs/example01.tiff, status=3
```

## Run up a kafka client pod

These pods will allow you to configure topics and to run a command line
performance testing consumer or producer

For useful commands see https://github.com/dls-controls/dls-kafka

For consumer:

```
./launch-test-consumer.sh
# this gives you a command promt in the consumer pod - now run
kafka-consumer-perf-test.sh  --bootstrap-server=cs05r-sc-cloud-19:30016 --timeout 60000 --group test-group --topic test3 --messages 100
# and change topic and messages count as needed
```

For producer:
```
./launch-test-producer.sh

kafka-producer-perf-test.sh --producer-props bootstrap.servers=cs05r-sc-cloud-19:30016 max.request.size=200000000 --topic test3 --throughput -1 --num-records 100 --record-size 1443200
# and change topic, num-records and record-size accordingly

```

## Remove all IOC resources including the PVC with your Data

```
k8s-ioc delete bl45p-ea-ioc-01
```
