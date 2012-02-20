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
echo "useJCCPFileChecker [NAME OF FILE CHECK LIST] [PATH OF THE PROGRAMM] [NAME OF THE FLAG LIST] (Optional: [NO REMOVE])"
echo ""
echo "    - File Check Lists have the ending *.lst"
echo "    - Flag Lists have the ending *.flag"
echo "    - leave NO REMOVE only if you want to remove all DBG Files"
echo ""
echo ""
echo "----------------------------------------------------"
exit 1
}
echo "--> read global settings"
tcFolder=`./readTCFolder.sh`
cd ../projects/
pjFolder=$(pwd)
cd -

echo $tcFolder
echo $pjFolder

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
configH="${3%.*}.h"


export outCSV=boa.csv
## Reset output
#echo -n -> "$outCSV"

if [ $noRemove -eq 1 ]; then
echo "--> continue without remove"
else 
#echo "--> remove *.dbg files [START]"
func_filesToProcess|while read i; do
if [ ! -f $srcPath/$i.dbg ]; then
echo "nothing to remove"
 else
     rm $srcPath/$i.dbg
     echo "--> remove $i.dbg [OK]"
 fi
done
fi


export partialPreprocFlags="-x CONFIG_ --include $pjFolder/$configH -I $srcPath/include --writePI --recordTiming"
echo "--> reading flags [START]"
flags=""
while read i; do
    flags="$flags $i"
echo "--> flag $i [OK]"
done < $pjFolder/$flagList
echo "--> reading flags [OK]"
echo "--> using jcpp [START]"
func_filesToProcess|while read i; do
 if [ ! -f $srcPath/$i.dbg ]; then
    touch $srcPath/$i.dbg
    oldPath=$(pwd)
    cd ../jcpp/
	 ./jcpp.sh $srcPath/$i.c $flags
    cd - 
    echo " --> working on file $srcPath/ $i.c [OK]"
 else
    echo "Skipping $srcPath/$i.c"
  fi
done
echo "--> all done [OK]"
