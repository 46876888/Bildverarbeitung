function [J, Q, C, M, s, h]=ciecam02(xyz, xyzw, la, yb, para)
% function [j,c,hq,m,h,s,q]=ciecam02(xyz,xyzw,la,yb,para)
% implements the CIECAM02 colour appearance model
% operates on n by 3 matrix xyz containing tristimulus
% values of the stimulus under the test illuminant
% xyzw is a 1 by 3 matrix containing the
% white point for the test illuminant
% la and yb are the luminance and Y tristimulus values of
% the achromatic background against which the sample is viewed
% para is a 1 by 3 matrix containing f, c and Nc.
% J, Q, C, M, s and h are correlates of Lightness, Brightness,
% Chroma, colourfuness, saturation and hue
f = para(1); c = para(2); Nc = para(3);
MH = [0.38971 0.68898 -0.07868; -0.22981 1.18340 0.04641;
0.0 0.0 1.0];
M02 = [0.7328 0.4296 -0.1624; -0.7036 1.6975 0.0061;...
    0.0030 0.0136 0.9834];
Minv = [1.096124 -0.278869 0.182745; 0.454369 0.473533 0.072098;...
    -0.009628 -0.005698 1.015326];
k = 1/(5*la+1);
fl = (k^ 4)*la + 0.1*((1-k ^ 4) ^ 2)*((5*la) ^ (1/3));
n = yb/xyzw(2);
ncb = 0.725*(1/n) ^ 0.2;
nbb = ncb;
z = 1.48+sqrt(n);
% step 1
rgb = M02*xyz';
rgbw = M02*xyzw';
% step 2
D = f*(1-(1/3.6)*exp((-la-42)/(92)));
% step 3
rgbc(1,:) = (D*xyzw(2)/rgbw(1) + 1 - D)*rgb(1,:);
rgbc(2,:) = (D*(xyzw(2)/rgbw(2)) + 1 - D)*rgb(2,:);
rgbc(3,:) = (D*(xyzw(2)/rgbw(3)) + 1 - D)*rgb(3,:);
rgbwc(1) = (D*(xyzw(2)/rgbw(1)) + 1 - D)*rgbw(1);
rgbwc(2) = (D*(xyzw(2)/rgbw(2)) + 1 - D)*rgbw(2);
rgbwc(3) = (D*(xyzw(2)/rgbw(3)) + 1 - D)*rgbw(3);
% step 4
rgbp = MH*Minv*rgbc;
rgbpw = MH*Minv*rgbwc';
% step 5
rgbpa(1,:) = (400*(fl*rgbp(1,:)/100).^0.42)./...
    (27.13+(fl*rgbp(1,:)/100).^ 0.42)+0.1;
rgbpa(2,:) = (400*(fl*rgbp(2,:)/100).^ 0.42)./...
    (27.13+(fl*rgbp(2,:)/100).^ 0.42)+0.1;
rgbpa(3,:) = (400*(fl*rgbp(3,:)/100).^ 0.42)./...
    (27.13+(fl*rgbp(3,:)/100).^ 0.42)+0.1;
rgbpwa(1) = (400*(fl*rgbpw(1,:)/100) ^ 0.42)/...
    (27.13+(fl*rgbpw(1)/100) ^ 0.42)+0.1;
rgbpwa(2) = (400*(fl*rgbpw(2,:)/100) ^ 0.42)/...
    (27.13+(fl*rgbpw(2)/100) ^ 0.42)+0.1;
rgbpwa(3) = (400*(fl*rgbpw(3,:)/100) ^ 0.42)/...
    (27.13+(fl*rgbpw(3)/100) ^ 0.42)+0.1;
% step 6
a = rgbpa(1,:) - 12*rgbpa(2,:)/11 + rgbpa(3,:)/11;
b = (rgbpa(1,:) + rgbpa(2,:) - 2*rgbpa(3,:))/9;
% step 7
h = cart2pol(a, b);
h = h*180/pi;
h = (h<0).*(h+360) + (1-(h<0)).*h;
% step 8
ehH = [20.14 90.00 164.25 237.53 380.14; 0.8 0.7 1.0 1.2 0.8;
0.0 100.0 200.0 300.0 400.0];
hh=h;
hh = (1-(hh<20.14)).*hh + (hh<20.14).*(360+20.14);
i=(hh>=20.14)+(hh>=90)+(hh>=164.25)+(hh>=237.53)+(h>=380.14);
H=ehH(3,i)+100.0*( (hh-ehH(1,i))/ehH(2,i) )/...
    ( (hh-ehH(1,i))/ehH(2,i) + (ehH(1,i+1)-hh)/ehH(2,i+1));
et = (cos(2+h*pi/180)+3.8)/4;
% step 9 :--------------------------------------------------
A = (2*rgbpa(1,:) + rgbpa(2,:) + rgbpa(3,:)/20 - 0.305)*nbb;
Aw = (2*rgbpwa(1) + rgbpwa(2) + rgbpwa(3)/20 - 0.305)*nbb;
% step 10:--------------------------------------------------
J = 100*(A/Aw).^ (c*z);
% step 11--------------------------------------------------
Q = (4/c)*((J/100).^ 0.5)*((Aw + 4)*fl ^ 0.25);
% step 12
t = (Nc*ncb*50000/13)*((et.*(a.^ 2+b.^ 2).^ 0.5)./...
    (rgbpa(1,:)+rgbpa(2,:)+21*rgbpa(3,:)/20));
C = (t.^ 0.9).*((J/100).^ 0.5)*(1.64-0.29 ^ n) ^ 0.73;
% step 13
M = C*fl^ 0.25;
% step 14
s = 100*(M./Q).^ 0.5;
end
