function ydot = ControlePH(t,y,u,q)
    ydot = 0.5*(1.4*q-0.9*u^3-y);
end
