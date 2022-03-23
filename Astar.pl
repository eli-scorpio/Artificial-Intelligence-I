% astar(Start,Path,Cost,KB)
astar(Start,NewPath,Cost,KB) :- search([[[Start],0]],[Path,Cost],KB), reverse(Path,NewPath,[]).

% search(ListofPathCostPairs, PathCostPair, KnowledgeBase)
search([[[Node|Tail], Cost]|_], [[Node|Tail], Cost], _) :- goal(Node).

search([[[Node|Tail], Cost]|Rest], PathCostPair, KB) :-
	findall([[X|[Node|Tail]],PathCost], (arc(Node, X, NodeCost, KB), PathCost is NodeCost+Cost), PathCostPairs),
	add2frontier(PathCostPairs, Rest, Result),
    !, search(Result,PathCostPair,KB).


% add2frontier(PathCostPairs, OldPathCostPairs, NewPathCostPairs) 
add2frontier([],X,X).
add2frontier([PathCostPair|X],Restof, New) :- insert(PathCostPair,Restof,Result),
									  add2frontier(X,Result, New).

% insert(PathCostPair, ListOfPathCostPairs, NewPathCostPairs)
insert(PathCostPair,[],[PathCostPair]).
insert(PathCostPair, [HPathCostPairs|TPathCostPairs], [PathCostPair,HPathCostPairs|TPathCostPairs]) :- 
    lessthan(PathCostPair, HPathCostPairs).
insert(PathCostPair, [HPathCostPairs|TPathCostPairs], [HPathCostPairs|NewTail]) :- 
    lessthan(HPathCostPairs, PathCostPair),
    insert(PathCostPair, TPathCostPairs, NewTail).

% lessthan([Path1, Cost1], [Path2, Cost2]))
lessthan([[Node1|_],Cost1],[[Node2|_],Cost2]) :-
	heuristic(Node1,Hvalue1), heuristic(Node2,Hvalue2),
	F1 is Cost1+Hvalue1, F2 is Cost2+Hvalue2,
	F1 =< F2.

% arc(Node,NewNode,Cost,KnowledgeBase)
arc([H|T],Node,Cost,KB) :- 
    member([H|B],KB), append(B,T,Node),
	length(B,L), Cost is 1+ L/(L+1).

% heuristic(Node, Heuristic)
heuristic(Node,H) :- length(Node,H).

% goal([])
goal([]).

%reverse(Path, NewPath)
reverse([],Result,Result).
reverse([H|T],Result,Acc) :- reverse(T,Result,[H|Acc]).