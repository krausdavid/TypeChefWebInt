#!/bin/bash -e
#!/bin/bash -vxe

func_filesToProcess(){
  folder="fileLists"
  local listFile="fileLists/$args1"
  cat $listFile

  #awk -F: '$1 ~ /.c$/ {print gensub(/\.c$/, "", "", $1)}' < linux_2.6.33.3_pcs.txt
}
func_help(){
echo "HELP!!"
}
tcFolder="/app/archive/kos/share/TypeChef"
if [ ! $# -eq 2 ]; then 
	func_help
	exit 1
fi

args1=$1
srcPath=$2


export outCSV=boa.csv
## Reset output
#echo -n -> "$outCSV"

func_filesToProcess|while read i; do
  rm $tcFolder/$srcPath/$i.dbg
done

func_filesToProcess|while read i; do
  if [ ! -f $tcFolder/$srcPath/$i.dbg ]; then
    touch $tcFolder/$srcPath/$i.dbg
    oldPath=$(pwd)
    cd $tcFolder
    ./jcpp.sh $srcPath/$i.c
    cd - 
 else
    echo "Skipping $srcPath/$i.c"
  fi
done
