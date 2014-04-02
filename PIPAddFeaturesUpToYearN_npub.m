function s = PIPAddFeaturesUpToYearN_npub(s, N)
% s = PIPAddFeaturesUpToYearN_npub(s, N)
% add number of publication (count and rate) statistics to struct s through year N

for I=1:length(s)
%	disp([num2str(I/length(s)*100,3) '%']);
	
	% assume sorted
	
	% sort by date
	%[~,ind] = sort(s(I).DateNums);
	%s(I).DateNums = s(I).DateNums(ind);
	%s(I).PMIDs = s(I).PMIDs(ind);
	%s(I).AuthorPositions = s(I).AuthorPositions(ind);
	%s(I).is_PI = s(I).is_PI(ind);
	%s(I).NumAuthors = s(I).NumAuthors(ind);
	
	% time from start
	years_since_first_pub = (s(I).DateNums-min(s(I).DateNums))./365.2425;
	for J=N
        Jstr = num2str(J);
        s(I).AuthorPositions = reshape( s(I).AuthorPositions , size(s(I).NumAuthors) );
		ind_time = years_since_first_pub' <= J & ~s(I).is_PI & (s(I).AuthorPositions ~= s(I).NumAuthors)';
		%ind_time = years_since_first_pub' <= J & ~s(I).is_PI; % time until J or until PI, whichever comes first
                active_science_time = max(years_since_first_pub(ind_time));
		if isempty(active_science_time)
			active_science_time = nan;
		end
		AP = s(I).AuthorPositions(ind_time);
		NA = s(I).NumAuthors(ind_time);
		PMID = s(I).PMIDs(ind_time);
		% PMID
		PMID_all = PMID;
		PMID_as_first = PMID(AP==1 & NA>1);
		PMID_as_second = PMID(AP==2 & NA>2);
		PMID_as_middle = PMID(AP>=3 & AP<NA);
		% npubs
		s(I).(genvarname(['np_ty_' Jstr])) = length(PMID_all);
		s(I).(genvarname(['np_as_first_ty_' Jstr])) = length(PMID_as_first);
		s(I).(genvarname(['np_as_second_ty_' Jstr])) = length(PMID_as_second);
		s(I).(genvarname(['np_as_middle_ty_' Jstr])) = length(PMID_as_middle);
		% norm by active time           fix empty!!!!!!!!!!!!!!!!!!!!
		s(I).(genvarname(['np_ty_' Jstr '_py'])) = length(PMID_all) ./ active_science_time;
		s(I).(genvarname(['np_as_first_ty_' Jstr '_py'])) = length(PMID_as_first) ./ active_science_time;
		s(I).(genvarname(['np_as_second_ty_' Jstr '_py'])) = length(PMID_as_second) ./ active_science_time;
		s(I).(genvarname(['np_as_middle_ty_' Jstr '_py'])) = length(PMID_as_middle) ./ active_science_time;
	end
end




