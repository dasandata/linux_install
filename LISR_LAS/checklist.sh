#!/bin/sh
# Copyright by Dasandata.co.ltd
# http://www.dasandata.co.kr

# LAS 가 정상적으로 작동하였는지 체크
OSCHECK=$(cat /etc/os-release | head -1 | cut -d "=" -f 2 | tr -d "\"" | awk '{print$1}' | tr '[A-Z]' '[a-z]')
VENDOR=$(dmidecode | grep -i manufacturer | awk '{print$2}' | head -1)
# 기본 버전 설치 진행 순서
# nouveau 끄기 및 grub 설정
echo "Nouveau, GRUB Check" >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
cat /root/install_log.txt | grep "CentOS Grub Setting Start" >> /root/CheckList.txt
cat /etc/default/grub | grep LINUX >> /root/CheckList.txt
cat /etc/modprobe.d/blacklist.conf >> /root/CheckList.txt
cat /etc/default/grub | grep "Nouveau and Grub Setting complete" | tee -a /root/install_log.txt
echo "" >> /root/CheckList.txt
echo "Nouveau, GRUB Check Complete" >> /root/CheckList.txt
# selinux 제거 및 저장소 변경
case $OSCHECK in 
    centos )
        echo "" >> /root/CheckList.txt
        echo "SELINUX Repository Check" >> /root/CheckList.txt
        cat /root/install_log.txt | grep "SELINUX is already turned off." >> /root/CheckList.txt
        echo "getenforce" >> /root/CheckList.txt
        getenforce >> /root/CheckList.txt
        cat /etc/selinux/config | grep "^SELINUX=" >> /root/CheckList.txt
        echo "" >> /root/CheckList.txt
        echo "SELINUX Repository Check Complete" >> /root/CheckList.txt
    ;;
    ubuntu )
        echo "" >> /root/CheckList.txt
        echo "Repository Check" >> /root/CheckList.txt
        cat /etc/apt/sources.list | grep -v "#\|^$" | head -3 >> /root/CheckList.txt
        echo "" >> /root/CheckList.txt
        echo "SELINUX Repository Check Complete" >> /root/CheckList.txt
    ;;
    *)
    ;;
esac
# 기본 패키지 설치
echo "" >> /root/CheckList.txt
echo "Pacakage Install Check" >> /root/CheckList.txt
case $OSCHECK in 
    centos )
        uname -r >> /root/CheckList.txt
        rpm -qa | grep htop >> /root/CheckList.txt
        rpm -qa | grep kernel-headers >> /root/CheckList.txt
        rpm -qa | grep kernel-devel >> /root/CheckList.txt

    ;;
    ubuntu )
        uname -r >> /root/CheckList.txt
        dpkg -l | grep htop >> /root/CheckList.txt
        dpkg -l | grep -i linux-headers >> /root/CheckList.txt
    ;;
    *)
    ;;
esac
echo "" >> /root/CheckList.txt
echo "Pacakage Check Complete" >> /root/CheckList.txt

# 프로필 설정
echo "" >> /root/CheckList.txt
echo "Profile Check" >> /root/CheckList.txt
case $OSCHECK in 
    centos )
        sed -n "77,\$p"  /etc/profile >> /root/CheckList.txt
    ;;
    ubuntu )
        sed -n "28,\$p"  /etc/profile >> /root/CheckList.txt
    ;;
    *)
    ;;
esac
echo "" >> /root/CheckList.txt
echo "Profile Check Complete" >> /root/CheckList.txt

# 서버 시간 동기화
echo "" >> /root/CheckList.txt
echo "Time Check" >> /root/CheckList.txt
date >> /root/CheckList.txt
hwclock >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
echo "Time Check Complete" >> /root/CheckList.txt

# 파이썬 설치
echo "" >> /root/CheckList.txt
echo "Python Install Check" >> /root/CheckList.txt
python -V >> /root/CheckList.txt
python3 -V >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
echo "Python Install Check Complete" >> /root/CheckList.txt

# 파이썬 패키지 설치
echo "" >> /root/CheckList.txt
echo "Python Pacakage Install Check" >> /root/CheckList.txt
pip list | grep scipy >> /root/CheckList.txt
pip list | grep nose >> /root/CheckList.txt
pip3 list | grep scipy >> /root/CheckList.txt
pip3 list | grep nose >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
echo "Python Pacakage Check Complete" >> /root/CheckList.txt

# 방화벽 설정
echo "" >> /root/CheckList.txt
echo "Firewall Check" >> /root/CheckList.txt
case $OSCHECK in 
    centos )
        systemctl status firewalld >> /root/CheckList.txt
        firewall-cmd --list-all >> /root/CheckList.txt
    ;;
    ubuntu )
        systemctl status ufw >> /root/CheckList.txt
        ufw status >> /root/CheckList.txt
    ;;
    *)
    ;;
esac
echo "" >> /root/CheckList.txt
echo "Firewall Check Complete" >> /root/CheckList.txt

