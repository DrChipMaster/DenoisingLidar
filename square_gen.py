import math




if __name__ == '__main__':
    f = open("square_values.txt","a")
    for x in range(2**32):
        f.write("value[%d] = 16'h%4.4x\n"%(x,int(math.sqrt(x))))
        print("value[%d] = 16'h%4.4x\n"%(x,int(math.sqrt(x))))
    f.close()
    print("Generated with success")
