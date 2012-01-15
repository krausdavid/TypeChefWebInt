#!/bin/bash -e
#!/bin/bash -vxe
if [ ! $# -eq 1 ]; then
./useJCPPFileChecker-out.sh busybox.lst /app/home/krausdavid/TypeChefWebInt/TypeChefWebInt/projects/busybox-1.18.5 busybox.flags
else 
./useJCPPFileChecker-out.sh busybox.lst /app/home/krausdavid/TypechefWebInt/TypechefWebInt/projects/busybox-1.18.5 busybox.flags 1
fi
