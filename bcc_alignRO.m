function [ img_align, Cmp_Align ] = bcc_alignRO( img, Cmp_Blox, block_size )
%BCC_ALINGRO Summary of this function goes here
%   Detailed explanation goes here



Cmp_Align = Cmp_Blox;


for bz = 1:size(Cmp_Blox,5)
       
    for by = 1:size(Cmp_Blox,4)        
        
        mtx = Cmp_Blox(:,1,:,by,bz);        % compression matrices for blocks (:,by,bz)
                
        n0 = ceil(size(mtx,3)/2);
        A00 = mtx(:,1,n0);

        A0 = A00;
        
        for n = n0-1:-1:1            
            
            A1 = mtx(:,1,n);
            
            mtx(:,1,n) = A1 .* (A1'*A0) ./ abs(A0'*A1);

            A0 = mtx(:,1,n);

        end
                
        A0 = A00;
        
        for n = n0+1:size(mtx,3)
            
            A1 = mtx(:,1,n);
            
            mtx(:,1,n) = A1 .* (A1'*A0) ./ abs(A0'*A1);

            A0 = mtx(:,1,n);
            
        end

        Cmp_Align(:,1,:,by,bz) = mtx;
        
    end    
end




N = size(img(:,:,:,1));


num_block = N ./ block_size;


img_align = zeros(N);


for bz = 1:num_block(3) 
    
    bz_ind = 1 + (bz - 1) * block_size(3) : bz * block_size(3);
    
    for by = 1:num_block(2) 

        by_ind = 1 + (by - 1) * block_size(2) : by * block_size(2);
         
        for bx = 1:num_block(1)

            bx_ind = 1 + (bx - 1) * block_size(1) : bx * block_size(1);
                      
            img_block = img(bx_ind, by_ind, bz_ind, :);
                        
            img_align(bx_ind, by_ind, bz_ind) = svd_apply3d(img_block, Cmp_Align(:,1,bx,by,bz));
              
        end
        
    end
end

 


end

