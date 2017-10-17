#!/bin/bash 

backslash() {
b_st_row=$1
b_st_cols=$2
b_char=$3
deco=$5
b_r_end=$((b_st_row + 5 ))
for((p=b_st_row;p<b_r_end;p++))
do 
tput setaf $4
tput cup $p $b_st_cols
printf "$b_char " 
# sleep 1

if [ $p -eq  $deco ] 
 then 
 temp=$((b_st_cols - 1))
 tput cup $p $temp
 printf "$deco_char1"
 
 temp=$((temp - 2))
 tput cup $p $temp
 printf "$deco_char2"
fi
((b_st_cols++))
done
echo""
}


forward() {
f_st_row=$1
f_st_cols=$2
f_char=$3
deco=$5
f_r_end=$((f_st_row + 5))

for((i=f_st_row;i<f_r_end;i++))
do 
tput cup $i $f_st_cols
tput setaf $4
printf "$f_char "
 
if [ $i -eq  $deco ] 
 then 
 temp=$((f_st_cols + 1))
 tput cup $i $temp
 printf "$deco_char1"
 temp=$((temp + 2))
 tput cup $i $temp
 printf "$deco_char2"
fi
# sleep 1
((f_st_cols--))
done
echo""

}


horizontal() {
hrow=$2
hstart=$1
hcols=$3
char=$4


end=$((hstart + hcols))

for((i=hstart;i<=end;i++))
do 
# sleep 1
tput setaf $5
tput cup $hrow $i
printf "$char" 
done
echo""
}

base(){
start=$1
tput setaf $4
f_st_cols=$((start - 2))
b_st_cols=$((start + 2))
rows=$2
st_row=$((rows+1))
char=$3
forward $st_row $f_st_cols "$char" $4 1000 
backslash $st_row $b_st_cols "$char"  $4 1000
hrow=$((st_row + 4))
hcols=12
hstart=$((start - 6))
horizontal $hstart $hrow $hcols "$char" $4
}

gen_rand() {
num1=$1
#num2=$((num1 + 5))

if [ $num1 -eq 0 ]
then
temp=$(($RANDOM % 2))
rand=$((temp + 2))

else

temp=$(($RANDOM % 5))
rand=$((temp + num1))
fi
}


cols=`tput cols`
start=$((cols/2))
#echo "What character do you want to use"
#read char
#echo "Enter the first character to be used for decoration"
#read deco_char1
#echo "Enter the second character to be used for decoration"
#read deco_char2

char="o"
deco_char1="."
deco_char2="c"

tput clear
rows=5
# char="*"


j=1

for((k=0;k<3;k++))
do

st_row=$((k*6))

f_st_cols=$((start - k*3))
color=$RANDOM
color=$((color % 6))
gen_rand $st_row

forward $st_row $f_st_cols "$char" $color $rand

b_st_cols=$((start + k*3))

gen_rand $st_row
backslash $st_row $b_st_cols "$char" $color $rand

hrow=$((j * 5 + k))
hstart=$((5+3*k))
hstart=$((start - hstart))
hcols=$((10 + k*6))
horizontal $hstart $hrow $hcols "$char" $color
((j++))
# deco $st_row $hstart $hcols
done
base $start $hrow "$char" $color

tput setaf 4
tput cup  10 10
printf "**MERRY**"
tput cup 10 90
printf "**CHRISTMAS**"

tput setaf 0
end=$((hrow + 5))

tput cup $end 0


