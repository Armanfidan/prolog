first_(H, [H|_]).

last_(X, [X|[]]):- !.
last_(X, [_|T]) :- last_(X, T).

length_([], 0).
length_([_|T], L) :-
    L1 is L-1,
    length_(T, L1).

removeLastElement([_|[]], []).
removeLastElement([H|T], [H|T1]) :-
    removeLastElement(T, T1).

middle([X], X).
middle([X, _], X).
middle([_|T], X) :-
    removeLastElement(T, T1),
    middle(T1, X).

findIfElementInList(X, [X|_]) :- !.
findIfElementInList(X, [_|T]) :-
    findIfElementInList(X, T).

append_([], L2, L2).
append_([H|L1], L2, [H|L3]) :-
    append_(L1, L2, L3).

prepend_(L2, [], L2).
prepend_(L1, [H|L2], [H|L3]) :-
    prepend_(L1, L2, L3).

reverse_([],  []).
reverse_([H|T], R) :-
    reverse_(T, TR),
    append_(TR, [H], R).

reverse2([], L2, L2).
reverse2([H|L1], L2, Rev) :-
    reverse2(L1, [H|L2], Rev).

deleteFirstOccurrence([], _, []) :- !.
deleteFirstOccurrence([X|T], X, T) :- !.
deleteFirstOccurrence([H|T], X, New) :-
    append_([H], NewCut, New),
    deleteFirstOccurrence(T, X, NewCut).

deleteAllOccurrences([], _, []).
deleteAllOccurrences([X|T], X, New) :-
    deleteAllOccurrences(T, X, New).
deleteAllOccurrences([H|T], X, New) :-
    append_([H], NewCut, New),
    deleteAllOccurrences(T, X, NewCut).

substituteAllOccurrences([], _, _, []).
substituteAllOccurrences([X|T], X, Y, New) :-
    substituteAllOccurrences([Y|T], X, Y, New).
substituteAllOccurrences([H|T], X, Y, New) :-
    append_([H], NewCut, New),
    substituteAllOccurrences(T, X, Y, NewCut).

testForSublist(_, []).
testForSublist([XH|T],[XH|XT]) :-
    testForSublist(T, XT).
testForSublist([_|T], X) :-
    testForSublist(T, X).

%Come back to this.
sieveList([], _, []).
sieveList([H|T], X, New) :-
    H < X,
    !,
    sieveList(T, X, New).
sieveList([H|T], X, [H|New]) :-
    sieveList(T, X, New).

partition_([], _, [], []).
partition_([H|T], Pivot, [H|L1], L2) :-
    H < Pivot,
    !,
    partition_(T, Pivot, L1, L2).
partition_([H|T], Pivot, L1, [H|L2]) :-
    partition_(T, Pivot, L1, L2).

quickSort([], []).
quickSort([H|T], SortedList) :-
    partition_(T, H, Smaller, Larger),
    quickSort(Smaller, SmallerSorted),
    quickSort(Larger, LargerSorted),
    append(SmallerSorted, [H|LargerSorted], SortedList).

subset_([H1|S1], S2) :-
    findIfElementInList(H1, S2),
    subset_(S1, S2).

% Go through all items in one list, add them to the output list if they
% are in the other list.
intersection_([], _,[]).
intersection_([H1|T1], S2, [H1|Out]) :-
    findIfElementInList(H1, S2),
    !,
    intersection_(T1, S2, Out).
intersection_([_|T1], S2, Out) :- intersection_(T1, S2, Out).

select2([H|T], (H, Other)) :-
    select1(T, Other).
select2([_|T], Pair) :-
    select2(T, Pair).

select1([H|_], H).
select1([_|T], H) :-
    select1(T, H).



father(homer, bart).
father(homer, lisa).
father(homer, maggie).
mother(marge, bart).
mother(marge, lisa).
mother(marge, maggie).
married(homer, marge).
male(homer).
male(bart).
female(maggie).
female(lisa).
female(marge).

parent(X, Y) :-
    father(X, Y),
    mother(X, Y).

grandfather(X, Y) :-
    father(X, Z),
    parent(Z, Y).
grandmother(X, Y) :-
    mother(X, Z),
    parent(Z, Y).

grandparent(X, Y) :-
    grandfather(X, Y),
    grandmother(X, Y).
