function s = GetAuthorHindexUpToPI(s, Vin, Vout, N)
% s = GetAuthorHindexUpToPI(s, Vin, Vout, N)
% add author h-index (Vout) up to N years after start of career for var Vin
% Vin should refer to the variable counting citations
% Vout will be the name of the h-index variable that is added to s
% s is a publication time series structure

if ~exist('N','var')
    N = inf;
end

for I=1:length(s)
    years_since_first_pub = (s(I).DateNums-min(s(I).DateNums))./365.2425;
    ind_N = years_since_first_pub <= N;
    ind = ~s(I).is_PI & (s(I).AuthorPositions ~= s(I).NumAuthors);
    ind(~ind_N) = 0;
    NC = s(I).(genvarname(Vin))(ind);
    NC = sort(NC,'descend');
    x = 1:1:length(NC);
    s(I).(genvarname(Vout)) = sum(NC' >= x);
end


