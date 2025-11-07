import sys, os, glob

file_list = glob.glob("/data1/seh/2023_data/log.final.out/SW1783/*.final.out")
file_list.sort()

output_directory = "/data1/seh/2023_data/"
output_file = os.path.join(output_directory, "SW1783_mapping_rate.txt")

with open(output_file, 'w') as fw:
    index = "%s,%s,%s,%s\n" % ('sample', 'Number of input reads', 'Uniquely mapped reads number', 'Uniquely mapped reads %')
    fw.write(index)
    for i in file_list:
        samplename = i.split('/')[-1].split('.STAR')[0]
        #samplename = i.split('/')[-1].split('.STAR')[0].split('HT29-')[1]
        with open(i) as f:
            all_lines = f.readlines()
            A = all_lines[5].split('|\t')
            B = all_lines[8].split('|\t')
            C = all_lines[9].split('|\t')
            inputreads = A[1].strip()
            uniqereads = B[1].strip()
            mappingrates = C[1].strip()
            wr = "%s,%s,%s,%s\n" % (samplename, inputreads, uniqereads, mappingrates)
            fw.write(wr)
