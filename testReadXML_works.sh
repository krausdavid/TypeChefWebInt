#!/bin/bash -e
#!/bin/bash -vxe
echo `cat global_settings.xml | egrep "<tcpath>.*</tcpath>" |sed -e "s/<tcpath>\(.*\)<\/tcpath>/\1/"|tr "|" " "`
