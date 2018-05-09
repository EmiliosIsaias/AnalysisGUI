% binned average of x y data

function [bins1 m1 s1 X Y]=binnedMean(x,y,bins)

X={};
Y={};
for i=1:(numel(bins)-1)
    
    indices=find(x>bins(i) & x<=(bins(i+1)));
    
    m1(i)=mean(y(indices));
    s1(i)=std(y(indices));
    X{i}=x(indices);
    Y{i}=y(indices);
    bins1(i)=mean(x(indices));
end