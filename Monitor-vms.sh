#/bin/sh
# Author : Vo Trung Huy
# Running shell : "VBoxManage metrics setup" to get metrics Monitor Virtualbox after run script 

vboxmanage list runningvms > listvm.txt
while read data
do
hostname=`hostname`
#echo $hostname
vm=`echo $data | awk -F ['"'] '{print $2}'`
x=`VBoxManage list runningvms | wc -l`
vmrunning=`echo $x`
y=`VBoxManage showvminfo $vm | grep -F "Memory size" | awk -F '[ ]' '{print $7}'`
TotalRAM=`echo "${y//MB}"`
TotalCoreCPU=`VBoxManage showvminfo $vm | grep -F "Number of CPUs" | awk -F '[ ]' '{print $5}'`
CpuUser1=`VBoxManage metrics query $vm| tr -s ' ' | grep -F CPU/Load/User | awk -F '[ ]' '{print $3}' | head -1`
CpuKernel1=`VBoxManage metrics query $vm| tr -s ' ' | grep -F CPU/Load/Kernel | awk -F '[ ]' '{print $3}' | head -1`
x=`VBoxManage metrics query $vm| tr -s ' ' | grep -F RAM/Usage/Used | awk -F '[ ]' '{print $3}' | head -1`
RamUsed=`expr $x / 1000`
DiskUsed=`VBoxManage metrics query $vm| tr -s ' ' | grep -F Disk/Usage/Used | awk -F '[ ]' '{print $3}' | head -1`
NetRX=`VBoxManage metrics query $vm| tr -s ' ' | grep -F Net/Rate/Rx | awk -F '[ ]' '{print $3}' | head -1`
NetTX=`VBoxManage metrics query $vm| tr -s ' ' | grep -F Net/Rate/Tx | awk -F '[ ]' '{print $3}' | head -1`
TotalDisk=`vboxmanage list hdds | grep -A 7 $vm | grep Capacity | awk -F '[ ]' '{print $8}'`
echo "Information of " $vm :
CpuUser=`echo ${CpuUser1//%}`
CpuKernel=`echo ${CpuKernel1//%}`
echo "Ten VM:" $vm
echo "Total vm running :"$vmrunning
echo "Total Ram :"$TotalRAM
echo "Total CPU :"$TotalCoreCPU
echo "CPU user :"$CpuUser
echo "CPU kernel :"$CpuKernel
echo "RAM used :"$RamUsed
echo "Disk used :"$DiskUsed
echo "net RX :"$NetRX
echo "net TX :"$NetTX
echo "TotalDisk"$TotalDisk
done < /root/test_scripts/listvm.txt
