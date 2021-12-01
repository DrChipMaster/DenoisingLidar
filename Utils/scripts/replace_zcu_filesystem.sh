#!/bin/bash
rm -r /media/andre/ROOT/
echo "Removed old filesystem"
tar x -C /media/andre/ROOT/ -f /home/andre/zcu_ros/tmp/deploy/images/zcu104-zynqmp/ros-image-core-melodic-zcu104-zynqmp.tar.gz
echo "Decompressed filesystem!"
cp /home/andre/DenoisingLidar/Utils/scripts/filter_node.sh /media/andre/ROOT/usr/bin
echo "Copied starting script"