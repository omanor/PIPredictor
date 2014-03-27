function s = PIPAddFeaturesUpToYearN_var(s, N, V)
% s = PIPAddFeaturesUpToYearN_var(s, N, V)
% add statistics to struct s through year N for variable V

%try %if s.(V) is the wrong direction, need to horzcat() it first
%    var_bins = prctile( vertcat(s_full.(V)), linspace(0,100,6));
%catch
%    var_bins = prctile( vertcat([s_full.(V)]) , linspace(0,100,6));
%    s.(V) = reshape(s.(V),[],1);
%end
%var_bins = [0 var_bins(1:end-1)];


switch V
	case 'JIF'
		var_bins = [2 3 4 6 8];
	case 'NumAuthors'
		var_bins = [3 4 5 7 9];
	case 'n_citations'
		var_bins = [1 2 3 5 11];
% 	case 'cite_per_IF'
% 		var_bins = [1 2 3 5 11];
	case 'log_cite_per_IF'
		var_bins = [-2 -1 -1 0 1];
	otherwise
		var_bins = linspace(1,10,5);
end


for I=1:length(s)

	% assume that the entries in s are soted by DateNums

%	disp([num2str(I/length(s)*100,3) '%']);
	% sort by date
	%[~,ind] = sort(s(I).DateNums);
	%fn = fieldnames(s);
	%s(I).DateNums = s(I).DateNums(ind);
	%s(I).PMIDs = s(I).PMIDs(ind);
	%s(I).(V) = s(I).(V)(ind);
	%s(I).AuthorPositions = s(I).AuthorPositions(ind);
	%if any(strcmp('Authors',fn)); s(I).Authors = s(I).Authors(ind); end
	%if any(strcmp('ISSN',fn)); s(I).ISSN = s(I).ISSN(ind); end
	%if any(strcmp('ISSN',fn)); s(I).ISSN = s(I).ISSN(ind); end
	%s(I).is_PI = s(I).is_PI(ind);
	%s(I).NumAuthors = s(I).NumAuthors(ind);
	% time from start
	years_since_first_pub = (s(I).DateNums-min(s(I).DateNums))./365.2425;
	for J = N
        Jstr = num2str(J);
        s(I).AuthorPositions = s(I).AuthorPositions(:);
        s(I).NumAuthors = s(I).NumAuthors(:);
		ind_time = years_since_first_pub <= J & ~s(I).is_PI(:) & (s(I).AuthorPositions ~= s(I).NumAuthors);
		%ind_time = years_since_first_pub' <= J & ~s(I).is_PI; % time until J or until PI, whichever comes first
		active_science_time = max(years_since_first_pub(ind_time));
		VAR = s(I).(V)(ind_time)';
		AP = s(I).AuthorPositions(ind_time);
		NA = s(I).NumAuthors(ind_time);
%		PMID = s(I).PMIDs(ind_time);
% 		% PMID
% 		PMID_all = PMID;
% 		PMID_as_first = PMID(AP==1 & NA>1);
% 		PMID_as_second = PMID(AP==2 & NA>2);
% 		PMID_as_middle = PMID(AP>=3 & AP<NA);
		% VAR
		VAR_all = [VAR nan];
		VAR_as_first = [VAR(AP==1 & NA>1) nan];
		VAR_as_second = [VAR(AP==2 & NA>2) nan];
		VAR_as_middle = [VAR(AP>=3 & AP<NA) nan];
		% max VAR
		s(I).(['max' V '_ty_' Jstr]) = nanmax(VAR_all);
		s(I).(['max' V '_as_first_ty_' Jstr]) = nanmax(VAR_as_first);
		s(I).(['max' V '_as_second_ty_' Jstr]) = nanmax(VAR_as_second);
		s(I).(['max' V '_as_middle_ty_' Jstr]) = nanmax(VAR_as_middle);
		% mean VAR
		s(I).(['mean' V '_ty_' Jstr]) = nanmean(VAR_all);
		s(I).(['mean' V '_as_first_ty_' Jstr]) = nanmean(VAR_as_first);
		s(I).(['mean' V '_as_second_ty_' Jstr]) = nanmean(VAR_as_second);
		s(I).(['mean' V '_as_middle_ty_' Jstr]) = nanmean(VAR_as_middle);
		% sum VAR
		%s(I).(['sum' V '_ty_' Jstr '_since_start']) = nansum(VAR_all);
		%s(I).(['sum' V '_as_first_ty_' Jstr '_since_start']) = nansum(VAR_as_first);
		%s(I).(['sum' V '_as_second_ty_' Jstr '_since_start']) = nansum(VAR_as_second);
		%s(I).(['sum' V '_as_first_or_second_ty_' Jstr '_since_start']) = nansum(VAR_as_first_or_second);
		%s(I).(['sum' V '_as_middle_ty_' Jstr '_since_start']) = nansum(VAR_as_middle);

    		% IF greater than X
            for Q = var_bins
                QS = strrep( strrep(num2str(Q),'-','min') , '.' , '_') ;
                %  normalized by active_science_time, sum var
                s(I).(['sum' V '_ial_' (QS) '_ty_' Jstr '_py']) = nansum(VAR_all(VAR_all>=Q)) ./ active_science_time;
                s(I).(['sum' V '_ial_' (QS) '_as_first_ty_' Jstr '_py']) = nansum(VAR_as_first(VAR_as_first>=Q)) ./ active_science_time;
                s(I).(['sum' V '_ial_' (QS) '_as_second_ty_' Jstr '_py']) = nansum(VAR_as_second(VAR_as_second>=Q)) ./ active_science_time;
                s(I).(['sum' V '_ial_' (QS) '_as_middle_ty_' Jstr '_py']) = nansum(VAR_as_middle(VAR_as_middle>=Q)) ./ active_science_time;
                
                % not normalize by active time, npubs
                s(I).(['np_' V '_ial_' (QS) '_ty_' Jstr]) = nansum(VAR_all >= Q);
                s(I).(['np_' V '_ial_' (QS) '_as_first_ty_' Jstr]) = nansum(VAR_as_first >= Q);
                s(I).(['np_' V '_ial_' (QS) '_as_second_ty_' Jstr]) = nansum(VAR_as_second >= Q);
                s(I).(['np_' V '_ial_' (QS) '_as_middle_ty_' Jstr]) = nansum(VAR_as_middle >= Q);
                
                %  normalized by active_science_time, npubs
                s(I).(['np_' V '_ial_' (QS) '_ty_' Jstr '_py']) = nansum(VAR_all >= Q) ./ active_science_time;
                s(I).(['np_' V '_ial_' (QS) '_as_first_ty_' Jstr '_py']) = nansum(VAR_as_first >= Q) ./ active_science_time;
                s(I).(['np_' V '_ial_' (QS) '_as_second_ty_' Jstr '_py']) = nansum(VAR_as_second >= Q) ./ active_science_time;
                s(I).(['np_' V '_ial_' (QS) '_as_middle_ty_' Jstr '_py']) = nansum(VAR_as_middle >= Q) ./ active_science_time;
            end
	end
end




