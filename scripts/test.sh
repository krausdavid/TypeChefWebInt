#!/bin/bash -e
#!/bin/bash -vxe

func_flagsToProcess(){
   local listFile=params/flags_ex.flags
   cat $listFile
   #awk -F: '$1 ~ /.c$/ {print gensub(/\.c$/, "", "", $1)}' < linux_2.6.33.3_pcs.txt
}

out=""
func_flagsToProcess|while read i; do
    out="$out $i";
done;

echo ""
echo ""
echo "FINISHED"

echo "$test <--END"
echo "WHY NOT???"
