#!/bin/bash -e
#!/bin/bash -vxe
echo `cat ../global_settings.xml | egrep "<typechef path=\".*\" />" |sed -e "s/<typechef path=\"\(.*\)\" \/>/\1/"|tr "|" " "`
