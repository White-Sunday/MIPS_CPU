filename_read = 'test.dat'
filename_write = 'test.coe'

with open(filename_read,'r') as fr:
    file_lines = fr.readlines()
    with open(filename_write,'w') as fw:
        for line in file_lines:
            fw.write(line.replace('\n', ',')+'\n')
        fw.close()
    fr.close()