% Coded by Anderson Borba data: 01/07/2020 version 1.0
% Extract information from Flevoland image to edge detection evidences
% Fusion of Evidences in Intensities Channels for Edge Detection in PolSAR Images 
% GRSL - IEEE Geoscience and Remote Sensing Letters 	
% Anderson A. de Borba, Maurı́cio Marengoni, and Alejandro C Frery
% 
% Description
% 1) Show flevoland with ROI and radial lines (Use show_Pauli)
% 2) Extract information in the 9 channels to radial lines (use Bresenham)
% 3) Print this information in txt files
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output 
% 1) Print this information in txt files
%
% Obs: 1) prints commands are commented with %  
%      2) contact email: anderborba@gmail.com
clc       
clear       
close all 
format long;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load ../Data/AirSAR_Flevoland_Enxuto.mat
[nrows, ncols, nc] = size(S);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AAB
% show_Pauli coded by
% Coded in Matlab by Luis Gomez, July 2018 for getting result shown in:
% (2) D. Santana-Cedrés, L. Gomez, L. Alvarez and A. C. Frery,"Despeckling
% PolSAR images with a structure tensor filter"
% More infomation see function coded
II = show_Pauli(S, 1, 0);
%%%%%%%%%%%%%%%%%%%i%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IT = zeros(nrows, ncols); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROI control
x0 = nrows / 2 + 305;
y0 = ncols / 2 + 20;
% Radial lenght variable
r = 120;
% Set radials
num_radial = 25;
t = linspace(0.5 * pi, pi, num_radial) ;
x = x0 + r .* cos(t);
y = y0 + r .* sin(t);
xr= round(x);
yr= round(y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract Radial
const =  5 * max(max(max(II)));
MXC = zeros(num_radial, r);
MYC = zeros(num_radial, r);
MY  = zeros(num_radial, r, nc);
for i = 1: num_radial
	[myline, mycoords, outmat, XC, YC] = bresenham(IT, [x0, y0; xr(i), yr(i)], 0); 
	for canal = 1 :nc
		Iaux = S(:, :, canal);
		dim = length(XC);
		for j = 1: dim
			MXC(i, j) = YC(j);
			MYC(i, j) = XC(j);
			MY(i, j, canal)  = Iaux( XC(j), YC(j)) ;
	       		IT(XC(j), YC(j)) = const;
	       		II(XC(j), YC(j)) = const;
        	end
	end
end
imshow(II);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print radials

for canal = 1: nc 
	fname = sprintf('../Data/flevoland_%d.txt', canal);
	fid = fopen(fname,'w');
	for i = 1: num_radial
		for j = 1: r
                fprintf(fid,'%f ',MY(i, j, canal));
	      	end
    		fprintf(fid,'\n');
        end
        fclose(fid);       
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% command print (xc, yc)
	fnamexc = sprintf('../Data/xc_flevoland.txt');
	fnameyc = sprintf('../Data/yc_flevoland.txt');
	fidxc = fopen(fnamexc,'w');
	fidyc = fopen(fnameyc,'w');
        for i = 1: num_radial
		for j = 1: r
	                fprintf(fidxc,'%f ', MXC(i,j));
	                fprintf(fidyc,'%f ', MYC(i,j));
	      	end
    		fprintf(fidxc,'\n');
    		fprintf(fidyc,'\n');
	end
	fclose(fidxc);       
	fclose(fidyc);       


