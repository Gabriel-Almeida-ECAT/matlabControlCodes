clc; clear all;

S = tf('s');
Gma = zpk((1.59) / ((S + 2)*(S + 0.0625)) )

step_result = stepinfo(Gma); 
tsd = step_result.SettlingTime/3

syms g1 g2;
eq2 = -g1 + g2 == 0;
eq1 = g1 + g2 == 1;
sol = (vpasolve([eq1;eq2]));
r_g1 = double(sol.g1)
r_g2 = double(sol.g2)


%% 1*TS
Ts1 = tsd/25;
Gma_z1 = c2d(Gma, Ts1, 'matched')

z = tf('z', Ts1)
Gmf1 = 0.5*z^(-1) + 0.5*z^(-2)
Gc1 = minreal(( Gma_z1^(-1) )*( (Gmf1)/(1 - Gmf1) ))


%% 2*TS
Ts2 = Ts1*2;
Gma_z2 = c2d(Gma, Ts2, 'matched')

z = tf('z', Ts2)
Gmf2 = 0.5*z^(-1) + 0.5*z^(-2)
Gc2 = minreal(( Gma_z2^(-1) )*( (Gmf2)/(1 - Gmf2) ))


%% 3*TS
Ts3 = Ts1*3;
Gma_z3 = c2d(Gma, Ts3, 'matched')

z = tf('z', Ts3)
Gmf3 = 0.5*z^(-1) + 0.5*z^(-2)
Gc3 = minreal(( Gma_z3^(-1) )*( (Gmf3)/(1 - Gmf3) ))


%% resposta ao degrau
% Gmf1 = minreal(feedback(Gc1*Gma_z1, 1))
% Gmf2 = minreal(feedback(Gc2*Gma_z2, 1))
% Gmf3 = minreal(feedback(Gc3*Gma_z3, 1))
% step(Gmf1, Gmf2, Gmf3);
% legend("1*Ts","2*Ts","3*Ts")
% grid on; box on;


%% resposta ao disturbio
Gmf1_dist = Gma_z1 / (1 + Gma_z1*Gc1);
Gmf2_dist = Gma_z2 / (1 + Gma_z2*Gc2);
Gmf3_dist = Gma_z3 / (1 + Gma_z3*Gc3);
step(Gmf1_dist, Gmf2_dist, Gmf3_dist);
legend("dist 1*Ts","dist 2*Ts","dist 3*Ts")
grid on; box on;





