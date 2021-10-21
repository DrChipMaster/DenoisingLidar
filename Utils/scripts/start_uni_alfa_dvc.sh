#!/bin/bash
export ROS_IP=192.168.197.136
echo "Exported ROS_IP -> $ROS_IP"
export ROS_MASTER_URI=http://192.168.197.60:11311/
echo "Exported ROS_MASTER_URI -> $ROS_MASTER_URI"
source /home/andre/catkin_ws/devel/setup.sh
echo "Sourced /home/andre/catkin_ws/devel/setup"
rosrun alfa_dvc alfa_dvc

