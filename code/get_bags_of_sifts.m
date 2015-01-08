% Starter code prepared by James Hays for CS 143, Brown University

%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_sifts(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every time at significant expense.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram.

% You will want to construct SIFT features here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% SIFT features will look very different from a smaller version of the same
% image.

    % vocab = vocab_size x 128
    load('vocab.mat')

    % size of histogram or num_features
    d = 400;
    n = length(image_paths);
    
    image_feats = ones(n, d);
    
    % build kdtree for distance querying
    kdtree = vl_kdtreebuild(vocab', 'NumTrees', 1);
    
    for i = 1:n
        
        image = single(imread(image_paths{i}));
        
        % Get the locations and descriptors for the image
        % with a fast dense sift with fixed size and step
        %
        % descriptors = 128 x num_features_found
        % locations = 2 x num_features_found
        [~, descriptors] = vl_dsift(image, 'step', 8, 'size', 4, 'fast');
        
        % Find the closest vocab given this image's descriptors
        % each descriptor is found closest to the distance in the vocab
        % matrix
        % min finds the closes of the descriptor to the vocab
        % min_indices = 1 x num_features_found with values from
        % 1..vocab_size
        
        rand_descriptors = descriptors;
        
        [min_indices, ~] = vl_kdtreequery(kdtree, vocab', single(rand_descriptors));
        
        % Build histogram from min_indices
        count_histogram = hist(single(min_indices), d);
        
        image_feats(i, :) = count_histogram ./ size(rand_descriptors, 2);
    end
end



