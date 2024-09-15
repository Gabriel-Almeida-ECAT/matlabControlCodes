syms S

% random transfer function for testing
G = (10) / (S^2 + 14*S + 50)
H = 1;

closed_loop_tf = G / (1 + G*H)

input = 1/S; %step function

error_equation = (1-closed_loop_tf)

SSerror = limit(S*input*error_equation, S, 0)