#!/bin/bash
export ROS_IP=192.168.1.90
echo "Exported ROS_IP -> $ROS_IP"
export ROS_MASTER_URI=http://192.168.1.89:11311/
echo "Exported ROS_MASTER_URI -> $ROS_MASTER_URI"
source /home/andre/catkin_ws/devel/setup.sh
echo "Sourced devel/setup"
rosrun alfa_dvc alfa_dvc

