#!/bin/bash -e
#!/bin/bash -vxe
if [ ! $# -eq 1 ]; then
./useJCPPFileChecker.sh busybox /app/home/krausdavid/TypeChefWebInt/TypeChefWebInt/projects/busybox-1.18.5
else 
./useJCPPFileChecker.sh busybox /app/home/krausdavid/TypechefWebInt/TypechefWebInt/projects/busybox-1.18.5 1
fi
