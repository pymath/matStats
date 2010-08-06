function varargout = scatter(this, var1, var2, varargin)
%SCATTER Scatter plot of two columns in a table
%
%   TABLE.scatter(VAR1, VAR2)
%   where TABLE is a Table object, and VAR1 and VAR2 are either indices or
%   names of 2 columns in the table, scatter the individuals given with
%   given coordinates
%
%   Example
%   scatter
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% find index of first column
ind1 = this.columnIndex(var1);
col1 = this.data(:, ind1(1));

% find index of second column
ind2 = this.columnIndex(var2);
col2 = this.data(:, ind2(1));

% check if drawing style is ok to plot points
if isempty(varargin)
    varargin = {'+b'};
end

% scatter plot of selected columns
h = plot(col1, col2, varargin{:});

% add plot annotations
xlabel(this.colNames{ind1});
ylabel(this.colNames{ind2});
if ~isempty(this.name)
    title(this.name);
end

% eventually returns handle to graphics
if nargout>0
    varargout{1} = h;
end