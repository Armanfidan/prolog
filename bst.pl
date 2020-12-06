% Tree: [6, [4, [2, [], []], [5, [], []]], [8, [], []]]
% For testing.
create_bst(K, [K, [], []]).

insert(K, [K1, L1, []], [K1, L1, [K, [], []]]) :-
    K > K1,
    !.
insert(K, [K1, [], R1], [K1, [K, [], []], R1]) :- !.
insert(K, [K1, L1, R1], [K1, L1, Rnew]) :-
    K > K1,
    !,
    insert(K, R1, Rnew).
insert(K, [K1, L1, R1], [K1, Lnew, R1]) :-
    insert(K, L1, Lnew).

% Empty tree
delete(_, [], []).
% Empty subtrees
delete(K, [K, [], []], []).
% Leaf node does not match, so return itself
delete(_, [K, [], []], [K, [], []]).
% Empty right subtree
delete(K, [K, L, []], L).
% Empty left subtree
delete(K, [K, [], R], R).

% Keys match!
delete(K, [K, L1, R1], [KL, L1, Rnew]) :-
    leftmost(R1, KL),
    delete(KL, R1, Rnew),
    !.

% Recurse to the right subtree
delete(K, [K1, L1, R1], [K1, L1, Rnew]) :-
    K > K1,
    !,
    delete(K, R1, Rnew).
% Recurse to the left subtree
delete(K, [K1, L1, R1], [K1, Lnew, R1]) :-
    delete(K, L1, Lnew).


delete2(_, [], []).
delete2(K, [K, [], []], []) :- !.
delete2(K, [K, L, []], L) :- !.
delete2(K, [K, [], R], R) :- !.

delete2(K, [K, L1, R1], [NK, L1, Rnew]) :-
    inorder_successor(R1, NK),
    delete(NK, R1, Rnew).

delete2(K, [K1, L1, R1], [K1, Lnew, R1]) :-
    K @< K1, !,
    delete2(K, L1, Lnew).

delete2(K, [K1, L1, R1], [K1, L1, Rnew]) :-
    delete2(K, R1, Rnew).

inorder_successor([NK, [], _], NK) :- !.
inorder_successor([_, L1, _], NK) :-
    inorder_successor(L1, NK).

% Find leftmost node of a tree.
leftmost([K, [], _], K) :- !.
leftmost([_, L, _], K) :-
    leftmost(L, K).

% The leftmost node is the minimum key.
min_key(Tree, Key) :-
    leftmost(Tree, Key).

% Find rightmost node of a tree.
rightmost([K, _, []], K) :- !.
rightmost([_, _, R], K) :-
    rightmost(R, K).

% The rightmost node is the maximum key.
max_key(Tree, Key) :-
    rightmost(Tree, Key).


verify(Tree) :-
    verify2(Tree, Tree).

% An empty tree is always correct.
verify2([], _):- !.
% A tree with empty subtrees is always correct/
% If we have analysed the tree and arrived at a leaf node, then all previous
% keys must have been correct.
verify2(_, [_, [], []]) :- !.
% From any node, we check whether the left and right sub-keys satisfy
% the constraint. If they do, we keep recursing down the left and right subtrees.
verify2(Tree, [Key, [LeftKey, LL, LR], [RightKey, RL, RR]]) :-
    min_key(Tree, MinKey),
    max_key(Tree, MaxKey),
    LeftKey >= MinKey,
    LeftKey < Key,
    RightKey =< MaxKey,
    RightKey > Key,
    verify2(Tree, [LeftKey, LL, LR]),
    verify2(Tree, [RightKey, RL, RR]).
