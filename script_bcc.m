%%-------------------------------------------------------------------------
%% SVD to 1-channel compression for each block
%%-------------------------------------------------------------------------

 
% img -> input image, dimensions: (x, y, z, chan)

load img_64x64x36x31_7T;        % low resolution 7T data


N = size(img(:,:,:,1));
block_size = [1,1,N(3)];
rot_disp = [90,90,-90];
  

[ img_svd, Cmp_Blox ] = bcc_extractBlock( img, block_size );



%%-------------------------------------------------------------------------
%% align phase in readout
%%-------------------------------------------------------------------------

 

[ img_align, Cmp_Align ] = bcc_alignRO( img, Cmp_Blox, block_size );


imagesc3d2(angle(img_align), N/2, 12, rot_disp, [-pi,pi])



%%-------------------------------------------------------------------------
%% align phase in phase encode
%%-------------------------------------------------------------------------

 
[ img_align2, Cmp_Align2  ] = bcc_alignPE( img, Cmp_Align, block_size );


imagesc3d2(angle(img_align2), N/2, 22, rot_disp, [-pi,pi])



%%-------------------------------------------------------------------------
%% align phase in partition encode
%%-------------------------------------------------------------------------

 
[ img_align3, Cmp_Align3 ] = bcc_alignPAR( img, Cmp_Align2, block_size );


imagesc3d2(angle(img_align3), N/2, 32, rot_disp, [-pi,pi])


% img_align3 -> final virtual body coil image
 
  

%--------------------------------------------------------------------------
%% ESPIRiT requires BART -> install version 0.2.06 and add to path
%--------------------------------------------------------------------------

cd bart-0.2.06/

system('make')

cd ..


bart_path = [pwd, '/bart-0.2.06/'];

setenv('TOOLBOX_PATH', bart_path)
addpath(strcat(getenv('TOOLBOX_PATH'), '/matlab'));
setenv('PATH', strcat(getenv('TOOLBOX_PATH'), ':', getenv('PATH')));
setenv('LD_LIBRARY_PATH', '');



%%-------------------------------------------------------------------------
%% ESPIRiT with virtual body coil as phase reference
%%-------------------------------------------------------------------------


num_acs = 16;       % size of calibration k-space fopr ESPIRiT
c = 0.2;            % threshold for sensitivity mask    


tic
    % concatenate virtual body coil as channel 1 to serve as phase
    % reference, but weight its magnitude by 1e-6 to preserve parallel imaging
    writecfl('img', single( cat(4, 1e-6 * img_align3, img) ))              

    system('fft 7 img kspace')

    system(['ecalib -c ', num2str(c), ' -r ', num2str(num_acs), ' kspace calib'])

    system('slice 4 0 calib sens')
toc


% clean up space:
system('rm calib.hdr')
system('rm calib.cfl')

system('rm kspace.hdr')
system('rm kspace.cfl')

system('rm img.hdr')
system('rm img.cfl')


sens_bcc = single(readcfl('sens'));

% grab only the head array sensitivities
sens_bcc = sens_bcc(:,:,:,2:end);      
    
    
% coil combine SENSE R=1 fashion:
img_espirit_bcc = sum(img .* conj(sens_bcc), 4) ./ (eps + sum(abs(sens_bcc).^2, 4));


imagesc3d2(angle(img_espirit_bcc), N/2, 42, rot_disp, [-pi,pi], [], 'Coil combined volume')



 