if [ -z "$inp" ]; then
  echo "inp not defined!" >&2
  exit 1
fi

outBase="$(dirname $inp)/$(basename $inp .c)"

# Setup derived output paths
outDbg="$outBase.dbg"
outPartialPreproc="$outBase.pi"
outPreproc="$outBase.i"
outPartialPreprocThenPreproc="$outBase.pi.i"
# Interesting outputs
outErr="$outBase.err"
outTime="$outBase.time"
outDiff="$outBase.diffs"

# vim: set ft=sh:
