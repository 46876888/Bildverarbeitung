% Reverse Charactersiation Models XYZ->RGB
function RGB=display_r(XYZ) % XYZ: n by 3, RGB data ranging from 0-1 despite of the format(10-bit or 8-bit)

load('gog_pars.mat');
XYZ_R=bsxfun(@minus,XYZ',black');
L_RGB=max_XYZ\XYZ_R;
rdata=real(gog_r(coef_r,L_RGB(1,:)));
gdata=real(gog_r(coef_g,L_RGB(2,:)));
bdata=real(gog_r(coef_b,L_RGB(3,:)));
RGB=[rdata;gdata;bdata]';

end