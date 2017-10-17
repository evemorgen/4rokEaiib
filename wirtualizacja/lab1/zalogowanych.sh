ile=`who | awk '{print $1}' | sort | uniq | wc  -l`
ja=`whoami`
echo "Hello, my name is $ja, and there is $ile users logged in"
