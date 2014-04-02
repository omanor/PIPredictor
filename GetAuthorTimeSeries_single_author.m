function s = GetAuthorTimeSeries_single_author(TabF_reduced_file, surname)
% s = GetAuthorTimeSeries_single_author(TabF_reduced_file, surname)
%
% returns publication timeseries structure given:
%  TabF_reduced_file - see run_model.m documentation
%  surname

%% load pubmed records for single authos
fid = fopen(TabF_reduced_file);
% PMID | ISSN | CreatedDate | JournalDate | JournalTitle | ArticleTitle | UniRank | AuthorList | PublicationType | n_citations | Impact Factor | 5-Year Impactor Factor | Immediacy Index | Cited Half-life | EigenfactorTM Score | Article InfluenceTM Score | JournalRanking | SJR | Journal H index | Cites / Doc. (2years)
C = textscan(fid,'%f %s %s %s %s %s %f %s %s %f %f %f %f %f %f %f %f %f %f %f','delimiter','\t','BUFSIZE',49600,'Headerlines',1);
fclose(fid);

% clean uninteresting publication types
%C{9} =  regexprep(C{9},'Journal Article;','');

% sort C by time
[~, ind] = sort(datenum(C{3},'yyyy;mm;dd'));
for I = 1:length(C)
        C{I} = C{I}(ind);
end

%% clear('C');
%s = struct('DateNums',[],'Journals',{},'Affiliations',{},'AuthorPositions',[],'NumAuthors',[],'PublicationTypes',{},'PMIDs',[],'Name','', ...
%'JIF',[],'JIF_5year',[],'Immediacy_Index',[],'Eigenfactor_Score',[],'Article_Influence_Score',[],'SJR',[],'Journal_H_index',[],'Cites_per_Doc_2_years',[]);

s.PMIDs = C{1};
%s.ISSN = C{2};
s.DateNums = datenum(C{3},'yyyy;mm;dd');
%s.Journals = C{5};
%s.Titles = C{6};
s.UniRank = C{7};
s.Authors = C{8};
%s.PublicationTypes = C{9};
s.n_citations = C{10};
s.JIF = C{11};
s.JIF_5year = C{12};
%s.Immediacy_Index = C{13};
%s.Cited_Half_life = C{14};
%s.Eigenfactor_Score = C{15};
%s.Article_Influence_Score = C{16};
%s.JournalRanking = C{17};
%s.SJR = C{18};
%s.Journal_H_index = C{19};
s.Cites_per_Doc_2_years = C{20};

% todo: fuzzy name search in case names are not all the same spelling

s.AuthorPositions = ( cellfun(@(x)find(regexpcmp(x,lower(surname)),1,'first'),  splitString(lower(s.Authors),';')))'; %author pos %first
s.NumAuthors =  ( cellfun(@(x)length(x), splitString(s.Authors,';')))'; %total number of authors
s.Name = surname;


