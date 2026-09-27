function [ img_svd, Cmp_Blox ] = bcc_extractBlock( img, block_size )
%BCC_EXTRACTBLOCK Summary of this function goes here
%   Detailed explanation goes here


N = size(img(:,:,:,1));


if nargin < 2
    block_size = [1,1,N(3)];
end


num_block = N ./ block_size;



img_svd = zeros( N );

Cmp_Blox = zeros([size(img, 4), 1, num_block]);


for bz = 1:num_block(3)
    
    bz_ind = 1 + (bz - 1) * block_size(3) : bz * block_size(3);
    
    for by = 1:num_block(2)        

        by_ind = 1 + (by - 1) * block_size(2) : by * block_size(2);
        
        for bx = 1:num_block(1)

            bx_ind = 1 + (bx - 1) * block_size(1) : bx * block_size(1);

                      
            img_block = img(bx_ind, by_ind, bz_ind, :);
            
                        
            [img_block_svd, cmp_block] = svd_compress3d(img_block, 1);
          
            
            img_svd(bx_ind, by_ind, bz_ind) = img_block_svd;
                        
            
            Cmp_Blox(:,1,bx,by,bz) = cmp_block;
  
        end
    end    
end

 
end

