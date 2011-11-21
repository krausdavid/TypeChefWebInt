#!/bin/bash -e
#!/bin/bash -vxe

filesToProcess(){
  folder="fileLists"  
  location="fileLists/$1"
  echo $location
}

filesToProcess
