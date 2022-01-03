#!/bin/sh
cd /home/webalbum/work/autoTransFromCamera

date=`date "+%Y%m%d_%H%M%S"`

stdbuf -oL -eL nohup ./autoGetPic_7DMarkII.sh 1> /tmp/log.autoGetPic.log.7dmarkII.txt.$date 2>&1 &
stdbuf -oL -eL nohup ./autoGetPic_EOSR.sh     1> /tmp/log.autoGetPic.log.EOSR.txt.$date     2>&1 &
stdbuf -oL -eL nohup ./autoGetPic_SX730HS.sh  1> /tmp/log.autoGetPic.log.SX730.txt.$date    2>&1 &


