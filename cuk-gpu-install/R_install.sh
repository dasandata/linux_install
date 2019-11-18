#!/bin/bash

PROMPT="[${USER}@${HOSTNAME%%.*}]#"



echo " R server install "

echo ""
echo ""
echo -e  "${PROMPT} apt-get install -y  r-base " >> /root/dasan_install_log.txt
apt-get install -y  r-base  >> /root/log.txt

echo ""
echo ""
echo -e  "${PROMPT} apt-get install -y  gdebi-core " >> /root/dasan_install_log.txt
apt-get install -y  gdebi-core  >> /root/log.txt

echo ""
echo ""
echo -e  "${PROMPT} wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.5019-amd64.deb " >> /root/dasan_install_log.txt
wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.5019-amd64.deb  >> /root/log.txt

echo ""
echo ""
echo -e  "${PROMPT} yes | gdebi rstudio-server-1.2.5019-amd64.deb  " >> /root/dasan_install_log.txt
yes | gdebi rstudio-server-1.2.5019-amd64.deb   >> /root/log.txt

echo ""
echo ""

echo " R desktop install "

echo ""
echo ""
echo -e  "${PROMPT} wget https://download1.rstudio.org/desktop/xenial/amd64/rstudio-1.2.5019-amd64.deb " >> /root/dasan_install_log.txt
wget https://download1.rstudio.org/desktop/xenial/amd64/rstudio-1.2.5019-amd64.deb  >> /root/log.txt

echo ""
echo ""
echo -e  "${PROMPT} dpkg -i rstudio-1.2.5019-amd64.deb " >> /root/dasan_install_log.txt
dpkg -i rstudio-1.2.5019-amd64.deb  >> /root/log.txt

echo ""
echo ""
echo -e  "${PROMPT} apt-get install -y  rdesktop  " >> /root/dasan_install_log.txt
apt-get install -y  rdesktop   >> /root/log.txt
