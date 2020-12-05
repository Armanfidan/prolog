%woman & burns -> witch
%wood -> burns
%floats -> wood
%X floats & weight(X) == weight(Y), Y floats

true(1).
true(-P) :- false(P).
true(P->Q) :- true(P), !.
true(P->Q) :- true(Q).

false(0).
false(-P) :- true(P).
false(P->Q) :- true(P), false(Q).

