@echo off
if not exist w: if not exist u: if not exist s: goto conn
echo "Disconnect shares"
net use u: /delete
net use s: /delete
goto exit

:conn
echo "Connect to shares"
net use u: \\chirfa.mathematik.uni-marburg.de\homes
net use s: \\colombo.mathematik.uni-marburg.de\dfs
:exit