function [b_patch] = best_patch_w_face(in_img, face_patch,alpha, overlap, patch_size, trials, left_neighbor, up_neighbor, n_flag)
    
    new_patch_cell = {trials};
    err_vert = zeros(1,trials);
    err_horz = zeros(1,trials);
    face_error = zeros(1,trials);
    [rows, cols, ~] = size(in_img);
    
    for i = 1: trials
        
        new_patch_start_y = ceil(rand*(cols-patch_size));
        new_patch_start_x = ceil(rand*(rows-patch_size));
        new_patch= in_img((new_patch_start_x):(new_patch_start_x+patch_size-1), (new_patch_start_y):(new_patch_start_y+patch_size-1),:);
        new_patch_cell{i} = new_patch;
        
        
        if n_flag == "upper" || n_flag == "both"
            %old_patch is the upper patch
            old_patch_lower_overlap = up_neighbor(end-overlap+1:end,:,:);
            new_patch_upper_overlap = new_patch(1:overlap,:,:);
            overlap_rms = (old_patch_lower_overlap - new_patch_upper_overlap).^2;
            overlap_rms_sum = sum(overlap_rms, 'all');
            err_vert(i) = overlap_rms_sum;
        end
        
        if n_flag == "left" || n_flag == "both"
            %old_patch is the left patch
            old_patch_rightmost_overlap = left_neighbor(:,end-overlap+1:end,:);
            new_patch_leftmost_overlap = new_patch(:,1:overlap,:);
            overlap_rms = (old_patch_rightmost_overlap - new_patch_leftmost_overlap).^2;
            overlap_rms_sum = sum(overlap_rms, 'all');
            err_horz(i) = overlap_rms_sum;
        end
        
        face_error_mat = (new_patch - face_patch).^2;
        sum_face_error = sum(face_error_mat, 'all');
        face_error(i) = sum_face_error;
    end
    
    mean_errs_t = (err_horz+err_vert)./2;
    
    mean_errs_t2 = mean_errs_t - min(mean_errs_t(:));
    mean_errs = mean_errs_t2 ./ max(mean_errs_t2(:));
    

    face_error = face_error - min(face_error(:));
    face_error = face_error ./ max(face_error(:));
    
    full_error = (1-alpha).*face_error + alpha.*mean_errs ;
    [~, best_patch_idx] = min(full_error);
    best_patch_cell = new_patch_cell(best_patch_idx);
    b_patch = cell2mat(best_patch_cell);
end


