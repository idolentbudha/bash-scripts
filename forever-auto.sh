#!/bin/bash

#Description:
#This script looks for frontend-start and backend-start process ran by forever and stops all of them
#It then looks for ports 3001 and 3002, and kills them 

#for forever
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White

clear

echo -e "################################################# ${txtgrn}Working on frontend-start process${txtwht} ##############################"
echo ""
forever_list=$(forever list)
echo -e "$forever_list"

fcount=$(forever list | grep frontend-start | wc -l)


if [ $fcount -eq 0 ];then
        echo -e "${txtred} No frontend-start process${txtwht}"
else
        echo "Processing frontend-process"
        frontids=$(forever list | grep frontend-start | awk '{print $2}')
        #FOREVER_ID=${frontid:1:-1}
        #echo -e "${txtgrn}Stopping Forever Id: $FOREVER_ID ${txtwht} "


        for i in $frontids;do
                id=${i:1:-1}
                echo -e "ID: ${txtred}$id"
                echo -e "${txtgrn}Stopping Forever Id: ${txtred}$id ${txtwht} "
                $(forever stop $id)
        done
fi

echo ""
echo -e "################################################# ${txtgrn}Working on backend-start process${txtwht} ##############################"
echo ""
forever_list=$(forever list)
echo -e "$forever_list"

bcount=$(forever list | grep backend-start | wc -l)

if [ $bcount -eq 0 ];then
        echo -e "${txtred} No backend-start process${txtwht}"
else
        echo -e "${txtgrn}Processing backendend-process:${txtwht}"
        backendids=$(forever list | grep backend-start | awk '{print $2}')

        echo -e "${txtgrn}Total backend-start process:${txtred}$bcount${txtwht}"
        for j in $backendids;do
                id=${j:1:-1}
                echo -e "ID: ${txtred}$id"
                echo -e "${txtgrn}Stopping Forever Id: ${txtred}$id ${txtwht} " 
                $(forever stop $id)
        done
fi
echo ""
echo -e "################################################# ${txtgrn}Working for Port${txtwht} ##############################"
echo ""
PORT1=3001
PORT2=3002

lsof -n -i -P | grep LISTEN


p1count=$(lsof -n -i -P | grep LISTEN | grep *:$PORT1 |wc -l)
echo "Port[$PORT1] count: $p1count";
p2count=$(lsof -n -i -P | grep LISTEN | grep *:$PORT2 |wc -l)
echo "Port[$PORT2] count: $p2count"

if [ $p1count -eq 0 ] && [ $p2count -eq 0 ];then
        echo -e "${txtgrn}No $PORT1 and $PORT2 ports open${txtwht}"
else
        if [ $p1count -gt 0 ];then
                echo -e "${txtgrn}Preparing on Stopping Port:$PORT1 ${txtwht}"
                ss -lptn "sport = :$PORT1"
                for i in $(ss -lptn "sport = :$PORT1");do
                        #echo $i
                        if [[ "$i" =~ "pid=" ]];then
                                echo $i
                                stra=${i#*pid=}
                                echo $stra
                                portnum=${stra%,*}
                                echo -e "${txtgrn}Stopping PID: ${txtred}$portnum${txtwht}"
                                kill -9 $portnum
                        fi
                done
        fi

        if [ $p2count -gt 0 ];then
                echo -e "${txtgrn}Preparing on Stopping Port:$PORT2 ${txtwht}"
                ss -lptn "sport = :$PORT2"
                for i in $(ss -lptn "sport = :$PORT2");do
                        #echo $i
                        if [[ "$i" =~ "pid=" ]];then
                                echo $i
                                stra=${i#*pid=}
                                echo $stra
                                portnum=${stra%,*}
                                echo -e "${txtgrn}Stopping PID: ${txtred}$portnum${txtwht}"
                                kill -9 $portnum
                        fi
                done
        fi



        echo -e "${txtgrn}Stopping Forever processes and ports.${txtwht}"
        echo -e "${txtgrn}Done.${txtwht}"

        echo -e  "${txtred}PLEASE CHECK PORTS ARE CLOSED!!!!${txtwht}"

        lsof -n -i -P | grep LISTEN


        p1count=$(lsof -n -i -P | grep LISTEN | grep *:$PORT1 |wc -l)
        echo "Port[$PORT1] count: $p1count";
        p2count=$(lsof -n -i -P | grep LISTEN | grep *:$PORT2 |wc -l)
        echo "Port[$PORT2] count: $p2count"
fi


echo -e "${txtgrn}**THANK YOU**${txtwht}"

