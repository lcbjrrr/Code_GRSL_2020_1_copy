% Coded by Anderson Borba data: 01/07/2020 version 1.0
% Fusion of Evidences in Intensities Channels for Edge Detection in PolSAR Images 
% GRSL - IEEE Geoscience and Remote Sensing Letters 
% Anderson A. de Borba, Maurı́cio Marengoni, and Alejandro C Frery
% 
% Description
% 1) Calculate metricas to Flevoland 
%  
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output 
% 1) Print this information in txt files
% Obs: 1) Prints commands are commented with %  
%      2) Contact email: anderborba@gmail.com
%      3) Change *.txt to Flevoland region II 
clear all;
format long;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd ..
cd Data
ev_hh = load('evidence_flev_hh.txt');
ev_hv = load('evidence_flev_hv.txt');
ev_vv = load('evidence_flev_vv.txt');
xc = load('xc_flevoland.txt');
yc = load('yc_flevoland.txt');
cd ..
cd Code_matlab
num_radial = 25;
for i = 1: num_radial 
ev(i, 1) = round(ev_hh(i, 3));
ev(i, 2) = round(ev_hv(i, 3));
ev(i, 3) = round(ev_vv(i, 3));
end
nc = 3;
m = 750;
n = 1024;
for i = 1: nc
	IM = zeros(m, n, nc);
end
for canal = 1 : nc
	for i = 1: num_radial
        		ik =  ev(i, canal); 
			IM( yc(i, ik), xc(i, ik), canal) = 1;
	end
end
[IF1] = fus_media(IM, m, n, nc);

%LUIZ
GT = zeros(m, n);
cd ..
cd Data
GT = load('gt_flevoland.txt');
cd ..
cd Code_matlab
r = 120;
erro_gt = 0;
nk = 10;
for j = 1: num_radial
	cont_f1 = 0;
	for i = 1: r
		if (yc(j, i) && xc(j, i)) > 0 
			if  GT(yc(j, i), xc(j, i)) > 0
				erro_gt = sqrt(yc(j, i)^2 + xc(j, i)^2);
			end
			if  IF1(yc(j, i), xc(j, i)) > 0
				cont_f1 = cont_f1 + 1;
				erro_aux_f1(cont_f1) = sqrt(yc(j, i)^2 + xc(j, i)^2);
			end
		end
	        minimo_f1 = 100; 
		for c=1: cont_f1
 			d = abs(erro_aux_f1(c) - erro_gt);
			minimo_f1 = min(d, minimo_f1);
		end
	end
	erro_f1(j) = minimo_f1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nk = 10;
freq_f1 = zeros(1, nk + 1); 

for k= 1: nk
	contador_f1 = 0;
	for j = 1: num_radial
		if (erro_f1(j) < k)
			contador_f1 = contador_f1 + 1;
		end
	end
	freq_f1(k + 1) = contador_f1 / num_radial;

end
cd ..
cd Data
fname = sprintf('metricas_fusao_flevoland.txt', canal);
fid = fopen(fname,'w');
for i = 1: nk
    fprintf(fid,'%f ', freq_f1(i));
end
fclose(fid);       
cd ..
cd Code_matlab
