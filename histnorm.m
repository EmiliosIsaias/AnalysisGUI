
function [H bins]=histnorm(X,mybins);

H=[];

if size(X,2)~=1,X=X';end


try
    [h bins]=hist(cell2mat(X),mybins);
catch
    [h bins]=hist(cell2mat(X'),mybins);
end

for i=1:numel(X)
    H(:,i)=hist(X{i}, bins)/numel(X{i});
end


