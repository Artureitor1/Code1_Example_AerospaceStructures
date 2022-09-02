%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   UNIT TESTING SCRIPT Displacement by Direct   %%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
%% Load the workspace of the expected results
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\u_dir.mat')

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

if valU_dir
    if Test1.u == u_dir
        disp('Displacement by direct method OK!');
    else
        error('ERROR in Displacement by direct method');
    end
end

clear