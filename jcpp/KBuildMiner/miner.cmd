@echo off
mvn scala:run -q -DmainClass=gsd.buildanalysis.linux.KBuildMinerMain -DaddArgs="%1|%2|%3|%4|%5|%6|%7"
rem mvn -e exec:java -Dexec.mainClass=gsd.buildanalysis.linux.KBuildMinerMain -Dexec.args="%1|%2|%3|%4|%5|%6|%7"