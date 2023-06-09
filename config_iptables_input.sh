#/usr/bin/env bash
set -e
sudo iptables-save | grep INPUT | grep -- '-A' > input.txt
n=0
while read item;
do
  let n+=1
  echo ${n} ${item}
done < input.txt > line-input.txt 


position=()
count=0
while read -r line ; 
do
  a=$(echo "${line}" | sed -E 's/^[0-9]+ //')
  b=$(cat line-input.txt | sed -E 's/^[0-9]+ //' | grep -c -- "${a}")
  if [ ${b} -gt 1 ]; then
    # change regex find rule dulicate
    position+=("$(echo "${line}" | grep -oP '(.*[0-9.]+\/32.*1105.*)' | grep -E -- '-A.*' | awk '{print $1}')")
    let count+=1
  fi
done < line-input.txt
length=${#position[*]}
#echo $length
echo $count
for element in "${position[@]}"; do
  if [ $count -gt 1 ]; then
    sudo iptables -D INPUT ${position[$length-1]}
    let length=length-1
    let count-=1
  else
    break
  fi
done
echo $count
