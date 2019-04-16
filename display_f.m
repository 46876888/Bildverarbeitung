% Foward Charactersiation Models RGB->XYZ
function XYZ=display_f(RGB) % RGB: n by 3 scaled data ranging from 0-1 despite of the format(10-bit or 8-bit)

rdata=RGB(:,1)';
gdata=RGB(:,2)';
bdata=RGB(:,3)';
load('gog_pars.mat');
LRx=gog_f(coef_r,rdata);LRx(LRx<0)=0;
LGy=gog_f(coef_g,gdata);LGy(LGy<0)=0;
LBz=gog_f(coef_b,bdata);LBz(LBz<0)=0;
XYZ=bsxfun(@plus,max_XYZ*[LRx;LGy;LBz],black');
XYZ=XYZ';
end