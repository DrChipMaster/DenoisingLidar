#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>


using namespace std;

int
main (int argc, char** argv)
{
  pcl::PointCloud<pcl::PointXYZI>::Ptr cloud (new pcl::PointCloud<pcl::PointXYZI>);

  if (pcl::io::loadPCDFile<pcl::PointXYZI> (argv[1], *cloud) == -1) //* load the file
  {
    PCL_ERROR ("Couldn't read file test_pcd.pcd \n");
    return (-1);
  }
  string name = argv[1];
  name.erase(name.end()-4,name.end());
  string name_x = name;
  name_x.append("_x.txt");
  string name_y = name;
  name_y.append("_y.txt");
  string name_z = name;
  name_z.append("_z.txt");
  string name_i = name;
  name_i.append("_i.txt");
  name.append(".xyzi");

  ofstream file(name);
  ofstream file_x(name_x);
  ofstream file_y(name_y);
  ofstream file_z(name_z);
  ofstream file_i(name_i);

  std::cout << "Loaded "
            << cloud->width * cloud->height
            << " data points from test_pcd.pcd with the following fields: "
            << std::endl;
  for (const auto& point: *cloud)
  {
    std::cout << "    " << point.x
              << " "    << point.y
              << " "    << point.z
              << " "<<point.intensity << std::endl;

    file << point.x<<" "<<point.y<<" "<<point.z<<"\n";
    std::stringstream aux_x;
      aux_x << std::hex << (int16_t) (point.x*100);
    std::stringstream aux_y;
      aux_y << std::hex << (int16_t) (point.y*100);
    std::stringstream aux_z;
      aux_z << std::hex << (int16_t) (point.z*100); 
    std::stringstream aux_i;
      aux_i << std::hex << (int16_t) (point.intensity);  
    file_x <<aux_x.str() << "\n";
    file_y <<aux_y.str() << "\n";
    file_z << aux_z.str() << "\n";
    file_i << aux_i.str() << "\n";

  }
    

  return (0);
}