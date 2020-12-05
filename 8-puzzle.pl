% 1 2 3
% 4 5 6
% 7 8 9
% Representation: [9, 1, 2, 3, 4, 5, 6, 7, 8]
% Represents: blank in position 9, 1 in position 1, etc.
% Representation: [6, 3, 5, 2, 8, 7, 9, 1, 2]
% Represents: blank in position 6, 1 in position 3, 2 in position 5, etc.
% index 0 always represents the blank tile.

% 1 2
% 3 4

% The heuristic used is manhattan distance. Test with 3 numbers:
% [4, 2, 6]
% Rows and columns of each number:
% (2, 1), (1, 2), (2, 3)
% Goal state:
% [9, 1, 2]
% Rows and columns of each number:
% (3, 3), (1, 1), (1, 2)
%Then, total manhattan distance (between all three numbers) is 6.

% connected(1, 2).
% connected(1, 4).
% connected(2, 1).
% connected(2, 3).
% connected(2, 5).
% connected(3, 6).
% connected(4, 5).
% connected(4, 7).
% connected(5, 6).
% connected(5, 8).
% connected(6, 9).
% connected(7, 8).
% connected(8, 9).

connected(1, 2).
connected(2, 4).
connected(3, 1).
connected(3, 4).

connected_reverse(X, Y) :- connected(Y, X).

% goal_state([9, 1, 2, 3, 4, 5, 6, 7, 8]).
goal_state([4, 1, 2, 3]).

row(X, Row) :-
    X < 4,
    Row is 0.
row(X, Row) :-
    X > 6,
    Row is 2.
row(_, Row) :-
    Row is 1.
column(X, Col) :-
    Col is mod(X-1, 3).

exchange(X, [Blank|CurrentState], [X|NextState], HCost) :-
    connected(Blank, X),
    goal_state(GoalState),
    substituteAllOccurrences(CurrentState, X, Blank, NextState),
    manhattan_distance([X|NextState], GoalState, 0, HCost).

exchange(X, [Blank|CurrentState], [X|NextState], HCost) :-
    connected_reverse(Blank, X),
    goal_state(GoalState),
    substituteAllOccurrences(CurrentState, X, Blank, NextState),
    manhattan_distance([X|NextState], GoalState, 0, HCost).

exchange(_, CurrentState, CurrentState, HCost) :-
    goal_state(GoalState),
    manhattan_distance(CurrentState, GoalState, 0, HCost).

distance(X, Y, Distance) :-
    column(X, ColX),
    column(Y, ColY),
    row(X, RowX),
    row(Y, RowY),
    Distance is abs(ColX - ColY) +
                abs(RowX - RowY).


manhattan_distance([], [], TotalDistance, TotalDistance).
manhattan_distance([H|T1], [H|T2], OldDistance, TotalDistance) :-
    manhattan_distance(T1, T2, OldDistance, TotalDistance).
manhattan_distance([Current|T1], [Goal|T2], DistanceSoFar, TotalDistance) :-
    distance(Current, Goal, CurrentDistance),
    NewDistance is DistanceSoFar + CurrentDistance,
    manhattan_distance(T1, T2, NewDistance, TotalDistance).

substituteAllOccurrences([], _, _, []).
substituteAllOccurrences([X|T], X, Y, New) :-
    substituteAllOccurrences([Y|T], X, Y, New).
substituteAllOccurrences([H|T], X, Y, New) :-
    append([H], NewCut, New),
    substituteAllOccurrences(T, X, Y, NewCut).

% GGSE
search(Graph, [Node|Path]) :-
    choose([Node|Path], Graph, _),
    state_of(Node, State),
    goal_state(State).
search(Graph, SolutionPath) :-
    choose(Path, Graph, OtherPaths),
    one_step_extensions(Path, NewPaths),
    add_to_paths(NewPaths, OtherPaths, GraphPlus),
    search(GraphPlus, SolutionPath).

% A*
one_step_extensions([Node|Path], NewPaths) :-
state_of(Node, State),
gcost_of(Node, GPath),
findall(    [NewNode,Node|Path],
            (   exchange(_, State, NewState, HCost),
                GActual is GPath + 1,
                FCost is GActual + HCost,
                make_node(NewState, FCost, GActual, NewNode)    ),
            NewPaths    ).

cheapest([], Cheapest, Cheapest, OtherPaths, OtherPaths).
cheapest([Test|Tail], SoFar, Cheapest, OtherPaths, AllOtherPaths) :-
    SoFar = [[(9, 9), 15]], !,
    fcost_of(Test, F1),
    fcost_of(SoFar, F2),
    F1 < F2,
    cheapest(Tail, Test, Cheapest, OtherPaths, AllOtherPaths).
cheapest([Test|Tail], SoFar, Cheapest, OtherPaths, AllOtherPaths) :-
    fcost_of(Test, F1),
    fcost_of(SoFar, F2),
    F1 < F2, !,
    cheapest(Tail, Test, Cheapest, [SoFar|OtherPaths], AllOtherPaths).
cheapest([Test|Tail], SoFar, Cheapest, OtherPaths, AllOtherPaths) :-
    cheapest(Tail, SoFar, Cheapest, [Test|OtherPaths], AllOtherPaths).

choose(Graph, Path, OtherPaths) :-
    cheapest(Graph, [[(9, 9), 15]], Path, [], OtherPaths).

add_to_paths(NewPaths, OtherPaths, AllPaths) :-
    append(OtherPaths, NewPaths, AllPaths).

state_of([State|_], State).

fcost_of([_, FCost, _], FCost).

gcost_of([_, _, GCost], GCost).

make_node(State, FCost, GCost, [State, FCost, GCost]).
