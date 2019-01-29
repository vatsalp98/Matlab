%
%  ca2_demo.m -- timing exercise (macm316, hl -- 13 jan 2019)
%
% Purpose:      This script serves as a demo for students to build on in
%               completing computing assignment 2. This script builds three types
%               of NxN matricies: dense, upper triangular, and permuted upper
%               triangular. It then performs a matrix solve with each, Nex number
%               of times. The time it takes for Nex number of solves is used to
%               estimate the time of one solve .  
%
% Instructions: Start by running the script once, and see the
%               output for the esimtated times. Note: the choice of Nex here may
%               not give accurate results for all three matrix types. Next, copy
%               and paste this code into your own Matlab
%               file. Follow the assignment sheet for further instructions to
%               complete your report. 

%  experimental parameters

avgTimeDense = [];
avgTimeUpper = [];
avgTimePUpper = [];
avgTimeDiag = [];
avgTimeSparse = [];

Nexmatrix = [100 3000 5000];

Nmatrix = [200 300 400 500 600 700 800 900 1000 2000];

for temp1 = 1:10
    
N   = Nmatrix(temp1);
NexD = Nexmatrix(1);
NexU = Nexmatrix(3);
NexPU = Nexmatrix(2);

%  three matrix types

%  dense matrix (no zeros)
Md = randn(N,N); 

%  upper triangular
Mt = triu(Md); 

%  randomly row-exchanged upper triangular (these are tricky array commands, 
%  but if you run a small sample, it is clear they do the right thing)
idx=randperm(N); 
Mp = Mt(idx,:); 

%Tri-diagonal and sparse tri-diagonal
M3 = diag(diag(Md))+diag(diag(Md,-1),-1)+diag(diag(Md,1),1);
M3s = sparse(Mt)

%  exact solution of all ones
x = ones(N,1);

%  right-side vectors
bd = Md*x;
bt = Mt*x;
bp = bt(idx);

ds = M3*x;
dss = M3s*x;

%  dense test
tic 
for jj = 1:NexD
    xd = Md\bd;
end
dense_time=toc;

%  upper tri test
tic
for jj = 1:NexU
    xt = Mt\bt;
end
tri_time=toc;

% permuted upper tri test  
tic
for jj = 1:NexPU
    xp = Mp\bp;
end
perm_tri_time=toc;

%diagonal matrix
tic
for jj = 1:NexD
    xds = M3\ds;
end
diagonal_time = toc;

%sparse Matrix 
tic
for jj = 1:NexD
    xdss = M3s\dss;
end
sparse_time = toc;

%Computing avgerage solve times
avg_tri_time = tri_time/(NexU);
avgTimeUpper = [avgTimeUpper avg_tri_time];

avg_perm_time = perm_tri_time/(NexPU);
avgTimePUpper = [avgTimePUpper avg_perm_time];

avg_dense_time = dense_time/(NexD);
avgTimeDense = [avgTimeDense avg_dense_time];

avg_diag_time = diagonal_time/(NexD);
avgTimeDiag = [avgTimeDiag avg_diag_time];

avg_sparse_time = sparse_time/(NexD);
avgTimeSparse = [avgTimeSparse avg_sparse_time];


% You may find the following code helpful for displaying the results 
% of this demo.
type_times = {'Dense',avg_dense_time,'Upper Triangular', ...
              avg_tri_time,'permuted Upper Triangular', ...
              avg_perm_time, 'Diagonal', avg_diag_time, ...
              'sparse', avg_sparse_time};
fprintf(' \n')
fprintf('Estimated time for a %s matrix is %f seconds. \n',type_times{:})

end

%getting the polyfit for every matrix types
p1 = polyfit(log10(Nmatrix), log10(avgTimeDense), 1);
p2 = polyfit(log10(Nmatrix), log10(avgTimeUpper), 1);
p3 = polyfit(log10(Nmatrix), log10(avgTimePUpper), 1);
p4 = polyfit(log10(Nmatrix), log10(avgTimeDiag), 1);
p5 = polyfit(log10(Nmatrix), log10(avgTimeSparse), 1);

figure(1); clf; hold on;
grid on;
xlabel('N matrix Size');
ylabel('Time');

y1fit = polyval(p1, log10(Nmatrix));
plot(log10(Nmatrix), y1fit, 'r');

y2fit = polyval(p2, log10(Nmatrix));
plot(log10(Nmatrix), y2fit, 'b');

y3fit = polyval(p3, log10(Nmatrix));
plot(log10(Nmatrix), y3fit, 'g');

y4fit = polyval(p4, log10(Nmatrix));
plot(log10(Nmatrix), y4fit, 'y');

y5fit = polyval(p5, log10(Nmatrix));
plot(log10(Nmatrix), y5fit, 'c');

plot(log10(Nmatrix), log10(avgTimeDense), 'ro');
plot(log10(Nmatrix), log10(avgTimeUpper), 'bo');
plot(log10(Nmatrix), log10(avgTimePUpper), 'go');
plot(log10(Nmatrix), log10(avgTimeDiag), 'yo');
plot(log10(Nmatrix), log10(avgTimeSparse), 'co');

