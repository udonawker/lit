#!/bin/bash

/bin/bash -c "while true; do date >> [logname].log; [command] >> [logname].log; sleep 1; done" &
PID=$(echo $!)


echo "****************************************************"
echo "*** Press the enter key to stop log acquisition. ***"
echo "****************************************************"
read WAIT

/bin/kill $PID

