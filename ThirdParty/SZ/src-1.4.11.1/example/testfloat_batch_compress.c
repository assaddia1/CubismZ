/**
 *  @file testfloat_batch_compress.c
 *  @author Sheng Di
 *  @date April, 2015
 *  @brief This is an example of using compression interface
 *  (C) 2015 by Mathematics and Computer Science (MCS), Argonne National Laboratory.
 *      See COPYRIGHT in top-level directory.
 */


#include <stdio.h>
#include <stdlib.h>
#include "sz.h"
#include "rw.h"
#include "VarSet.h"

struct timeval startTime;
struct timeval endTime;  /* Start and end times */
struct timeval costStart; /*only used for recording the cost*/
double totalCost = 0;


void cost_start()
{
        gettimeofday(&costStart, NULL);
}

void cost_end()
{
        double elapsed;
        struct timeval costEnd;
        gettimeofday(&costEnd, NULL);
        elapsed = ((costEnd.tv_sec*1000000+costEnd.tv_usec)-(costStart.tv_sec*1000000+costStart.tv_usec))/1000000.0;
        totalCost += elapsed;
}


int main(int argc, char * argv[])
{
    size_t r5=0,r4=0,r3=0,r2=0,r1=0;
    char outDir[640], oriFilePath[640], outputFilePath[640];
    char *cfgFile;
    
    if(argc < 3)
    {
	printf("Test case: testfloat_batch_compress [config_file] [srcFilePath] [dimension sizes...]\n");
	printf("Example: testfloat_batch_compress sz.config testfloat_8_8_128.dat 8 8 128\n");
	exit(0);
    }
   
    cfgFile=argv[1];
    sprintf(oriFilePath, "%s", argv[2]);
    if(argc>=4)
	r1 = atoi(argv[3]); //8
    if(argc>=5)
	r2 = atoi(argv[4]); //8
    if(argc>=6)
	r3 = atoi(argv[5]); //128
    if(argc>=7)
        r4 = atoi(argv[6]);
    if(argc>=8)
        r5 = atoi(argv[7]);
   
    printf("cfgFile=%s\n", cfgFile); 
    SZ_Init(cfgFile);
    
    sprintf(outputFilePath, "%s.bsz", oriFilePath);
   
    size_t nbEle; 
    int status;
    float *data = readFloatData(oriFilePath, &nbEle, &status);
    //float *revValue = (float *)malloc(sizeof(float));
    //*revValue = 1.0E36;
  
    float *data2 = readFloatData(oriFilePath, &nbEle, &status);
    
    SZ_batchAddVar("data", SZ_FLOAT, data, ABS, 0.000001, 0.000001, r5,r4,r3,r2,r1);
    SZ_batchAddVar("data2", SZ_FLOAT, data2, ABS, 0.000001, 0.000001, r5,r4,r3,r2,r1);

    size_t outSize; 
    //char *bytes = (char *)malloc(nbEle*sizeof(float)); //
    //SZ_compress_args2(SZ_FLOAT, data, bytes, &outSize, ABS, 0.0001, 0.0001, r5, r4, r3, r2, r1);    
    //char *bytes = SZ_compress_rev(SZ_FLOAT, data, revValue, &outSize, r5, r4, r3, r2, r1);
    cost_start();
    unsigned char *bytes = SZ_batch_compress(&outSize);
    cost_end(); 
    printf("timecost=%f\n",totalCost); 
    writeByteData(bytes, outSize, outputFilePath, &status);
   
    //decompression
    size_t compressedLength = outSize;
    SZ_batch_decompress(bytes, compressedLength, &status);

    //write the decompressed data to disk 
    size_t dataLength; 
    int varIndex = 0;
    SZ_Variable* p = sz_varset->header->next;
    while(p!=NULL)
    {
        sprintf(outputFilePath, "%s-batch%d.out", oriFilePath, varIndex++);
        dataLength = computeDataLength(p->r5, p->r4, p->r3, p->r2, p->r1);
	writeFloatData(p->data, dataLength, outputFilePath, &status);
        p = p->next;
    }

    printf("done\n");
    
    SZ_Finalize();
    
    return 0;
}
