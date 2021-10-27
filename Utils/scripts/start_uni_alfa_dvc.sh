#!/bin/bash
export ROS_IP=192.168.197.136
echo "Exported ROS_IP -> $ROS_IP"
export ROS_MASTER_URI=http://192.168.197.60:11311/
echo "Exported ROS_MASTER_URI -> $ROS_MASTER_URI"
source /home/andre/catkin_ws/devel/setup.sh
<<<<<<< HEAD
echo "Sourced devel/setup"
=======
echo "Sourced /home/andre/catkin_ws/devel/setup"
>>>>>>> 283be896dbc9582e274ad21168fb675ed4283a33
rosrun alfa_dvc alfa_dvc

