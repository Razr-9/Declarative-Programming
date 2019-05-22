% COMP90048 Declarative Programming
% File: Project 2 
% Author: Runze Nie 
% LoginID: runzen 
% StudentID: 956690

% ------------------------------------------------------------------------------

/* 
Introduction: 

This program is to solve a maths puzzle which 
is a square grid of squares, each to be filled in with a single 
digit 1-9.

The programs using a main function puzzle_solution/1 to solve the  
problem which includes three main steps in total. Including check 
if the matrix is valid, then handle the diagonales, find the 
solutions conform to the rules and assign them.
*/

% for using function transpose/2, sum/3， #=/2 and label/1
:- use_module(library(clpfd)).

/* 
puzzle_solution/1,

The main function of this program to solve the puzzles.

Firstly, takes a list of lists named Puzzles as input and 
get columns with transpose/2, then make sure the length 
of rows is equal to the length of columns and each row 
in the puzzles has the same length. 

After, seprate the solutions from the puzzles and find 
the diagonales then make sure they are all same.

Finally, take all rows and columns to be solved together 
and check them with the rules, including check if they are  
valid and their sums or products are equal to the headings.
#=/2 is used to help the calculation to trackback to find 
the solutions. Then assign the values to each elements in 
Puzzles with label/1.

transpose/2, #=/2 and label/1 are from library clpfd
*/
puzzle_solution(Puzzles) :-
    transpose(Puzzles, Columns),
    length(Puzzles, LenPuzzles),
    length(Columns, LenColumns),
    Puzzles=[_|TailPuzzles],
    LenPuzzles#=LenColumns,
    maplist(same_length(Puzzles), Puzzles),
    headings(TailPuzzles, Solutions),
    diagonales(Solutions, Diagonales),
    Diagonales ins 1..9,
    all_same(Diagonales),
    Columns=[_|TailColumns],
    append(TailPuzzles, TailColumns, AllSituations),
    all_valid(AllSituations),
    handle_puzzles(AllSituations),
    maplist(label, Puzzles).

/* 
headings/2,

A function to seprate the Solutions part out of the Puzzles
with recursions.

The first element is a list of lists means Puzzles without the 
first row, and the second one is a list means Solutions part.
*/
headings([], []).
headings([[_|Solution]|Tail], [Solution|OtherSolutions]) :-
    headings(Tail, OtherSolutions).

/* 
diagonales/2,

A function to find the diagonales of a matrix.  

The first element means the matrix and the second one means 
a list of diagonales.
*/
diagonales([], []).
diagonales([[Diagonale|_]|MatrixTail], [Diagonale|OtherDiagonales]) :-
    maplist(list_tail, MatrixTail, MT),
    diagonales(MT, OtherDiagonales).

% get the tail of a list 
list_tail([_|Tail], Tail).

/* 
all_same/1,

A function to make sure all diagonales are same. 

The element will be a list of numbers from diagonales/2
*/
all_same([_]).
all_same([X1, X2|Xs]) :-
    (   X1=X2
    ->  all_same([X2|Xs])
    ).

/* 
all_valid/1,

A function to check if the Solutions (except the heading) are all 
valid.

The element means each row or column, constitutes headings and 
solutions.

Including check if it is a single number in 1 to 9 and if they 
are all distinct or not. 

all_distinct/1 is from library clpfd
*/
all_valid([]).
all_valid([[_|Tail]|T]) :-
    Tail ins 1..9,
    all_distinct(Tail),
    all_valid(T).

/* 
handle_puzzles/1,

A function to solve the puzzles with checking if the sum or 
product of a column or a row is equal to the heading, according 
to the rules. 

The element is a list of rows and columns, traversing the list 
with recursions.

sum/3 and #=/2 are from the library clpfd, #=/2 is used here 
to help the calculation to trackback to find solutions.
*/
handle_puzzles([]).
handle_puzzles([[Head|Solutions]|Others]) :-
    (   sum(Solutions, #=, Head)
    ;   product(Solutions, Head)
    ),
    handle_puzzles(Others).

/* 
product/2, 

The function to calculate the product with all elements of a list 
and check if the product is equal to the second element.

#=/2 is used here to subsuming both (is)/2 and (=:=)/2, also make 
the calculation be able to trackback.

The first element is the list which can mean a row or a column, 
the second one is a number means the heading or the product.
*/
product([],1).
product([Head|Tail], A) :-
    product(Tail, B),
    A#=Head*B.

