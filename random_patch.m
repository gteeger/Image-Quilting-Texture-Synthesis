function [out_patch] = random_patch(in_im, patch_size)
    
    [rows, cols, ~] = size(in_im);
    
    new_patch_start_y = ceil(rand*(cols-patch_size));
    new_patch_start_x = ceil(rand*(rows-patch_size));
    out_patch = in_im((new_patch_start_x):(new_patch_start_x+patch_size-1), (new_patch_start_y):(new_patch_start_y+patch_size-1),:);
end

