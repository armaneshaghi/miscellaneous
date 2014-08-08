#!/bin/bash                                                                                                                                                    
for file in ./* 
do
filename=`basename $file`
substring="tehran"
substring2="london"
        if [[ "$filename" == *"$substring"* ]] || [[ "$filename" == *"$substring2"* ]]
           then
                   echo $filename
        fi
done
