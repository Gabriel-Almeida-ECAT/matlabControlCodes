clc; clear all;

s=tf('s');
wn=6;
z=2/3;
Gs=wn^2/(s^2+2*z*wn*s+wn^2);

Ts = stepinfo(Gs).SettlingTime/30

Gz = c2d(Gs, Ts)

t = (0:Ts:2e3*Ts);

% Option 2: use LSIM
u = 0*t;
u(t<60)  = 1;
u(t>=60) = 2;
simulation = lsim(Gz,u,t);
plot(t,simulation),grid
