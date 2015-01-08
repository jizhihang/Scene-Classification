% Starter code prepared by James Hays for CS 143, Brown University

%This function will predict the category for every test image by finding
%the training image with most similar features. Instead of 1 nearest
%neighbor, you can vote based on k nearest neighbors which will increase
%performance (although you need to pick a reasonable value for k).

function predicted_categories = nearest_neighbor_classify(train_image_feats, train_labels, test_image_feats)
    model = fitcknn(train_image_feats, train_labels, 'NumNeighbors', 8, 'Distance', 'cosine');
    predicted_categories = predict(model, test_image_feats);
end










