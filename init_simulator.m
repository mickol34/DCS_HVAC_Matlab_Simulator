clear all;
load('tfDys.mat');
load('lagDys.mat');

kMax = 50;
global HL; HL = zeros(1,kMax);
global HR; HR = zeros(1,kMax);
global FLU; FLU = 30 * ones(1,kMax);
global FRU; FRU = 30 * ones(1,kMax);

global TLamb; TLamb = 22.7;
global TRamb; TRamb = 23.5;

global TLhl3030; global TLhl3090; global TLhl9030; global TLhl9090;
TLhl3030 = zeros(1,kMax); TLhl3090 = zeros(1,kMax); TLhl9030 = zeros(1,kMax); TLhl9090 = zeros(1,kMax);
global TLhr3030; global TLhr3090; global TLhr9030; global TLhr9090;
TLhr3030 = zeros(1,kMax); TLhr3090 = zeros(1,kMax); TLhr9030 = zeros(1,kMax); TLhr9090 = zeros(1,kMax);
global TRhl3030; global TRhl3090; global TRhl9030; global TRhl9090;
TRhl3030 = zeros(1,kMax); TRhl3090 = zeros(1,kMax); TRhl9030 = zeros(1,kMax); TRhl9090 = zeros(1,kMax);
global TRhr3030; global TRhr3090; global TRhr9030; global TRhr9090;
TRhr3030 = zeros(1,kMax); TRhr3090 = zeros(1,kMax); TRhr9030 = zeros(1,kMax); TRhr9090 = zeros(1,kMax);


global FLUlagtl; global FRUlagtr; global FLUlagtr; global FRUlagtl;
FLUlagtl = zeros(1,kMax); FRUlagtr = zeros(1,kMax); FLUlagtr = zeros(1,kMax); FRUlagtl = zeros(1, kMax);
FLUlagtl(1:kMax) = 30; FRUlagtr(1:kMax) = 30; FLUlagtr(1:kMax) = 30; FRUlagtl(1:kMax) = 30;

