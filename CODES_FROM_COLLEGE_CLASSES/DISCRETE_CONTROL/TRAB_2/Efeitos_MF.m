clc;clear;
s=tf('s');
C = (3.64*s+2.08)/(s+1.668);
T = 0.2;
f = 1/T;
Cd = c2d(C,T,'matched');
