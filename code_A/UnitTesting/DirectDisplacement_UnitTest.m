%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   UNIT TESTING SCRIPT Displacement by Direct Solver %%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
close all
%% Load the workspace of the expected results
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\u_dir.mat');

%% Load the workspace of the example properties
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\cParams.mat');
cParams.method  = "direct";

%% Create the objects
Test1 = StructureComputer(cParams);

%% Start the Solver of the objects
Test1.compute();

%% Validator
if Test1.displacement == u_dir
    fprintf('{Displacement}{Direct Method}');cprintf('_green', '{true}');disp('|');
else
    fprintf('{Displacement}{Direct Method}');cprintf('_red', '{false}');disp('|');
end



