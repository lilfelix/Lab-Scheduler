include "globals.mzn";
array[1..9,1..9] of var 1..9 : puzzle;

% In all columns, all values different
constraint forall (col in 1..9) (
   all_different (row in 1..9) (puzzle[row, col]) :: domain
);

% In all rows, all values different
constraint forall (row in 1..9) (
   all_different (col in 1..9) (puzzle[row, col]) :: domain
);

% In all squares, all values different
constraint forall (row,col in {1,4,7}) (
   all_different (i,j in 0..2) (puzzle[row+i, col+j]) :: domain
);

solve satisfy;

output [ 
   show(puzzle[i,j]) ++ if j = 9 then "\n" else " " endif | i,j in 1..9
];
