
caput -c BL45P-EA-AND-01:TIFF:FileNumber 1
caput -cS BL45P-EA-AND-01:TIFF:FileName "example"
caput -cS BL45P-EA-AND-01:TIFF:FilePath "/data/tiffs"
caput -cS BL45P-EA-AND-01:TIFF:FileTemplate "%s%s%02d.tiff"
caput -c BL45P-EA-AND-01:TIFF:AutoIncrement Yes

for i in {01..03}; do
    caput -cw 10 BL45P-EA-AND-01:TIFF:ReadFile 1
done