# 사용자 생성 테스트
echo "" >> /root/CheckList.txt
echo "User Add Check Start" >> /root/CheckList.txt
cat /etc/passwd | grep dasan >> /root/CheckList.txt
cat /etc/shadow | grep dasan >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
echo "User Add Check Complete" >> /root/CheckList.txt

# H/W 사양 체크
echo "" >> /root/CheckList.txt
echo "H/W Check Start" >> /root/CheckList.txt
cat /root/hwcheck.txt >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
echo "H/W Check Complete" >> /root/CheckList.txt

# GPU 존재 여부에 따라 아래 체크리스트 실행
nvidia-smi &> /dev/null
if [ $? != 0 ]
then
    echo "" >> /root/CheckList.txt
    echo "No GPU Check List Complete" >> /root/CheckList.txt
    exit 143
else
    echo "" >> /root/CheckList.txt
    echo "GPU Check List Start" >> /root/CheckList.txt
fi

# CUDA,CUDNN Repo 설치
echo "" >> /root/CheckList.txt
echo "CUDA, CUDNN Repo Check Start" >> /root/CheckList.txt
case $OSCHECK in 
    centos )
        rpm -qa | grep nvidia >> /root/CheckList.txt
        rpm -qa | grep cuda-repo >> /root/CheckList.txt
    ;;
    ubuntu )
        ls /etc/apt/sources.list.d/ >> /root/CheckList.txt
    ;;
    *)
    ;;
esac
echo "" >> /root/CheckList.txt
echo "CUDA, CUDNN Repo Complete" >> /root/CheckList.txt

# CUDA 설치 및 PATH 설정
echo "" >> /root/CheckList.txt
echo "CUDA Install Check Start" >> /root/CheckList.txt
nvidia-smi >> /root/CheckList.txt
nvidia-smi -L >> /root/CheckList.txt
which nvcc >> /root/CheckList.txt
nvcc -V >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
echo "CUDA Check Complete" >> /root/CheckList.txt

# CUDNN 설치 및 PATH 설정
echo "" >> /root/CheckList.txt
echo "CUDNN Install Check Start" >> /root/CheckList.txt
case $OSCHECK in 
    centos )
        rpm -qa | grep libcudnn* >> /root/CheckList.txt
    ;;
    ubuntu )
        dpkg -l | grep libcudnn* >> /root/CheckList.txt
    ;;
    *)
    ;;
esac
echo "" >> /root/CheckList.txt
echo "CUDNN Check Complete" >> /root/CheckList.txt

# 딥러닝 패키지 설치(R,R Server, JupyterHub, Pycharm)
echo "" >> /root/CheckList.txt
echo "Deep Learning Install Check Start" >> /root/CheckList.txt
case $OSCHECK in 
    centos )
        rpm -qa | grep rstudio >> /root/CheckList.txt
        rpm -qa | grep r-base >> /root/CheckList.txt
        systemctl enable jupyterhub.service >> /root/CheckList.txt
    ;;
    ubuntu )
        dpkg -l | grep rstudio >> /root/CheckList.txt
        dpkg -l | grep r-base >> /root/CheckList.txt
        systemctl enable jupyterhub.service >> /root/CheckList.txt
    ;;
    *)
    ;;
esac
echo "" >> /root/CheckList.txt
echo "Deep Learning Check Complete" >> /root/CheckList.txt

# PC, WorkStation은 여기까지 체크 진행
dmidecode | grep -i ipmi &> /dev/null
if [ $? != 0 ]
then
    echo "" >> /root/CheckList.txt
    echo "PC,Workstation Check List Complete" >> /root/CheckList.txt
    exit 218
else
    echo "" >> /root/CheckList.txt
    echo "Server Check List Start" >> /root/CheckList.txt
fi

# MegaRaid Storage Manager 설치
echo "" >> /root/CheckList.txt
echo "MSM Install Check Start" >> /root/CheckList.txt
ls /usr/local/MegaRAID\ Storage\ Manager/ >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
echo "MSM Check Complete" >> /root/CheckList.txt

# Dell Server 체크 진행

if [ $VENDOR != "Dell" ]
then
    echo "" >> /root/CheckList.txt
    echo "$VENDOR Server Check List Complete" >> /root/CheckList.txt
    exit 237
else
    echo "" >> /root/CheckList.txt
    echo "$VENDOR Server Check List Start" >> /root/CheckList.txt
fi

# Mailutils
echo "" >> /root/CheckList.txt
echo "Mailutils Install Check Start" >> /root/CheckList.txt
systemctl status postfix >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
echo "Mailutils Check Complete" >> /root/CheckList.txt

# Dell OMSA 설치
echo "" >> /root/CheckList.txt
echo "OMSA Install Check Start" >> /root/CheckList.txt
systemctl status dataeng >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
echo "OMSA Check Complete" >> /root/CheckList.txt

# 서버 온도 기록 수집
echo "" >> /root/CheckList.txt
echo "Temperature Check Start" >> /root/CheckList.txt
cat /etc/crontab >> /root/CheckList.txt
echo "" >> /root/CheckList.txt
echo "Temperature Check Complete" >> /root/CheckList.txt

echo ""
echo "Check List Complete"
exit 254
