%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   UNIT TESTING SCRIPT Stifness Matrix  %%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
close all
%% Load the workspace of the expected results
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\KG.mat');

%% Load the workspace of the example properties
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\cParams.mat');
cParams.method  = "direct";

%% Create the objects
Test1 = StructureComputer(cParams);

%% Start the Solver of the objects
Test1.compute();

%% Validator
if Test1.stifnessMatrix == KG
    fprintf('{Stifness matrix}');cprintf('_green', '{true}');disp('|');
else
    fprintf('{Stifness matrix}');cprintf('_red', '{false}');disp('|');
end

