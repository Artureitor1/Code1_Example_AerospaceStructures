%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   UNIT TESTING SCRIPT Global   %%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
close all
%% Load the workspace of the expected results
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\KG.mat');
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\Fext.mat');
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\u_dir.mat');
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\u_iter.mat');

%% Load the workspace of the example properties
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\cParams.mat');


%% Create the objects
cParams.method  = "direct";
Test1 = StructureComputer(cParams);
cParams.method  = "iterative";
Test2 = StructureComputer(cParams);

%% Check in Validation

valKG       = true;
valFext     = true;
valU_dir    = true;
valU_iter   = true;

%% Start the Solver of the objects

Test1.compute();
Test2.compute();


%% Validator
if valKG
    if Test1.stifnessMatrix == KG 
        fprintf('{Stifness matrix}');cprintf('_green', '{true}');disp('|');
    else
        fprintf('{Stifness matrix}');cprintf('_red', '{false}');disp('|');
    end
end

if valFext
    if Test1.externalForces == Fext
        fprintf('{External forces}');cprintf('_green', '{true}');disp('|');
    else
        fprintf('{External forces}');cprintf('_red', '{false}');disp('|');
    end
end

if valU_dir
    if Test1.displacement == u_dir
        fprintf('{Displacement}{Direct Method}');cprintf('_green', '{true}');disp('|');
    else
        fprintf('{Displacement}{Direct Method}');cprintf('_red', '{false}');disp('|');
    end
end

if valU_iter
    if Test2.displacement == u_iter
        fprintf('{Displacement}{Iterative Method}');cprintf('_green', '{true}');disp('|');
    else
        fprintf('{Displacement}{Iterative Method}');cprintf('_red', '{false}');disp('|');
    end
end
