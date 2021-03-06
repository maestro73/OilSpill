
% Script per il calcolo delle features di natura geometrica
% img: Spill oil segmentato

function [ out ] = spillgeom( img )
%% 1. Calcolo del perimetro
[out.Perimeter, perim_img] = spillperim( img );

%% 2. Calcolo dell'area
out.Area = spillarea( img );

%% 3. Calcolo della complessitÓ dell'oggetto
% This feature will take a small numerical value for regions with simple
% geometry and larger values for complex geometrical regions.
out.Complexity = out.Perimeter / (2 * sqrt( pi * out.Area ));

%% 4. Calcolo del FIPM
out.FIPM = spillfipm( img );

%% 5. Calcolo dei parametri basati sull fitting dell'ellisse
% Ellipse Length: value of main axe of an ellipse fitted to the data
% Ellipse Width: value of minor axe of an ellipse fitted to the data.
[ out.EL, out.EW ] = spillellipfit( img );
% Ellipse Asymetry
out.EA = 1 - ( out.EW / out.EL );

%% 6. Length (L): sum of skeleton edges 
% (obtained by Delaunay triangulation),
% that build the main line.

%out.Length = spilldelaunay( img );
out.Length = out.EL; % Approssimazione vista sul paper

% Width (W): mean value of Delaunay triangles 
% which are crossed by main line.
out.Width = out.Area / out.Length;

% Length To Width Ratio (LWR)
out.LWR = out.Length / out.Width;

% Compactness (Comp), defined as
out.Comp = ( out.Length * out.Width ) / out.Area;
