la = 116.2;
yb = 25.72;
para = [0.8 0.525 0.8];
display_white = [115.8740 119.4659 138.0957];
XYZ = display_f(rgb);
[J,~,C,~,~,h] =ciecam02(XYZ,display_white,la,yb, para);