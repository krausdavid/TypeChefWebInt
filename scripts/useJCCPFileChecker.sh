#!/bin/bash -e
#!/bin/bash -vxe

func_filesToProcess(){
  local listFile="fileLists/$fileCheckList"
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
echo "useJCCPFileChecker [NAME OF FILE CHECK LIST] [PATH OF THE PROGRAMM OUTGOING FROM THE tcFolder] [NAME OF THE FLAG LIST]"
echo ""
echo "    - File Check Lists have the ending *.lst"
echo "    - Flag Lists have the ending *.flag"
echo ""
echo ""
echo "----------------------------------------------------"
exit 1
}

tcFolder="/app/archive/kos/share/TypeChef"
if [ ! $# -eq 3 ]; then 
	func_help
fi

fileCheckList=$1
flagList=$3
srcPath=$2



export outCSV=boa.csv
## Reset output
#echo -n -> "$outCSV"

echo "remove *.dbg files			[START]"
func_filesToProcess|while read i; do
  rm $tcFolder/$srcPath/$i.dbg
  echo "remove $i.dbg 				[OK]"
done
echo "remove *.dbg files			[OK]"

echo "reading flags				[START]"
flags=""
while read i; do
    flags="$flags $i"
echo "flag $i					[OK]"
done < params/$flagList
echo "reading flags				[OK]"


echo "using jcpp				[START]"
func_filesToProcess|while read i; do
  if [ ! -f $tcFolder/$srcPath/$i.dbg ]; then
    touch $tcFolder/$srcPath/$i.dbg
    oldPath=$(pwd)
    cd $tcFolder
    ./jcpp.sh $srcPath/$i.c
    cd - 
    echo "working on file $srcPath/ $i.c			[OK]"
 else
    echo "Skipping $srcPath/$i.c"
  fi
done

echo "all done					[DONE]"
