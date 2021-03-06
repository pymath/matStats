function res = flipAxis(this, index)
%FLIPAXIS Reverse coordinates in one of the axes
%
%   PCA2 = flipAxis(PCA, IND)
%
%   Example
%   flipAxis
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-11-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% first make a copy constructor
res = Pca(this);

% reverse the score array
res.scores.data(:, index) = -res.scores.data(:, index);

% reverse the loadings array
res.loadings.data(:, index) = -res.loadings.data(:, index);
