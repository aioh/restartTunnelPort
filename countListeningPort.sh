#!/bin/bash
MAILTO="pnispapr@siammakro.co.th,ssomboon@siammakro.co.th"
cd /root/Scripts/CountListeningPort
netstat -plnt | grep sshd | wc -l  > .count.tmp
count=$(cat .count.tmp)
if [ "$count" == 52 ]
then
        echo "Process Count : $count  No Error Found" | mailx -r itechtool@siammakro.co.th -s "PRDTUNNEL01 PORT LOST" $MAILTO
#       echo "Process Count : $count  No Error Found"
#else . ./runCommand.sh
else  echo "Process Count : $count Someting Wrong!!!" | mailx -r itechtool@siammakro.co.th -s "PRDTUNNEL01 PORT LOST" $MAILTO
fi
