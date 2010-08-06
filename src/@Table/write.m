function varargout = write(this, fileName, varargin)
%WRITE Write a datatable into a file
%
%   TABLE.write(COLNAME)
%   where TABLE is a Table object, and COLNAME is either index or name of 
%   a column of the table.
%
%   tableWrite(..., FORMAT);
%   tableWrite(..., 'format', FORMAT);
%   Also provides writing format for variable. FORMAT is a string
%   containing series of C-language based formatting tags, such as:
%   '%5.3f %3d %6.4f %02d %02d'. Number of formatting tags must equals
%   number of columns of data table.
%   FORMAT can also end with '\n', and begin with '%s '. Following formats
%   are equivalent for tableWrite:
%   '%5.2f %3d %3d'
%   '%s %5.2f %3d %3d'
%   '%5.2f %3d %3d\n'
%   '%s %5.2f %3d %3d\n'
%
%   Example
%   write
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% process input

% extrat format for writing data
format = [];
writeLevels = false;
while length(varargin)>1
    var = lower(varargin{1});
    switch var
        case 'format'
            format = varargin{2};
        case 'writelevels'
            writeLevels = varargin{2};
        otherwise
            error(['unknown parameter: ' varargin{1}]);
    end
    varargin(1:2) = [];
end

% extract format if there only one argument left
if ~isempty(varargin)
    format = varargin{1};
end


%% Prepare data of the table for writing 

% compute default format string for writing data, if not given as argument
if isempty(format)
    format = [repmat(' %g', 1, length(this.colNames)) '\n'];
end

% check which columns are factors, and update format string accordingly
if writeLevels
    isFactor = false(length(this.levels), 1);
    for i=1:length(this.levels)
        isFactor(i) = ~isempty(this.levels{i});
    end
    
    % extract format tokens
    formats = textscan(format, '%s');
    formats = formats{1};
    
    
    % replace double format by string format
    inds = find(isFactor);
    for i=1:length(inds)
        % compute max length of level names
        n=-1;
        levels = this.levels{inds(i)}; 
        for j=1:length(levels)
            n = max(n, length(levels{j}));
        end

        formats(inds(i)) = {['%' num2str(n) 's']};
    end
    
    % create new format string
    format = formats{1};
    sep = ' ';
    for i=2:length(this.colNames)
        format = [format sep formats{i}]; %#ok<AGROW>
    end
end


%% Ensure the format string is valid

% check the presence of '%s' in the beginning, and '\n' at the end

% count number of tokens
tokens = textscan(format, '%s');
n = length(tokens{1});

% add '%s ' in the beginning if missing
if n~=size(this.data, 2)+1
    len=-1;
    for i=1:length(this.rowNames)
        len = max(len, length(this.rowNames{i}));
    end

    format = ['%-' num2str(len) 's ' format];
end

% add '\n' if missing
if ~strcmp(format(end-1:end), '\n')
    format = [format '\n'];
end


%% Write into file

% open file
f = fopen(fileName,'wt');
if (f==-1)
	error('Couldn''t open the file %s', fileName);
end;

% write the names of the columns, separated by spaces
str = this.name;
sep = '   ';
for i=1:length(this.colNames)
    str = [str sep this.colNames{i}]; %#ok<AGROW>
end
str = [str '\n'];
fprintf(f, str);

% write each row of data
if writeLevels
    data = cell(1, length(this.colNames));
    inds = find(isFactor);
    for i=1:length(this.rowNames)
        for j=1:length(inds)
            data{inds(j)} = this.levels{inds(j)}{this.data(i, inds(j))};
        end
        if sum(~isFactor)>0
            data(~isFactor) = num2cell(this.data(i, ~isFactor));
        end
        fprintf(f, sprintf(format, this.rowNames{i}, data{:}));
    end
else
    for i=1:length(this.rowNames)
        fprintf(f, sprintf(format, this.rowNames{i}, this.data(i, :)));
    end
end

% close the file
fclose(f);