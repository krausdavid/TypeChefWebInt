#!/bin/bash -e
#!/bin/bash -vxe
if [ ! $# -eq 1 ]; then
./useJCPPFileChecker.sh busybox.lst /app/archive/kos/share/TypeChef/busybox/busybox-1.18.5 busybox.flags
else
./useJCPPFileChecker.sh busybox.lst /app/archive/kos/share/TypeChef/busybox/busybox-1.18.5 busybox.flags 1
fi
