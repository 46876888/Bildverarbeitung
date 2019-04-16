function [I_neu] = Bilder_rekonstr(J, C_ch, h, display_white, la, yb, para, m, n, d)
[mm,~] = size(J);
XYZ_neu = zeros(mm, 3);

for ii = 1 : mm
    J_neu = J(ii, 1); C_neu = C_ch(ii, 1); h_neu = h(ii, 1);
    XYZ_neu(ii, 1:3) = cam2xyz(J_neu, C_neu, h_neu, display_white, yb, la, para);
end
RGB_neu = display_r(XYZ_neu);
I_neu = reshape(RGB_neu, m, n, d);
%I = I * 255;
% imshow(I_neu)
% figure, imshow(I)
end
