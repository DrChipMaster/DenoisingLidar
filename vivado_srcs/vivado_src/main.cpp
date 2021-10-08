#include <iostream>
#include <sys/mman.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

using namespace std;
typedef long long int u64;

int main()
{
    cout << "Starting ddr test:";
    off_t ddr_aloc_base_addr = 0x0F000000;
    uint ddr_aloc_size = 0x05000;
    off_t bram_base = 0xA0000000;
    uint bram_size = 0x2000;
    int fd;
    int value_pos = 0;
    int value_in = 0;
    //uint32_t ddr_pointer[125000];
    u64 *ddr_pointer;
    u64 *bram_pointer;
    //ddr_pointer = (uint32_t*)0x500000;
    //ddr_pointer = (u64*)ddr_aloc_base_addr;
    if ((fd = open("/dev/mem", O_RDWR | O_SYNC)) != -1) {
    	cout << "opening DDR"<<endl;
        ddr_pointer = (u64*)mmap(NULL,ddr_aloc_size,PROT_READ|PROT_WRITE, MAP_SHARED, fd,ddr_aloc_base_addr);
    }

    while (1)
    {
        cout << " Enter position to write: "<<endl;
        cin >> value_pos;
        cout << "selected pos: "<<value_pos<<endl<<"Enter value to write"<<endl;
        cin >> value_in;
        cout << "selected value: "<<value_in<<endl;
        //cout << "Base Addr: "<<hex<<(uint32_t)ddr_pointer<<endl;
        ddr_pointer[value_pos]= value_in;
        cout<< "Wrote in memory"<<endl;
        usleep(20);
        /*
        bram_pointer[0]=0xFFFFF;
        int hardware_finish =1;
            while (hardware_finish) {
                int value = bram_pointer[4];
                if(value >=1)
                    hardware_finish=0;
                else
                     usleep(1);
            }
		*/

        cout << "Reading ...."<<endl;
        cout << "Value stored in memory: "<<ddr_pointer[value_pos]<<endl;
        cout << "value in bram: "<< bram_pointer[3]<<endl;
    }

}
