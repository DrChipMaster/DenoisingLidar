#!/bin/bash
export ROS_IP=192.168.197.6
echo "Exported ROS_IP -> $ROS_IP"
export ROS_MASTER_URI=http://192.168.197.60:11311/
echo "Exported ROS_MASTER_URI -> $ROS_MASTER_URI"
source devel/setup.sh
echo "Sourced devel/setup"
rosrun alfa_dvc alfa_dvc

