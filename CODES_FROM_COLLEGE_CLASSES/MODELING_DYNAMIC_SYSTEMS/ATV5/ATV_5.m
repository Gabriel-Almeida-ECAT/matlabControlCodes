k = 220.0;
cp = 896.0;
ro = 2702.0;

L = 0.002;
L0 = 0.001;
Ak = 3.14E-6;
Ac = 1.26E-5;
Ace = 3.14E-6;

hc = 20.0;
Ch = ro*cp*Ak*L;
Rhk = L/(k*Ak);
Rhk0 = L0/(k*Ak);
Rhc = 1/(hc*Ac);
Rhce = 1/(hc*Ace);

T0 = 25*ones(5,1);
A = zeros(5,5);
B = zeros(5,2);
C = eye(5);
D = zeros(5,2);

A(1,1) = -1/Ch*( (1/Rhk0) + (1/Rhk) + (1/Rhc));
A(1,2) = 1/Ch*(1/Rhk);

A(2,1) = 1/Ch*(1/Rhk);
A(2,2) = -1/Ch*((2/Rhk) + (1/Rhc));
A(2,3) = 1/Ch*(1/Rhk);

A(3, 2) = 1/Ch*(1/Rhk);
A(3, 3) = -1/Ch*((2/Rhk) + (1/Rhc));
A(3, 4) = 1/Ch*(1/Rhk);

A(4, 3) = 1/Ch*(1/Rhk);
A(4, 4) = -1/Ch*((2/Rhk) + (1/Rhc));
A(4, 5) = 1/Ch*(1/Rhk);

A(5, 4) = 1/Ch*(1/Rhk);
A(5, 5) = -1/Ch*((1/Rhk) + (1/Rhc) + (1/Rhce));

B(1, 1) = 1/(Ch*Rhk0);
B(1, 2) = 1/(Ch*Rhc);
B(2, 2) = 1/(Ch*Rhc);
B(3, 2) = 1/(Ch*Rhc);
B(4, 2) = 1/(Ch*Rhc);
B(5, 2) = 1/Ch*((1/Rhc) + (1/Rhce));

data = [1 2 3 4; 2 3 4 5; 3 4 5 6; 4 5 6 7; 5 6 7 8];
%colors = [ [1 0 0], [0 1 0], [0 0 1], [1 0 1], [1 1 0]];
colors = ["r", "g", "b", "m", "y"];
labels = {'Var1', 'Var2', 'Var3', 'Var4', 'Var5'};
times = [0.05, 0.1, 0.5, 1, 10]; 

figure;
for i = 1:size(data, 1)
    plot(data(i, :), 'Color', colors(i), 'DisplayName', sprintf('t = %.d', times(i)));
    hold on;
end

xticks(1:length(labels));
xticklabels(labels);
xlabel('Tns');
ylabel('Temperature');
title('Values Over Time');
legend('Location', 'best');
hold off;

times_matrix = [0.05; 0.1; 0.5; 1; 10];
U = [25; 25; 25; 25; 25];
espEstados = ss(A, B, C, D);
estados = lsim(espEstados, T0, 100);
plot(times, estados);



