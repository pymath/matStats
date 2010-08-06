function indRow = rowIndex(this, rowName)
%ROWINDEX  Index of a row from its name
%
%   IND = TABLE.rowIndex(ROWNAME)
%
%   Example
%   rowIndex
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

errorMsg = 'input table does not contain row named "%s"';

% check index of row
if isnumeric(rowName)
    indRow = rowName;
elseif ischar(rowName)
    indRow = strmatch(rowName, this.rowNames, 'exact');
    if isempty(indRow)>0
        error(errorMsg, rowName);
    end
elseif iscell(rowName)
    N = length(rowName);
    indRow = zeros(N, 1);
    names = this.rowNames;
    for i=1:N
        ind = strmatch(rowName{i}, names, 'exact');
        if isempty(ind)
            error(errorMsg, rowName{i});
        end
        indRow(i) = ind;
    end
else
    error('second argument should be a row name or a row index');
end
