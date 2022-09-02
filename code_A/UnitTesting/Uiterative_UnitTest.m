%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   UNIT TESTING SCRIPT Displacement by Iterative   %%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
%% Load the workspace of the expected results
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\u_iter.mat')

%% Load the workspace of the example properties
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\cParams.mat')

%% Create the objects
Test1 = SolverStructureDirect(cParams); %As SolverStructure is the father of the SolverStructureDirect and SolverStructureItertive. Doesnt matter wich one is used.
Test2 = SolverStructureIterative(cParams); %As SolverStructure is the father of the SolverStructureDirect and SolverStructureItertive. Doesnt matter wich one use.

%% Check in Validation

valKG       = true;
valFext     = true;
valU_dir    = true;
valU_iter   = true;

%% Start the Solver of the objects

solver(Test1);
solver(Test2);

clc
%% Validator

if valU_iter
    if Test2.u == u_iter
        disp('Displacement by iterative method OK!');
    else
        error('ERROR in Displacement by iterative method');
    end
end
clear