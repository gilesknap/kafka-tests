cd "$(TOP)"

dbLoadDatabase "dbd/ioc.dbd"
ioc_registerRecordDeviceDriver(pdbbase)

# simDetectorConfig(portName, maxSizeX, maxSizeY, dataType, maxBuffers, maxMemory)
simDetectorConfig("PCO.CAM", 2560, 2160, 1, 50, 0)

# NDPvaConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr, pvName, maxMemory, priority, stackSize)
NDPvaConfigure("PCO.PVA", 2, 0, "PCO.CAM", 0, IMAGE01, 0, 0, 0)
startPVAServer

# instantiate Database records
dbLoadRecords (simDetector.template, "P=DEMO-EA-PCO-01, R=:CAM:, PORT=PCO.CAM, TIMEOUT=1, ADDR=0")
dbLoadRecords (NDPva.template, "P=DEMO-EA-PCO-01, R=:PVA:, PORT=PCO.PVA, ADDR=0, TIMEOUT=1, NDARRAY_PORT=PCO.CAM, NDARRAY_ADR=0, ENABLED=1")

# start IOC shell
iocInit

# poke some records
dbpf "DEMO-EA-PCO-01:CAM:AcquirePeriod", "0.1"
