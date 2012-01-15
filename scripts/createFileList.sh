#!/bin/bash -e
#!/bin/bash -vxe
fun_toProcess{
	$list="filenumb.temp"
	cat $list
}
chkStr=$1
chkStr > chkStr.temp

cat chkStr.temp | tr "_" "\n" > fileList.temp
rm chkStr.temp

cat fileList.temp | tr "chkbox" "" > filenumb.temp
rm fileList.temp



IFS=$'\n' lines=($(cat ../projekts/busybox.project))

touch fileList.lst

fun_toProcess|while read i; do

done
