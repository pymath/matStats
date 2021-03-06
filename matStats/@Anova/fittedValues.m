function res = fittedValues(this, factors)
%FITTEDVALUES Compute fitted values for factors or group of factors
%
%   output = fittedValues(input)
%
%   Example
%     % Estimate petal length of each iris species 
%     iris = Table.read('fisherIris');
%     species = iris('Species');
%     anovaPL = Anova(iris('PetalLength'), species);
%     fittedValues(anovaPL, species)
%       ans = 
%                                 fitted.values
%       Species=Setosa                    1.464
%       Species=Versicolor                 4.26
%       Species=Virginica                 5.552
%
%   See also
%     Table/aggregate
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2013-01-29,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

% First compute combinations of factors that exist in factor table
factorCombos = unique(factors);

% Find correspondence between indices of factors and indices in original
% Anova model.
nFactors = size(factors, 2);
groupInds = zeros(1, nFactors);
for i = 1:size(factors, 2)
    groupInds(i) = strmatch(factors.colNames{i}, this.stats.varnames, 'exact');
end

% allocate memory for result
nValues = size(factorCombos, 1);
values = zeros(nValues, 1);
rowNames = cell(nValues, 1);

% Compute fitted value for each combination of factor levels
vars = this.stats.vars;
for c = 1:nValues
    % add intercept
    val = this.stats.coeffs(1);

    % add contribution of first factor
    row = zeros(1, size(vars, 2));
    row(groupInds(1)) = factorCombos(c, 1).data;
    ind = sum(bsxfun(@ne, vars, row), 2) == 0;
    if ~isempty(ind)
        val = val + this.stats.coeffs(ind);
    end

    if nFactors > 1
        % add contribution of second factor
        row = zeros(1, size(vars, 2));
        row(groupInds(2)) = factorCombos(c, 2).data;
        ind = sum(bsxfun(@ne, vars, row), 2) == 0;
        if ~isempty(ind)
            val = val + this.stats.coeffs(ind);
        end
        
        % add interaction
        row = zeros(1, size(vars, 2));
        row(groupInds(1)) = factorCombos(c, 1).data;
        row(groupInds(2)) = factorCombos(c, 2).data;
        ind = sum(bsxfun(@ne, vars, row), 2) == 0;
        if ~isempty(ind)
            val = val + this.stats.coeffs(ind);
        end
            
        % add contributions of third factor (not tested!!)
        if nFactors > 2
            % add contribution of third factor
            row = zeros(1, size(vars, 3));
            row(groupInds(3)) = factorCombos(c, 3).data;
            ind = sum(bsxfun(@ne, vars, row), 2) == 0;
            if ~isempty(ind)
                val = val + this.stats.coeffs(ind);
            end
            
            % add interaction 1-3
            row = zeros(1, size(vars, 2));
            row(groupInds(1)) = factorCombos(c, 1).data;
            row(groupInds(3)) = factorCombos(c, 3).data;
            ind = sum(bsxfun(@ne, vars, row), 2) == 0;
            if ~isempty(ind)
                val = val + this.stats.coeffs(ind);
            end
            
            % add interaction 2-3
            row = zeros(1, size(vars, 2));
            row(groupInds(2)) = factorCombos(c, 2).data;
            row(groupInds(3)) = factorCombos(c, 3).data;
            ind = sum(bsxfun(@ne, vars, row), 2) == 0;
            if ~isempty(ind)
                val = val + this.stats.coeffs(ind);
            end
            
        end
    end
    
    % keep results
    values(c)   = val;
    rowNames(c) = this.stats.coeffnames(ind);
end

res = Table(values, {'fitted.values'}, rowNames);
