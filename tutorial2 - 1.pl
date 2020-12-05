% Beer pouring problem.

state_change(fill_7, (F, S), (F, 7), 3) :-
    S < 7.
state_change(fill_5, (F, S), (5, S), HCost) :-
    HCost is abs(S - 4),
    F < 5.
state_change(empty_7, (F, S), (F, 0), 4) :-
    S > 0.
state_change(empty_5, (F, S), (0, S), HCost) :-
    HCost is abs(S - 4),
    F > 0.
state_change(pour_7_to_5, (F, S), (5, R), HCost) :-
    Total is F + S,
    Total > 5,
    R is Total - 5,
    HCost is abs(R - 4).
state_change(pour_7_to_5, (F, S), (Total, 0), 4) :-
    Total is F + S,
    Total =< 5.
state_change(pour_5_to_7, (F, S), (5, R), HCost) :-
    Total is F + S,
    Total > 7,
    R is Total - 7,
    HCost is abs(R - 4).
state_change(pour_5_to_7, (F, S), (Total, 0), 4) :-
    Total is F + S,
    Total =< 7.

start_state((0, 0)).
goal_state((_, 4)).

% GGSE
search(Graph, [Node|Path]) :-
    choose(Graph, [Node|Path], _),
    state_of(Node, State),
    goal_state(State).
search(Graph, SolutionPath) :-
    choose(Graph, Path, OtherPaths),
    one_step_extensions(Path, NewPaths),
    add_to_paths(NewPaths, OtherPaths, GraphPlus),
    search(GraphPlus, SolutionPath).

% A*
one_step_extensions([Node|Path], NewPaths) :-
state_of(Node, State),
gcost_of(Node, GPath),
findall(    [NewNode,Node|Path],
            (   state_change(_, State, NewState, HCost),
                Gactual is GPath + 1,
                FCost is Gactual + HCost,
                make_node(NewState, FCost, Gactual, NewNode)    ),
            NewPaths    ).

cheapest([], Cheapest, Cheapest, OtherPaths, OtherPaths).
cheapest([Test|Tail], SoFar, Cheapest, OtherPaths, AllOtherPaths) :-
    fcost_of(Test, F1),
    fcost_of(SoFar, F2),
    F1 < F2, !,
    cheapest(Tail, Test, Cheapest, [SoFar|OtherPaths], AllOtherPaths).
cheapest([Test|Tail], SoFar, Cheapest, OtherPaths, AllOtherPaths) :-
    cheapest(Tail, SoFar, Cheapest, [Test|OtherPaths], AllOtherPaths).

choose(Graph, Path, OtherPaths) :-
    cheapest(Graph, [[(999, 999), 999, 999]], Path, [], OtherPaths).

add_to_paths(NewPaths, OtherPaths, AllPaths) :-
    append(OtherPaths, NewPaths, AllPaths).

state_of([State|_], State).
fcost_of([[_, FCost, _]|_], FCost).
gcost_of([_, _, GCost], GCost).


make_node(State, FCost, GCost, [State, FCost, GCost]).


% %GGSE
% search(Graph, [Node|Path]) :-
%     % Choose a path.
%     choose([Node|Path], Graph, _),
%     % Retrieve the state of the frontier node of that path.
%     state_of(Node, State),
%     % If this node is the goal state, the predicate returns the
%     % node Node as the goal state.
%     goal_state(State).
% search(Graph, SolutionPath) :-
%     % Assuming that the goal state was not reached, the second predicate
%     % is queried. Again we choose a path, but we maintain the other paths in
%     % a list called OtherPaths.
%     choose(Path, Graph, OtherPaths),
%     % We extend the chosen path to form a new list, NewPaths, that contains
%     % all frontier nodes reachable from the given path (With one extension).
%     one_step_extensions(Path, NewPaths),
%     % By adding these new extended paths to the other paths, an extended graph,
%     % GraphPlus, is returned.
%     add_to_paths(NewPaths, OtherPaths, GraphPlus),
%     % We then search this larger graph. It is worth noting that the GGSE starts
%     % from the start state, and by extending the graph using various algorithms,
%     % it obtains a graph that includes the solution state.
%     search(GraphPlus, SolutionPath).
%
% one_step_extensions([Node|Path], NewPaths) :-
%     state_of(Node, State),
%     findall([NewNode, Node|Path],
%             (   state_change(Rule, State, NewState, _),
%                 make_node(Rule, NewState, NewNode)    ),
%             NewPaths).
%
% % BF search
% choose(Path, [Path|OtherPaths], OtherPaths).
% add_to_paths(NewPaths, OtherPaths, AllPaths) :-
%     append(OtherPaths, NewPaths, AllPaths).
% state_of(Node, Node).
% make_node(_, Node, Node).
