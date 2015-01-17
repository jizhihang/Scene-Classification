
function [means, covariances, priors] = build_fisher_vocabulary( image_paths, num_clusters)

    total_descriptors = [];
    
    % Sample random permutation of images
    sample_size = 200;
    perm = randperm(length(image_paths), sample_size);
    n = length(perm);
    
    for i = 1:n
        
        % Random image index
        image_index = perm(i);
        image_index = i;
        
        img = single(imread(image_paths{image_index}));
        
        [~, descriptors] = vl_dsift(img, 'step', 8, 'size', 4, 'fast');
        
        total_descriptors = [total_descriptors descriptors];
        
        print_progress_string(i, n, 'Creating Fisher Vocab');
    end

    data = single(total_descriptors);

    disp('Creating GMM Clusters');
    
    [means, covariances, priors] = vl_gmm(data, num_clusters);

end





