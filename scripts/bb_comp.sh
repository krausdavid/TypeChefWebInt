#!/bin/bash -e
#!/bin/bash -vxe
if [ ! $# -eq 1 ]; then
./useJCCPFileChecker.sh busyboxKomp.lst cprojects/busybox/busybox-1.18.5 busybox.flag
else 
./useJCCPFileChecker.sh busyboxKomp.lst cprojects/busybox/busybox-1.18.5 busybox.flag 1
fi
