%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   UNIT TESTING SCRIPT Displacement by Iterative Solver %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
close all
%% Load the workspace of the expected results
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\u_iter.mat');

%% Load the workspace of the example properties
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\cParams.mat');
cParams.method  = "iterative";

%% Create the objects
Test2 = StructureComputer(cParams);

%% Start the Solver of the objects
Test2.compute();

%% Validator
if Test2.displacement == u_iter
    fprintf('{Displacement}{Iterative Method}');cprintf('_green', '{true}');disp('|');
else
    fprintf('{Displacement}{Iterative Method}');cprintf('_red', '{false}');disp('|');
end
