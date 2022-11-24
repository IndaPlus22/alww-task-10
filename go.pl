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

c(Col, Row, 'a') :-
    load_board('alive_ex.txt', Board),
    check_prep(Col,Row,Board).
c(Col, Row, 'd') :-
    load_board('dead_ex.txt', Board),
    check_prep(Col,Row,Board).

check_prep(Col,Row,Board) :-
    nth1_2d(Row, Column, Board, Stone),
    (Stone = 'w'; Stone = 'b'),
    check_alive(Col,Row,Board,Stone,[]).

    
% Checks whether the group of stones connected to
% the stone located at (Row, Column) is alive or dead.
check_alive(Row, Column, Board, Side, Checked_coordinates):-
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
        (
            check_alive(Upp, Column, Board, Side, [(Row, Column) | Checked_coordinates]);
            check_alive(Down, Column, Board, Side, [(Row, Column) | Checked_coordinates]);
            check_alive(Row, Left, Board, Side, [(Row, Column) | Checked_coordinates]);
            check_alive(Row, Right, Board, Side, [(Row, Column) | Checked_coordinates])
        )
            )
        ).

check_if_checked(Current_coordinate, [H|Tail]) :-
    Current_coordinate = H; check_if_checked(Current_coordinate, Tail).

check_inbounds(Upp,Down,Left,Right) :-
    Upp < 10,
    Down > 0,
    Left > 0,
    Right < 10.


print_nicely([end_of_file|_]) :- !.
print_nicely([H|T]) :-
    printl(H),
    nl,
    print_nicely(T).

printl([]) :- !.
printl(['w'|T]) :-
    write('X'),
    printl(T).
printl(['b'|T]) :-
    write('O'),
    printl(T).
printl(['e'|T]) :-
    write(' '),
    printl(T).
