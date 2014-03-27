function s = PIPAssignAffiliation_single_author(s)
% s = PIPAssignAffiliation_single_author(s)

s.uni_rank_vect = 1./(log10(s.UniRank)+1);
v = s.uni_rank_vect;

s.uni_rank_mode = mode(v);
s.uni_rank_mean = mean(v);
s.uni_rank_median = median(v);
s.uni_rank_max = max(v);
v = v(v ~= 0);
if isempty(v)
    v = 0;
end
s.uni_rank_onlytop500_mode = mode(v);
s.uni_rank_onlytop500_mean = mean(v);
s.uni_rank_onlytop500_median = median(v);
s.uni_rank_onlytop500_max = max(v);
