
# make 10 instances
for i in {1..10}; do 

  ./start_service.sh 

   # create some other proc for mixxing up things
   ./runner3.sh &

done



# kill some child proccess so that we have some sleep proccess running without correspoding runner.sh procs

ps axfu |grep [F]AKESMS   |head -5 |awk '{print $2}' |xargs kill 


