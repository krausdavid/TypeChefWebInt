#!/bin/bash -e
#!/bin/bash -vxe

filesToProcess(){
  folder="fileLists"  
  location=$folder+$1
echo $#
echo $1  
echo $location
}

filesToProcess
