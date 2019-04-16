close
clear
clc
dbstop if error
%%
tic
load('gog_pars.mat');
load('max_chroma.mat');
% 1. blue 2. green 3. red 4. skin 5. sky 6. yellow
la = 80;
yb = 18;
para = [1 0.69 1];

imagename = ('color_patch.jpg');
imagebit = 8;
N = 2^imagebit - 1;
I = double(imread(imagename))/N;
[m,n,d] = size(I);
%% DACs to XYZ
XYZ=display_f(reshape(I,m*n,d));
%% Wahrnehmungsattribute berechnen
J_m = zeros(m,n);
C_m = zeros(m,n);
h_m = zeros(m,n);
[J,Q,C,M,s,h] = ciecam02(XYZ,display_white,la,yb, para);
J = J';Q = Q';C = C';M = M';s = s';h = h';

%% Wahrnehmungsattribute modifikation


%% Neue Bilder konstruktion

[I_neu] = Bilder_rekonstr(J, C, h, display_white, la, yb, para, m, n, d);
imshow(I),figure,imshow(I_neu);
toc