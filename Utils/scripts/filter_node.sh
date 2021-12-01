#!/bin/bash
export ROS_IP=10.42.0.190
echo "Exported ROS_IP -> $ROS_IP"
export ROS_MASTER_URI=http://10.42.0.1:11311/
echo "Exported ROS_MASTER_URI -> $ROS_MASTER_URI"
rosrun filter_node filter_node

