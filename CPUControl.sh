#Must be root/sudo user to execute
#Vary path based on system
FLROOT="/sys/devices/system/cpu"
cd path
#display max/min
echo ./cpu0/cpufreq/scaling_available_frequencies

echo "have to enter a frequency. Available frequencies are:"
cat $FLROOT/cpu0/cpufreq/scaling_available_frequencies

# see http://www.thinkwiki.org/wiki/How_to_make_use_of_Dynamic_Frequency_Scaling

# Set a frequency=temporary
# Governor: Max frequency -- Some algorithms refer to this value to scale other frequency values
# Governor scales down 
modprobe cpufreq_performance cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_userspace

echo "display available governors"
cat $FLROOT/cpu0/cpufreq/scaling_available_governors

echo "display current cpu0 governor"
cat $FLROOT/cpu0/cpufreq/scaling_governor

cpucount=$1
METHOD=0 # 0=use setspeed, 1=use min max
i=0
while [ $i -ne $cpucount ]
do
	if [ $METHOD == 0 ]; then
		FLNM="$FLROOT/cpu"$i"/cpufreq/scaling_governor"
		echo "Setting $FLNM to " userspace
		echo userspace > $FLNM
		FLNM="$FLROOT/cpu"$i"/cpufreq/scaling_setspeed"
		echo "Setting freq $FLNM to " $1
		echo $1 > $FLNM
	else
		echo "Setting freq $FLROOT/cpu"$i"/cpufreq/cpuinfo_max_freq to " $1
		FLNMAX="$FLROOT/cpu"$i"/cpufreq/cpuinfo_max_freq"
		FLNMIN="$FLROOT/cpu"$i"/cpufreq/cpuinfo_min_freq"
		echo $1 > $FLNMAX
		echo $1 > $FLNMIN
	fi
	i=`expr $i + 1`
done 


