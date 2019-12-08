function [overlap_region] = find_overlap(best_patch,overlap, patch_size, left_neighbor, up_neighbor, n_flag)
    
    
    if n_flag == "upper" || n_flag == "both"
        %old_patch is the upper patch
        disp("error");
        error("error");
        
    end
    
    if n_flag == "left" || n_flag == "both"
        %old_patch is the left patch
        old_patch_rightmost_overlap = left_neighbor(:,end-overlap+1:end,:);
        new_patch_leftmost_overlap = best_patch(:,1:overlap,:);
        error_matrix = (rgb2gray(old_patch_rightmost_overlap) - rgb2gray(new_patch_leftmost_overlap)).^2;
        E_matrix = zeros(patch_size, overlap);
        
        %first row of e matrix
        E_matrix(1,:) = error_matrix(1,:);
        
        for row = 2 : patch_size %start on row 2
            for col = 1 : overlap
                
                if col == 1 %1st col doesnt have a left col
                    
                    A = E_matrix(row-1, col);
                    B = E_matrix(row-1, col+1);
                    E_matrix(row, col) = error_matrix(row,col) +  min([A, B]);
                    
                    %s_matrix(row,col) = s_matrix(row,col) + min([A, B]);
                    
                elseif col == overlap % last col doesnt have a right col
                    A = E_matrix(row-1, col);
                    B = E_matrix(row-1, col-1);
                    E_matrix(row, col) = error_matrix(row,col) +  min([A, B]);
                    
                    %s_matrix(row,col) = s_matrix(row,col) + min([A, B]);
                    
                else
                    A = E_matrix(row-1, col);
                    B = E_matrix(row-1, col+1);
                    C = E_matrix(row-1, col-1);
                    
                    E_matrix(row, col) = error_matrix(row,col) +  min([A, B, C]);
                    
                end
                
                %e_matrix(row,col) = s_matrix(row,col); %%%%%%%%%ADDED
            end
        end
        
        [~,bottom_start_point] = min(E_matrix(patch_size, :));
        slice_point = bottom_start_point;
        
        overlap_region = zeros(patch_size,overlap, 3);
        for row = patch_size:-1: 2
            
            overlap_region(row,1:slice_point,:) = old_patch_rightmost_overlap(row,1:slice_point,:);
            overlap_region(row,slice_point:overlap,:) = new_patch_leftmost_overlap(row,(slice_point):end,:);
            slice_color = (old_patch_rightmost_overlap(row,slice_point,:) +new_patch_leftmost_overlap(row,(slice_point),:))./2;
            overlap_region(row,slice_point,:) = slice_color;
            
            
            
            if slice_point == 1 %first col
                A = E_matrix(row,slice_point);
                B = E_matrix(row,slice_point+1);
                
                [~, slice_point_update] = min([A,B]);
                
                if slice_point_update == 1
                    %go up
                    %slice_point = slice_point;
                elseif slice_point_update == 2
                    %go up + right
                    slice_point = slice_point+1;
                end
                continue; %incase the next elseif reevaluates
                
            elseif slice_point == overlap %last col
                A = E_matrix(row-1,slice_point);
                B = E_matrix(row-1,slice_point-1);
                
                [~, slice_point_update] = min([A,B]);
                
                if slice_point_update == 1
                    %go up
                    %slice_point = slice_point;
                elseif slice_point_update == 2
                    %go up + left
                    slice_point = slice_point-1;
                end
                continue;
            else
                A = E_matrix(row,slice_point);
                B = E_matrix(row,slice_point-1);
                C = E_matrix(row,slice_point+1);
                [~, slice_point_update] = min([A,B,C]);
                
                if slice_point_update == 1
                    %go up
                    %slice_point = slice_point;
                elseif slice_point_update == 2
                    %go up + left
                    slice_point = slice_point-1;
                elseif slice_point_update == 3
                    %go up + right
                    slice_point = slice_point+1;
                end
                
            end
            
        end
        %last row
        overlap_region(1,1:slice_point,:) = old_patch_rightmost_overlap(1,1:slice_point,:);
        overlap_region(1,slice_point:overlap,:) = new_patch_leftmost_overlap(1,(slice_point):end,:);
        slice_color = (old_patch_rightmost_overlap(1,slice_point,:) +new_patch_leftmost_overlap(1,(slice_point),:))./2;
        overlap_region(1,slice_point,:) = slice_color;
        
        
    end
end

