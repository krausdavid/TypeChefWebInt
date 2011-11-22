#!/bin/bash -e
#!/bin/bash -vxe

func_filesToProcess(){
  folder="fileLists"  
  location="fileLists/$args1"
echo $location
}
func_help(){
echo "HELP!!"
}

if [ $# -eq 0 ];
then 
func_help
else
args1=$1
func_filesToProcess
fi
