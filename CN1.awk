BEGIN{ 
a=0 
b=0 
} 
{ 
if($1=="r"&&$3=="2"&&$4=="3"&&$5=="tcp"&&$6=="1540") 
{ 
a++; 
} 
if($1=="d"&&$3=="2"&&$4=="3"&&$5=="tcp"&&$6=="1540") 
{ 
b++; 
} 
} 
END{ 
printf("\n total number of data packets received at Node 3: %d\n", a++); 
printf("\n total number of packets dropped between Node 2 and Node 3: %d\n", b++); 
}
