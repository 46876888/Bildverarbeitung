function [write_dir] = write_ordner(image_name, mode)
[mod_name,path_name] = transform(mode);
switch image_name
    case 'I1.tif'
        files = 'I1_';
    case 'I2.tif'
        files = 'I2_';
    case 'I3.tif'
        files = 'I3_';
    case 'I4.tif'
        files = 'I4_';
    case 'I5.tif'
        files = 'I5_';
    case 'I6.tif'
        files = 'I6_';
    case 'I7.tif'
        files = 'I7_';
    case 'I8.tif'
        files = 'I8_';
end
write_dir = strcat(path_name, '\', files, mod_name);


function [mod_name,path_name] = transform(mode)
switch mode
    case 'TC'
        mod_name = 'TC_';
        
%         path_name = ('C:\Users\Eizo\Documents\MATLAB\JY\BIlder\TC');
        path_name = ('C:\Users\Yang\Documents\MATLAB\Neu_Bildverarbeitung\BIlder\TC');
    case 'LE'
        mod_name = 'LE_';
%         path_name = ('C:\Users\Eizo\Documents\MATLAB\JY\BIlder\LE');
        path_name = ('C:\Users\Yang\Documents\MATLAB\Neu_Bildverarbeitung\BIlder\LE');
    case 'WP'
        mod_name = 'WP_';
%         path_name = ('C:\Users\Eizo\Documents\MATLAB\JY\BIlder\WP');
        path_name = ('C:\Users\Yang\Documents\MATLAB\Neu_Bildverarbeitung\BIlder\WP');
    case 'CH'
        mod_name = 'CH_';
%         path_name = ('C:\Users\Eizo\Documents\MATLAB\JY\BIlder\CH');
        path_name = ('C:\Users\Yang\Documents\MATLAB\Neu_Bildverarbeitung\BIlder\CH');
end