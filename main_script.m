clear;
close all;

patch_size = 80;
overlap = 10;
num_trials = 1000;

im1 = imread("textures/apples.png");
%im1= imread("textures/toast.png");
%im1= imread("textures/random3.png");
%im1= imread("textures/text.jpg");
%im1= imread("textures/radishes.jpg");
%im1= imread("textures/rice.bmp");
%im1= imread("textures/grass.png");
%im1= imread("textures/random.png");
im1 = im2double(im1);

if size(im1,3) ==1
    im1_temp1(:,:,1) = im1;
    im1_temp1(:,:,2) = im1;
    im1_temp1(:,:,3) = im1;
    im1 = im1_temp1;
end

[rows_sz cols_sz z] = size(im1);
mult = 3;

for row = 1:patch_size-overlap:(rows_sz*mult)-patch_size+1
    for col = 1:patch_size-overlap:(cols_sz*mult)-patch_size+1
        tic
        if row > 1 && col > 1
            
            
            upper_neighbor = new_img(row-patch_size+overlap:row+overlap-1, col:col+patch_size-1,:);
            left_neighbor = new_img(row:row+patch_size-1, col-patch_size+overlap:col-1+overlap,:);

            b_patch = best_patch(im1,overlap, patch_size, num_trials, left_neighbor, upper_neighbor, "both");
            
            upper_neighbor_p = permute(upper_neighbor, [2 1 3]);
            b_patch_p = permute(b_patch, [2 1 3]);
            
            overlap_region_up = find_overlap(b_patch_p,overlap, patch_size, upper_neighbor_p, 0, "left");
            overlap_region_up = permute(overlap_region_up, [2 1 3]);
            
            %imshow(new_img)
            new_img(row:row+overlap-1,col:col-1+patch_size,:) = overlap_region_up;
           % imshow(new_img)
            %new bpatch has edgecuts
            b_patch(1:overlap,:,:) =  overlap_region_up;
           
            %this version of left_neighbour has edgecuts
            %left_neighbor = new_img(row:row+patch_size-1, col-patch_size+overlap:col-1+overlap,:);
            %left_neighbor = new_img(row:row+patch_size-1, col-patch_size+overlap:col-1+overlap,:);

            overlap_region_left = find_overlap(b_patch,overlap, patch_size, left_neighbor, 0, "left");
            
            new_img(row:row+patch_size-1,col:col-1+overlap,:) = overlap_region_left;
            %imshow(new_img)
            new_img(row+overlap:row+patch_size-1,col+overlap:col+patch_size-1,:) = b_patch(overlap+1:end,overlap+1:end,:);
           % imshow(new_img)
            %%%%%%%
            
            
            %place best patch
            
        elseif row == 1 && col > 1
            %1st row columns, can look left, not up
            left_neighbor = new_img(row:row+patch_size-1, col-patch_size+overlap:col-1+overlap,:);
            b_patch = best_patch(im1,overlap, patch_size, num_trials, left_neighbor, 0, "left");
            overlap_region = find_overlap(b_patch,overlap, patch_size, left_neighbor, 0, "left");
            
            %place overlap
            
            
            %place best patch
            new_img(row:row+patch_size-1,col+overlap:col+patch_size-1,:) = b_patch(:,overlap+1:end,:);
            new_img(row:row+patch_size-1,col:col-1+overlap,:) = overlap_region;
            %new_img(row:row+patch_size-1, col:col+patch_size-1,:) = best_patch(im1,overlap, patch_size, num_trials, left_neighbor, 0, "left");
            %imshow(new_img)
            
        elseif col == 1 && row > 1
            %1st column of new row, can look up, not left
            upper_neighbor = new_img(row-patch_size+overlap:row+overlap-1, col:col+patch_size-1,:);
            b_patch = best_patch(im1,overlap, patch_size, num_trials, 0, upper_neighbor, "upper");
            upper_neighbor_p = permute(upper_neighbor, [2 1 3]);
            b_patch_p = permute(b_patch, [2 1 3]);
            overlap_region = find_overlap(b_patch_p,overlap, patch_size, upper_neighbor_p, 0, "left");
            overlap_region = permute(overlap_region, [2 1 3]);
            
            new_img(row+overlap:row+patch_size-1,col:col+patch_size-1,:) = b_patch(overlap+1:end,:,:);
            
            new_img(row:row+overlap-1,col:col-1+patch_size,:) = overlap_region;
            %new_img(row:row+patch_size-1, col:col+patch_size-1,:) = best_patch(im1,overlap, patch_size, num_trials, 0, upper_neighbor, "upper");
            
        else
            %1st entry
            new_img(row:row+patch_size-1, col:col+patch_size-1,:) = random_patch(im1,patch_size);
        end
        
        
        
    end
    toc
end

imshow(new_img)