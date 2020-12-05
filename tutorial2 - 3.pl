goalState(_, _, DifferentBall, same) :-
	length(DifferentBall, 1).
goalState(DifferentBall, _, _, left) :-
	length(DifferentBall, 1).
goalState(_, DifferentBall, _, right) :-
	length(DifferentBall, 1).

% States are represented with three lists and a variable, each list representing
% the balls on

stateChange(WeighFirst, ([B1, B2, B3], [B4, B5, B6], B7, Heavier), ([B1], [B2], B3, _)) :-
	Heavier is left.
stateChange(WeighFirst, ([B1, B2, B3], [B4, B5, B6], B7, Heavier), ([B4], [B5], B6, _)) :-
	Heavier is right.
stateChange(WeighFirst, ([B1, B2, B3], [B4, B5, B6], B7, Heavier), ([_], [B2], B7, _)) :-
	Heavier is same.
