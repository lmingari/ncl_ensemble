import subprocess
import sys
import time
import os

#--------------------------- BEGIN USER MODIFICATIONS ---------------------------
EXEC_STR       = "ncl -Q"                     # -Q option turns off echo of NCL version and copyright info
POLL_INTERVAL  = 10                           # seconds between checking status of tasks
MAX_CONCURRENT =  2                           # run MAX_TASKS tasks at once
scripts = ["par1.ncl",                        # NCL script list
           "par2.ncl",
           ]
#--------------------------- END USER MODIFICATIONS -----------------------------

def launchTask(script):
    task = subprocess.Popen(EXEC_STR + " " + script, shell=True, executable="/bin/bash") 
    return task
 
# ------------------------- main -----------------------------------------------

# fire off up-to MAX_CONCURRENT subprocesses...
tasks = list()
for i,script in enumerate(scripts):
    if i >= MAX_CONCURRENT:
        break
    tasks.append( launchTask(script) )

scripts = scripts[len(tasks):]  # remove those scripts we've just launched...

while len(tasks) > 0:
    finishedList = []
    for task in tasks:
         retCode = task.poll()
         if retCode != None:
             finishedList.append(task)

             # more scripts to be run?
             if len(scripts) > 0:
                 tasks.append( launchTask(scripts[0]) )
                 del scripts[0]

    for task in finishedList:
        tasks.remove(task)

    if tasks:
      time.sleep(POLL_INTERVAL)
    else:
      break

print "task_parallelism.py: Done!"


