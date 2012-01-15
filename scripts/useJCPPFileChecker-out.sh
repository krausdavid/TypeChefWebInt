#!/bin/bash -e
#!/bin/bash -vxe

func_filesToProcess(){
   listFile="$pjFolder/$fileCheckList"
   cat $listFile

  #awk -F: '$1 ~ /.c$/ {print gensub(/\.c$/, "", "", $1)}' < linux_2.6.33.3_pcs.txt
}
func_help(){
echo ""
echo "---------------MAN for useJCCPFileChecker-----------"
echo ""
echo ""
echo "useJCCPFileChecker is a script for using the TypeChef Programm including some extras"
echo ""
echo "useJCCPFileChecker [NAME OF FILE CHECK LIST] [PATH OF THE PROGRAMM] [NAME OF THE FLAG LIST]"
echo ""
echo "    - File Check Lists have the ending *.lst"
echo "    - Flag Lists have the ending *.flag"
echo ""
echo ""
echo "----------------------------------------------------"
exit 1
}
tcFolder=`./readTCFolder.sh`
cd ../projects/
pjFolder=$(pwd)
cd -
if [ ! $# -eq 4 ]; then 
  if [ ! $# -eq 3 ]; then	
    func_help
  else
    noRemove=0
  fi
else
  noRemove=$4
fi


fileCheckList=$1
srcPath=$2
flagList=$3


export outCSV=boa.csv
## Reset output
#echo -n -> "$outCSV"

if [ $noRemove -eq 1 ]; then
echo "No Remove"
else 
func_filesToProcess|while read i; do
if [ ! -f $srcPath/$i.dbg ]; then
echo "Nothing zu Remove" 
else
     rm $srcPath/$i.dbg
 fi
done
fi


export partialPreprocFlags="-x CONFIG_ --include $tcFolder/busybox/config.h -I $srcPath/include"
flags=""
while read i; do
    flags="$flags $i"
done < $pjFolder/$flagList
func_filesToProcess|while read i; do
 if [ ! -f $srcPath/$i.dbg ]; then
    touch $srcPath/$i.dbg
    oldPath=$(pwd)
    cd ../jcpp/
    ./jcpp.sh $srcPath/$i.c
    cd - 
 else
    echo "Skipping $srcPath/$i.c"
  fi
done
