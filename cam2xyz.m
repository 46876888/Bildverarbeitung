function [ XYZ ] = cam2xyz(J, C, h, xyzw, yb, la, para)
%CAM2XYZ Summary of this function goes here
%   Detailed explanation goes here
f = para(1); c = para(2); Nc = para(3);
MH = [0.38971 0.68898 -0.07868; -0.22981 1.18340 0.04641;...
    0.0 0.0 1.0];
M02 = [0.7328 0.4296 -0.1624; -0.7036 1.6975 0.0061;...
    0.0030 0.0136 0.9834];
Minv = [1.096124 -0.278869 0.182745; 0.454369 0.473533 0.072098;...
    -0.009628 -0.005698 1.015326];
MH_inv = [1.9102 -1.1121 0.2019; 0.3710 0.6291 -0.000008; 0 0 1 ];

%step 0: Parameter vorbereiten 
k = 1 / (5 * la + 1);
fl = 0.2 * k^4 * 5 * la + 0.1 * (1 - k^4)^2 * (5 * la)^(1 / 3);

n = yb / xyzw(2);
z = 1.48 + sqrt(n);
Nbb = 0.725 * (1 / n )^ 0.2;
Ncb = Nbb;
% Rw Gw Bw
rgbw = M02 * xyzw';
% D -------------------------------------------------
D = f * (1 - (1 / 3.6)*(exp((-la-42)/92)));
if D > 1
    D = 1;
elseif D < 0
    D = 0;
end

% Dr Dg Db berechnen--------------------------
Drgb(1,:) = xyzw(2) * D / rgbw(1) + 1 - D;
Drgb(2,:) = xyzw(2) * D / rgbw(2) + 1 - D;
Drgb(3,:) = xyzw(2) * D / rgbw(3) + 1 - D;
% Rwc Gwc Bwc------------------------------------
rgbwc = Drgb.* rgbw;

% Rw' Gw' Bw' nannt rgbwp --------------------------
rgbwp = MH * Minv * rgbwc;

if rgbwp(1) >= 0
    rgbwpa(1) = ((400*((fl*rgbwp(1)/100)^0.42))/...
        (27.13 + (fl*rgbwp(1)/100)^0.42)) + 0.1;
else
    rgbwpa(1) = ((400*((-fl*rgbwp(1)/100)^0.42))/...
        (27.13 + (-fl*rgbwp(1)/100)^0.42)) + 0.1;
end

if rgbwp(2) >= 0
    rgbwpa(2) = ((400*((fl*rgbwp(2)/100)^0.42))/...
        (27.13 + (fl*rgbwp(2)/100)^0.42)) + 0.1;
else
    rgbwpa(2) = ((400*((-fl*rgbwp(2)/100)^0.42))/...
        (27.13 + (-fl*rgbwp(2)/100)^0.42)) + 0.1;
end

if rgbwp(3) >= 0
    rgbwpa(3) = ((400*((fl*rgbwp(3)/100)^0.42))/...
        (27.13 + (fl*rgbwp(3)/100)^0.42)) + 0.1;
else
    rgbwpa(3) = ((400*((-fl*rgbwp(3)/100)^0.42))/...
        (27.13 + (-fl*rgbwp(3)/100)^0.42)) + 0.1;
end
% Aw aus rgbwpa---------------------------------------------
Aw = Nbb * (2 * rgbwpa(1) + rgbwpa(2) + rgbwpa(3)/20 - 0.305);

% step 1: J
% J = 6.25 * ((c*Q)/(Aw + 4)* fl^0.25)^2;
% step 2: 
% wenn M gegeben ist
% C = M / fl^0.25;

% step 4: t, e and p1,p2,p3 rechnen----------------------------------------
t = (C/(sqrt(J/100) * (1.64 - 0.29^n)^0.73))^(1/0.9);
et = cos(h * (pi / 180) + 2) + 3.8;
e = (12500/13 * Nc * Ncb) * et;
A = Aw*(J/100)^(1/(c*z));
p2 = ( A / Nbb ) + 0.305;
p3 = 21 / 20;

% step 5: a und b rechnen
if t ~= 0
    p1 = e / t;
    hi = h * pi / 180 ;
    if (abs(sin(hi)) >= abs(cos(hi)))
        p4 = p1 / sin(hi);
        b = (p2 * (2 + p3) * (460 / 1403))/...
            (p4 + (2 + p3) * (220/1403)*(cos(hi)/sin(hi)) - (27/1403) + p3*(6300/1403));
        a = b*(cos(hi)/sin(hi));
    else
        p5 = p1/cos(hi);
        a = (p2 * (2 + p3) * (460 / 1403))/(p5 + (2 + p3) * (220/1403)- ...
            (27 /1403 - p3*(6300/1403)*(sin(hi)/cos(hi))));
        b = a * (sin(hi)/cos(hi));
    end
else
    a = 0; b = 0;
end
% step 6:
M1 = [460/1403 451/1403 288/1403; 460/1403 -891/1403 -261/1403;...
    460/1403 -220/1403 -6300/1403];
M2 = [p2 a b; p2 a b; p2 a b];

rgbpa = M1 .* M2;
rgbpa = [sum(rgbpa(1,:));sum(rgbpa(2,:));sum(rgbpa(3,:))];

% step 7: R' G' B'
rgbp(1,:) = sign(rgbpa(1) -0.1)*(100/fl)...
    *((27.13*abs(rgbpa(1)-0.1))/(400-abs(rgbpa(1)-0.1)))^(1/0.42);
rgbp(2,:) = sign(rgbpa(2) -0.1)*(100/fl)...
    *((27.13*abs(rgbpa(2)-0.1))/(400-abs(rgbpa(2)-0.1)))^(1/0.42);
rgbp(3,:) = sign(rgbpa(3) -0.1)*(100/fl)...
    *((27.13*abs(rgbpa(3)-0.1))/(400-abs(rgbpa(3)-0.1)))^(1/0.42);

% step 8: Rc Gc Bc
rgbc = M02 * MH_inv * rgbp;

% step 9: R G B
rgb = rgbc./ Drgb;
% step 10: X Y Z
XYZ = Minv * rgb;

end


