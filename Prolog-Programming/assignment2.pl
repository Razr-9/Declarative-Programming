correspond(X,[X|_],Y,[Y|_]).
correspond(X, [_|TX], Y, [_|TY]) :- 
correspond(X, TX, Y, TY).

interleave(A,B) :- 
interleave_(A,B), samelength(A).

interleave_([],[]).
interleave_([[]|T],[]) :- 
interleave(T,[]).
interleave_([[H|T]|Ls], [H|L]) :- 
append(Ls, [T], Lsn), interleave(Lsn, L).

samelength([_|[]]).
samelength([X1,X2|Xs]) :- 
(
  same_length(X1,X2) -> 
  samelength([X2|Xs])
).

partial_eval(Expr0, Var, Val, Expr) :-
  terms_to_list(Expr0,R1),
  replace(R1,Var,Val,R2),
  calculate(R2,Expr).

terms_to_list(Exp0,R) :-
    (
      compound(Exp0) -> 
      Exp0=..[H,F,S],
      terms_to_list(F,R1),
      terms_to_list(S,R2),
      append([H],[R1],Temp),
      append(Temp,[R2],R)
      ;
      R = Exp0
    ).

replace([H,F,S],Var,Val,R) :-
    (
      is_list(F) -> 
      replace(F,Var,Val,R1)
      ;
      (
        atom(F), F = Var -> 
        R1 = Val
        ;
        R1 = F
      )
    ),
    (
      is_list(S) -> 
      replace(S,Var,Val,R2)
      ;
      (
        atom(S), S = Var -> 
        R2 = Val
        ;
        R2 = S
      )
    ),
    append([H],[R1],Temp),
    append(Temp,[R2],R).

calculate([H,F,S],R):-
    (
      is_list(F) -> 
      calculate(F,R1)
      ;
      R1 = F
    ),
    (
      is_list(S) -> 
      calculate(S,R2)
      ;
      R2 = S
    ),
    E =..[H,R1,R2],
    (
      number(R1),number(R2) -> 
      R is E
      ;
      R = E
    ).
        
