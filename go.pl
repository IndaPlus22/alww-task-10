% Taken and modified from https://gist.github.com/MuffinTheMan/7806903
% Get an element from a 2-dimensional list at (Row,Column)
% using 1-based indexing.
nth1_2d(Row, Column, List, Element) :-
    nth1(Row, List, SubList),
    nth1(Column, SubList, Element).

% Reads a file and retrieves the Board from it.
load_board(BoardFileName, Board):-
    see(BoardFileName),     % Loads the input-file
    read(Board),            % Reads the first Prolog-term from the file
    seen.                   % Closes the io-stream

% Check if alive
c(Row, Col, 'a') :-
    load_board('alive_ex.txt', Board),
    print_nicely(Board),
    check_prep(Col,Row,Board).
c(Row, Col, 'd') :-
    load_board('dead_ex.txt', Board),
    print_nicely(Board),
    check_prep(Col,Row,Board).
c(Row, Col, FilePath) :-
    load_board(FilePath, Board),
    print_nicely(Board),
    check_prep(Col,Row,Board).

% Make move
mm(Row, Col, Type, FilePath) :-
   load_board(FilePath, Board),
   print_nicely(Board),
   make_move(Row, Col, Type, Board, NewBoard),
   !,
   print_nicely(NewBoard),
   check_prep(Row, Col, NewBoard).

% Infinite Loop of make move
imove(FilePath) :-
    change_move(Move, NewMove),
    write("Row:"), nl, read(X), nl,
    write("Column:"), nl, read(Y), nl,
    load_board(FilePath, Board),
    print_nicely(Board),
    make_move(X, Y, Move, Board, NewBoard),
    !,
    print_nicely(NewBoard),
    imovel(FilePath, NewBoard, NewMove).

imovel(FilePath, OldBoard, Move) :-
    change_move(Move, NewMove),
    write("Row:"), nl, read(X), nl,
    write("Column:"), nl, read(Y), nl,
    make_move(X, Y, Move, OldBoard, NewBoard),
    !,
    print_nicely(NewBoard),
    imovel(FilePath, NewBoard, NewMove).

change_move(w, NewMove) :-
    NewMove = b.
change_move(_, NewMove) :-
    NewMove = w.

check_prep(Row,Col,Board) :-
    nth1_2d(Row, Col, Board, Stone),
    (Stone = 'w'; Stone = 'b'),
    append([],[],Things),
    check_alive(Row,Col,Board,Stone,[], Things),
    !.

    
% Checks whether the group of stones connected to
% the stone located at (Row, Column) is alive or dead.
check_alive(Row, Column, Board, Side, Checked_coordinates, Things):-
    nth1_2d(Row, Column, Board, Stone),
    (Stone = e;
        (
            Side = Stone,
            \+ check_if_checked((Row, Column), Checked_coordinates),
            Upp is Row - 1,
            Down is Row + 1,
            Left is Column - 1, 
            Right is Column + 1,
            
            check_inbounds(Upp, Down, Left, Right), 
            append([(Row, Column)], Things, X),
        (
            check_alive(Upp, Column, Board, Side, [(Row, Column) | Checked_coordinates],X);
            check_alive(Down, Column, Board, Side, [(Row, Column) | Checked_coordinates],X);
            check_alive(Row, Left, Board, Side, [(Row, Column) | Checked_coordinates],X);
            check_alive(Row, Right, Board, Side, [(Row, Column) | Checked_coordinates],X)
        )
            )
        ).

check_if_checked(Current_coordinate, [H|Tail]) :-
    Current_coordinate = H; check_if_checked(Current_coordinate, Tail).

check_inbounds(Upp,Down,Left,Right) :-
    Upp < 11,
    Down > -1,
    Left > -1,
    Right < 11.


print_nicely([]) :- !.
print_nicely([H|T]) :-
    printl(H),
    nl,
    print_nicely(T).

printl([]) :- !.
printl([w|T]) :-
    write('X'),
    printl(T).
printl([b|T]) :-
    write('O'),
    printl(T).
printl([e|T]) :-
    write(' '),
    printl(T).

make_move(Row, Col, Move, Board, NewBoard) :-
    make_movel(Row, Col, Move, Board, 1, 1, [], NewBoard).

make_movel(_, _, _, [], _, _, Acc, NewBoard) :- 
    reverse(Acc, NewBoard).
make_movel(Row, Col, Move, [H|T], Row, CounterCol, Acc, NewBoard) :-
    make_movell(Col, Move, H, CounterCol, [], Res),
    append([Res], Acc, X),
    IncrementedCounterRow is Row + 1,
    make_movel(Row, Col, Move, T, IncrementedCounterRow, CounterCol, X, NewBoard).
make_movel(Row, Col, Move, [H|T], CounterRow, CounterCol, Acc, NewBoard) :-
    append([H], Acc, X),
    IncrementedCounterRow is CounterRow + 1,
    make_movel(Row, Col, Move, T, IncrementedCounterRow, CounterCol, X, NewBoard).

make_movell(_, _, _, 10, NewH, Res) :- 
    reverse(NewH, Res).
make_movell(Col, Move, [_|T], Col, NewH, Res) :-
    append([Move], NewH, X),
    IncrementedCounterCol is Col + 1,
    make_movell(Col, Move, T, IncrementedCounterCol, X, Res).
make_movell(Col, Move, [H|T], CounterCol, NewH, Res) :-
    append([H], NewH, X),
    IncrementedCounterCol is CounterCol + 1,
    make_movell(Col, Move, T, IncrementedCounterCol, X, Res).