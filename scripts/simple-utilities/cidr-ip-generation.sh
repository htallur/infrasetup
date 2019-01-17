#!/bin/bash
awk 'BEGIN { 
for (x=0; x <= 255; x++) 
{print "192.168.1."x} 
}'
