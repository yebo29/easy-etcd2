#!/bin/bash

# check if any containers running
CONTAINERS=$(docker ps | grep etcd | awk '{ print $1 }')
if [ -z "$CONTAINERS" ]; then
	echo "Did not find any etcd containers."
else
	echo "Running containers found: "$CONTAINERS""
	for i in ${CONTAINERS[@]}; do
		echo -n "Remove container ${i}, or remove all containers found? y/n/all/q "
		read answer
		case $answer in
			y|Y|yes|Yes|YES)
				echo -n "Stopping and destroying container.."
				[[ `docker stop ${i}` ]] > /dev/null 2>&1 && echo "Success" || echo "Unable to stop container. Please check logs"
                                [[ `docker rm ${i}` ]] > /dev/null 2>&1 || echo "Unable to remove container. Please check logs"
				;;
			n|N|no|No|NO)
				echo "Aborting destruction of container ${i}"
				;;
			a|A|All|all|ALL)
				echo "Stopping and destroying all containers"
				for n in ${CONTAINERS[@]}; do
					echo -n "Destroying ${n}.."
					[[ `docker stop ${n}` ]] > /dev/null 2>&1 && echo "Success" || echo "Unable to stop container. Please check logs"
					[[ `docker rm ${n}` ]] > /dev/null 2>&1 || echo "Unable to remove container. Please check logs"
				done
				exit
				;;
			q|Q|quit|Quit|QUIT)
				echo "Aborting"
				exit
				;;
			*)
				echo "Invalid input. Please try again."
				exit
				;;
		esac
	done
fi
