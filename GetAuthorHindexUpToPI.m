function s = GetAuthorHindexUpToPI(s, Vin, Vout, N)
% s = GetAuthorHindexUpToPI(s, Vin, Vout)
% add author h-index (Vout) up to pi for var Vin
% up to N years after first publication

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


