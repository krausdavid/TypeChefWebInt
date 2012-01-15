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
echo "####################"
echo "read global settings"
echo "####################"
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


export outCSV=boa.csv
## Reset output
#echo -n -> "$outCSV"

if [ $noRemove -eq 1 ]; then
echo "#######################"
echo "continue without remove"
echo "#######################"
else 
echo "remove *.dbg files [START]"
echo "#######################"
func_filesToProcess|while read i; do
if [ ! -f $srcPath/$i.dbg ]; then
echo "#######################"  
echo "nothing to remove"
echo "#######################"
 else
     rm $srcPath/$i.dbg
     echo "#######################"
     echo "remove $i.dbg [OK]"
    echo "#######################" 
 fi
done
fi


export partialPreprocFlags="-x CONFIG_ --include $tcFolder/busybox/config.h -I $srcPath/include"
echo "#######################"
echo "reading flags [START]"
echo "#######################"
flags=""
while read i; do
    flags="$flags $i"
echo "#######################"
echo "flag $i [OK]"
echo "#######################"
done < $pjFolder/$flagList
echo "#######################"
echo "reading flags [OK]"
echo "using jcpp [START]"
echo "#######################"
func_filesToProcess|while read i; do
echo $i 
 if [ ! -f $srcPath/$i.dbg ]; then
    touch $srcPath/$i.dbg
    oldPath=$(pwd)
    cd ../jcpp/
    ./jcpp.sh $srcPath/$i.c
    cd - 
    echo "#######################"
    echo "working on file $srcPath/ $i.c [OK]"
    echo "#######################"
 else
    echo "Skipping $srcPath/$i.c"
  fi
done
echo "#######################"
echo "all done [OK]"
