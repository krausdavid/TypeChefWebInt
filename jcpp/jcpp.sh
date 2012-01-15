#!/bin/bash -e
#!/bin/bash -vxe
if [ -z "$jcppConfLoaded" ]; then
  source jcpp.conf
fi
typechefDir="/app/archive/kos/share/TypeChef/TypeChef"
# What you should configure
javaOpts='$javaOpts -Xmx2G -Xms128m -Xss10m'

macro_stats_path=macroDebug.txt
debugsource_path=debugsource.txt

# For Java compiled stuff!
basePath=.

#mainClass="org.anarres.cpp.Main"
mainClass="de.fosd.typechef.linux.LinuxPreprocessorFrontend"

# Brute argument parsing
# The right thing to do would be to be a gcc replacement, parse its flags and
# select the ones we care about.
if [ $# -lt 1 ]; then
  echo "Not enough arguments!" >&2
  exit 1
fi
inp=$1
shift

. setupOutPaths.sh.inc


if [ ! -f "$outPreproc" ]; then
  echo "==Preprocess source"
  gcc -Wp,-P -U __weak $gccOpts -E "$inp" "$@" > "$outPreproc" || true
fi

# Beware: the embedded for loop requotes the passed argument. That's dark magic,
# don't ever try to touch it. It simplifies your life as a user of this program
# though!
echo "==TypeChef $inp"

bash -c "time $typechefDir/typechef.sh\
  $(for arg in $partialPreprocFlags "$@"; do echo -n "\"$arg\" "; done) \
  '$inp' 2> '$outErr' |tee '$outDbg'" \
  2> "$outTime" || true


cat "$outErr" 1>&2
