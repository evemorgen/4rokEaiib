username=`whoami | cut -c -7`
shellpid=`ps uax | grep bas[h] | grep $username | awk '{print $2}'`
pid=`echo $shellpid | awk '{print $1}'`
cwd=`lsof -p $pid | grep cwd | awk '{print $9}'`
ls $cwd | grep $1
