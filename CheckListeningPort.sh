#/bin/bash
cd /root/Scripts/CheckListeningPort
MAILTO="someemail@someaddress.com"
LINEAPIKEY=YOUR_LINE_API_TOKEN
netstat -plnt | grep  "0 :::" | grep sshd | awk '{print ""$4 " "$7" "}' | sed 's/.*://' | sed 's/\/sshd//' | awk  '{print $1}' | sort -n | sed '1d' > out/.output
cd out
result=$(diff --changed-group-format="%>%<" --unchanged-group-format='' Portlist.txt .output)
diff --changed-group-format='%<%>' --unchanged-group-format='' Portlist.txt .output &> .Result.txt
## diff .output Portlist.txt.bak | grep -e ">" -e "<"
count=$(cat .Result.txt | wc -l)
echo $count > .result2.txt
if [[ $count -gt "0" ]];then
        echo "Port Lost :  "$result" Please Check Tunnel"  > .msgError.txt
        txt=$(cat .msgError.txt)
        curl -X POST -H 'Authorization: Bearer '"$LINEAPIKEY"'' -F message=''"$txt"'' https://notify-api.line.me/api/notify --insecure
        echo $txt | mailx -r SOMEEMAIL@SOMEADDRESS.COM -s "ERROR!!! PRDTUNNEL01 PORT Check" $MAILTO
                        elif [[ $count == "0" ]]; then
echo "No error found from Port List Checked." > .msgNoError.txt
echo "No Error found from Port List Checked." | mailx -r SOMEEMAIL@SOMEADDRESS.COM -s "PRDTUNNEL01 PORT Check" $MAILTO
                        else
echo "unexpected error found" | mailx -r SOMEEMAIL@SOMEADDRESS.COM -s "PRDTUNNEL01 PORT LOST" $MAILTO
fi
rm .msgNoError.txt .output .result2.txt .Result.txt
#rm Result.txt
