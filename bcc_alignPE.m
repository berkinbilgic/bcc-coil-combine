function [ img_align2, Cmp_Align2  ] = bcc_alignPE( img, Cmp_Align, block_size )
%BCC_ALIGNPE Summary of this function goes here
%   Detailed explanation goes here



 Cmp_Align2 = Cmp_Align;


for bz = 1:size(Cmp_Align,5)
       
    nx = ceil(size(Cmp_Align,3)/2);
    
    n0 = ceil(size(Cmp_Align,4)/2);
    
    
    mtx = Cmp_Align(:,1,:,:,bz);        % compression matrices for blocks (:,:,bz)
   
        
    A00 = Cmp_Align(:,1,nx,n0,bz);         % reference compression matrix (1,1,bz)
       
        
    A0 = A00;
    
    for n = n0-1:-1:1        
        
        A1 = mtx(:,1,nx,n);
                
        mtx(:,1,:,n) = mtx(:,1,:,n) .* (A1'*A0) ./ abs(A0'*A1);

        A0 = mtx(:,1,nx,n);
 
    end
    
    
    A0 = A00;
    
    for n = n0+1:size(mtx,4)
        
        A1 = mtx(:,1,nx,n);
 
        mtx(:,1,:,n) = mtx(:,1,:,n) .* (A1'*A0) ./ abs(A0'*A1);
        
        A0 = mtx(:,1,nx,n);
         
    end
        
        
    Cmp_Align2(:,1,:,:,bz) = mtx;
        
end

 

N = size(img(:,:,:,1));


num_block = N ./ block_size;


img_align2 = zeros(N);


for bz = 1:num_block(3) 
    
    bz_ind = 1 + (bz - 1) * block_size(3) : bz * block_size(3);
    
    for by = 1:num_block(2) 

        by_ind = 1 + (by - 1) * block_size(2) : by * block_size(2);
         
        for bx = 1:num_block(1)

            bx_ind = 1 + (bx - 1) * block_size(1) : bx * block_size(1);
                      
            img_block = img(bx_ind, by_ind, bz_ind, :);
                        
            img_align2(bx_ind, by_ind, bz_ind) = svd_apply3d(img_block, Cmp_Align2(:,1,bx,by,bz));
              
        end
        
    end
end

 

end

