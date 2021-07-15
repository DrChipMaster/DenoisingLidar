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
long xp =0,yp=0,zp=0;
string sx,sy,sz;
string x1,y1,z1;
string x2,y2,z2;

while (file_x >> sx)
{
    file_y>>sy;
    file_z>>sz;
    x1 = sx.substr(sx.size()-4,sx.size());
    x2 = sx.substr(0,sx.size()-4);
    cout << "Point 1 text: "<<x1<<" Point 2 text: "<<x2<<endl;
    y1 = sy.substr(sy.size()-4,sy.size());
    y2 = sy.substr(0,sy.size()-4);

    z1 = sz.substr(sz.size()-4,sz.size());
    z2 = sz.substr(0,sz.size()-4);

    
    x =  std::stoul(x1, nullptr, 16);
    y =  std::stoul(y1, nullptr, 16);
    z =  std::stoul(z1, nullptr, 16);

    xp =  std::stoul(x2, nullptr, 16);
    yp =  std::stoul(y2, nullptr, 16);
    zp =  std::stoul(z2, nullptr, 16);

    if((x1.at(0)=='f' || x1.at(0)=='e') && x1.size()==4)
    {
      x = x-65535;
    }
    if((y1.at(0)=='f'|| y1.at(0)=='e') && y1.size()==4)
    {
      y = y-65535;
    }
    if((z1.at(0)=='f'|| z1.at(0)=='e')&&z1.size()==4)
    {
      z = z-65535;
    }


    if((x2.at(0)=='f' || x2.at(0)=='e') && x2.size()==4)
    {
      xp = xp-65535;
    }
    if((y2.at(0)=='f'|| y2.at(0)=='e') && y2.size()==4)
    {
      yp = yp-65535;
    }
    if((z2.at(0)=='f'|| z2.at(0)=='e')&&z2.size()==4)
    {
      zp = zp-65535;
    }
    


    pcl::PointXYZ point1, point2;
    point1.x = x/100.0;
    point1.y= y/100.0;
    point1.z= z/100.0;

    point2.x = xp/100.0;
    point2.y= yp/100.0;
    point2.z= zp/100.0;
    if(point1.x>600)
    {
      cout << "Error"<<x<< "with this:"<<sx<<endl;
    }
    cout <<"Point1: "<< point1.x << " "<< point1.y<< " "<<point1.z<<endl;
    cout <<"Point2: "<< point2.x << " "<< point2.y<< " "<<point2.z<<endl;
    cloud->push_back(point1);
    cloud->push_back(point2);
}
pcl::io::savePCDFileASCII(name, *cloud);
  
    

  return (0);
}