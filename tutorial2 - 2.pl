% State representation: Just a list, literally.
% We will check whether the lists' beginnings and engs are the same
% by using append on the same variables (Variables are final in Prolog).

state_change(RuleA, Xs, Xsn) :-
    append(X, [s], Xs),
    append(X, [s, n], Xsn).

state_change(Rule2, [i|X], Ixx) :-
    append([i|X], X, Ixx).

state_change(Rule3, XsssY, XnY) :-
    append(X, [s, s, s|Y], XsssY),
    append(X, [n|Y], XnY).

state_change(Rule4, XnnY, XY) :-
    append(X, [n, n|Y], XnnY),
    append(X, Y, XY).

%We start from state [i, s], and we are trying to reach state [i, n].
goal_state([i, n]).

%GGSE
search(Graph, [Node|Path]) :-
    % Choose a path.
    choose([Node|Path], Graph, _),
    % Retrieve the state of the frontier node of that path.
    state_of(Node, State),
    % If this node is the goal state, the predicate returns the
    % node Node as the goal state.
    goal_state(State).
search(Graph, SolutionPath) :-
    % Assuming that the goal state was not reached, the second predicate
    % is queried. Again we choose a path, but we maintain the other paths in
    % a list called OtherPaths.
    choose(Path, Graph, OtherPaths),
    % We extend the chosen path to form a new list, NewPaths, that contains
    % all frontier nodes reachable from the given path (With one extension).
    one_step_extensions(Path, NewPaths),
    % By adding these new extended paths to the other paths, an extended graph,
    % GraphPlus, is returned.
    add_to_paths(NewPaths, OtherPaths, GraphPlus),
    % We then search this larger graph. It is worth noting that the GGSE starts
    % from the start state, and by extending the graph using various algorithms,
    % it obtains a graph that includes the solution state.
    search(GraphPlus, SolutionPath).

one_step_extensions([Node|Path], NewPaths) :-
    state_of(Node, State),
    findall([NewNode, Node|Path],
            (   state_change(Rule, State, NewState),
                make_node(Rule, NewState, NewNode)    ),
            NewPaths).

% BF search
choose(Path, [Path|OtherPaths], OtherPaths).
add_to_paths(NewPaths, OtherPaths, AllPaths) :-
    append(OtherPaths, NewPaths, AllPaths).
state_of(Node, Node).
make_node(_, Node, Node).
