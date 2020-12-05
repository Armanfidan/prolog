reverse([], Z, Z).
reverse([H|X], Y, Z) :- reverse(X, [H|Y], Z).

reverse2([], Y, Y).
reverse2([H|X], Y, [Z|H]) :- reverse2(X, Y, Z).

append2([], Y, Y).
append2([H|X], Y, [H|Z]) :- append2(X, Y, Z).
