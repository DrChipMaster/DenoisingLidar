#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>


using namespace std;

int
main (int argc, char** argv)
{
  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud (new pcl::PointCloud<pcl::PointXYZ>);
  cloud.reset(new pcl::PointCloud<pcl::PointXYZ>);
  string name = argv[1];
  string name_x = name;
  name_x.append("_x.txt");
  string name_y = name;
  name_y.append("_y.txt");
  string name_z = name;
  name_z.append("_z.txt");
  name.append(".pcd");
ifstream file_x(name_x, fstream::in);
ifstream file_y(name_y, fstream::in);
ifstream file_z(name_z, fstream::in);
long x =0,y=0,z=0;
string sx,sy,sz;
while (file_x >> sx)
{
    file_y>>sy;
    file_z>>sz;
    x =  std::stoul(sx, nullptr, 16);
    y =  std::stoul(sy, nullptr, 16);
    z =  std::stoul(sz, nullptr, 16);
    if((sx.at(0)=='f' || sx.at(0)=='e') && sx.size()==4)
    {
      x = x-65535;
    }
    if((sy.at(0)=='f'|| sy.at(0)=='e') && sy.size()==4)
    {
      y = y-65535;
    }
    if((sz.at(0)=='f'|| sz.at(0)=='e')&&sz.size()==4)
    {
      z = z-65535;
    }
    


    pcl::PointXYZ point;
    point.x = x/100.0;
    point.y= y/100.0;
    point.z= z/100.0;
    if(point.x>600)
    {
      cout << "Error"<<x<< "with this:"<<sx<<endl;
    }
    //cout << point.x << " "<< point.y<< " "<<point.z<<endl;
    cloud->push_back(point);
}
pcl::io::savePCDFileASCII(name, *cloud);
  
    

  return (0);
}