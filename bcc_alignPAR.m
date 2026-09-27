function [ img_align3, Cmp_Align3 ] = bcc_alignPAR( img, Cmp_Align2, block_size )
%BCC_ALIGNPAR Summary of this function goes here
%   Detailed explanation goes here


Cmp_Align3 = Cmp_Align2;


nx = ceil(size(Cmp_Align2, 3) / 2);
ny = ceil(size(Cmp_Align2, 4) / 2);
    

n0 = ceil(size(Cmp_Align2, 5) / 2);
    
    
mtx = Cmp_Align2(:,1,:,:,:);            % compression matrices for blocks (:,:,bz)
    
        
A00 = Cmp_Align2(:,1,nx,ny,n0);         % reference compression matrix (1,1,bz)
    
    
        
A0 = A00;
    
for n = n0-1:-1:1        
        
    A1 = mtx(:,1,nx,ny,n);
               
    mtx(:,1,:,:,n) = mtx(:,1,:,:,n) .* (A1'*A0) ./ abs(A0'*A1);

    A0 = mtx(:,1,nx,ny,n);  

end
    
    
A0 = A00;
    
for n = n0+1:size(mtx,5)
        
    A1 = mtx(:,1,nx,ny,n);

    mtx(:,1,:,:,n) = mtx(:,1,:,:,n) .* (A1'*A0) ./ abs(A0'*A1);
        
    A0 = mtx(:,1,nx,ny,n);
               
end
    
       
Cmp_Align3(:,1,:,:,:) = mtx;



N = size(img(:,:,:,1));


num_block = N ./ block_size;

 
img_align3 = zeros(N);


for bz = 1:num_block(3) 
    
    bz_ind = 1 + (bz - 1) * block_size(3) : bz * block_size(3);
    
    for by = 1:num_block(2) 

        by_ind = 1 + (by - 1) * block_size(2) : by * block_size(2);
        
        for bx = 1:num_block(1)           

            bx_ind = 1 + (bx - 1) * block_size(1) : bx * block_size(1);
                      
            img_block = img(bx_ind, by_ind, bz_ind, :);
                        
            img_align3(bx_ind, by_ind, bz_ind) = svd_apply3d(img_block, Cmp_Align3(:,1,bx,by,bz));
              
        end
        
    end
end

 


end

