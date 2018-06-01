 #!/usr/bin/env bash

 gdalinfo FLDAS_NOAH01_A_EA_D.A20010201.001.nc | sed -nE 's/SUBDATASET_.{1,2}_NAME=(.*)/\1/p' | grep -o 'N.*'