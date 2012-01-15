#!/bin/bash -e
#!/bin/bash -vxe

filesToProcess() {
  local listFile=gitbusybox/filelist
  cat $listFile
  #awk -F: '$1 ~ /.c$/ {print gensub(/\.c$/, "", "", $1)}' < linux_2.6.33.3_pcs.txt
}


flags="-U HAVE_LIBDMALLOC -DCONFIG_FIND -U CONFIG_FEATURE_WGET_LONG_OPTIONS -U ENABLE_NC_110_COMPAT -U CONFIG_EXTRA_COMPAT -D_GNU_SOURCE"
srcPath="gitbusybox"
export partialPreprocFlags="-x CONFIG_ --include gitbusybox/header.h -I $srcPath/include --featureModelFExpr gitbusybox/featureModel --debugInterface --writePI --recordTiming --parserstatistics"
## Reset output
filesToProcess|while read i; do
  if [ ! -f $srcPath/$i.dbg ]; then
    touch $srcPath/$i.dbg
    ./jcpp.sh $srcPath/$i.c $flags
  else
    echo "Skipping $srcPath/$i.c"
  fi
done

