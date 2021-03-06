function [mask] = importBNAdata()
GNOME_BNA='Philippine coast.bna';

fileID = fopen(GNOME_BNA,'r');




% Read Each Block
% For each block, we want to read a header, the numeric value m, column headers for the data, 
% then the data itself. 
% First, initialize the block index.

Block = 1;



while (~feof(fileID))                               % For each block:

   %fprintf('Block: %s\n', num2str(Block))           % Print block number to the screen
   InputText = textscan(fileID,'%s',1,'delimiter','\n');  % Read 1 header lines
   HeaderLines{Block,1} = InputText{1};
   %disp(HeaderLines{Block});                        % Display header lines

   %InputText = textscan(fileID,'Num SNR = %f');     % Read the numeric value
                                                    % following the text, Num SNR =
   %NumCols = InputText{1};                          % Specify that this is the
                                                    % number of data columns
   NumCols = 2;   
   FormatString = repmat('%f',1,NumCols);           % Create format string
                                                    % based on the number
                                                    % of columns
   InputText = textscan(fileID,FormatString, ...    % Read data block
      'delimiter',',');

   Data{Block,1} = cell2mat(InputText);
   [NumRows,NumCols] = size(Data{Block});           % Determine size of table
   %disp(cellstr(['Table data size: ' ...
      %num2str(NumRows) ' x ' num2str(NumCols)]));
   %disp(' ');                                       % New line

   %eob = textscan(fileID,'%s',1,'delimiter','\n');  % Read and discard end-of-block marker
   Block = Block+1;                                 % Increment block index
end

for k=1:size(Data,1)
    
   XYbound=Data{k};
   
 B = (any(XYbound(1,:)-XYbound(end,:)));
 if B==0
 %patch(XYbound(:,1),XYbound(:,2),[0.5 0.5 0.5]);   
 
 else
  %% close boundary
 XYbound1=[XYbound;XYbound(1,:)];
  
 
 end   
    
    
end

CellDataScene=Data;

scaleFactor = 14.5457;
dlon=0.00980/scaleFactor;
dlat=0.00980/scaleFactor;

RisKM=deg2km(dlon);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% costruzione dei limiti long e limiti lat per la scena caricata
clear LON_LATmin
clear LON_LATmax

for kk=1:size(Data,1)
 XYbound=Data{kk};  
 
  xymin=min(XYbound);
  
  xymax=max(XYbound);
  
  LON_LATmin(kk,:)=xymin;
  LON_LATmax(kk,:)=xymax;
  
  
end

minLON_LAT=min(LON_LATmin);
maxLON_LAT=max(LON_LATmax);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% stima delle dimensioni del raster in base al range di lat lon
Ncol=round((maxLON_LAT(1)-(minLON_LAT(1)))/dlon)+1;
Nrow=round((maxLON_LAT(2)-minLON_LAT(2))/dlat)+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% costruzione del raster corrispondente alla BNA scene
clear MaskBNAscene
MaskBNAscene=zeros(Nrow,Ncol);

%% mapping delle land aree sul raster
%k=10
Precision=100*scaleFactor;

for k=1:size(Data,1)
    %CurrentPatchMask=zeros(size(MaskBNAscene));
    
 XYbound=Data{k};  
 B = (any(XYbound(1,:)-XYbound(end,:)));
 if B==0
 x=XYbound(:,1);
 y=XYbound(:,2);
 
 x1=x-minLON_LAT(1);
 y1=y-minLON_LAT(2);
 
x1 = round(x1*Precision) + 1;
y1 = round(y1*Precision) + 1;
 
 CurrentPatchMask=poly2mask(x1,y1, Nrow, Ncol);
 CurrentPatchMask=flipud(CurrentPatchMask);
 
 Ion=find(CurrentPatchMask>0);
 MaskBNAscene(Ion)=1;
%   xymin=min(XYbound)
%   
%   xymax=max(XYbound)
%   
%   LON_LATmin(kk,:)=xymin;
%   LON_LATmax(kk,:)=xymax;
  
clear CurrentPatchMask
 end
end

Ion=find(MaskBNAscene>0);
MaskBNAscene(Ion)=1;

MaskBNAscene=imcomplement(MaskBNAscene);
mask=(MaskBNAscene==1);