#!/bin/bash -e
#!/bin/bash -vxe
if [ ! $# -eq 1 ]; then
./useJCPPFileChecker.sh busyboxKomp.lst cprojects/busybox/busybox-1.18.5 busybox.flag
else 
./useJCPPFileChecker.sh busyboxKomp.lst cprojects/busybox/busybox-1.18.5 busybox.flag 1
fi
