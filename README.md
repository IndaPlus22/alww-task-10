# alww-task-10


| Commands                     | Description                                                                                                                                                                                                      |
|------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| c(Row, Col, 'a')             | Check if the stone at 'Row'/'Col' in 'alive_ex.txt' is alive                                                                                                                                                     |
| c(Row, Col, 'b')             | Check if the stone at 'Row'/'Col' in 'dead_ex.txt' is alive                                                                                                                                                      |
| mm(Row, Col, Type, FilePath) | Places a Stone of type 'Type' at 'Row'/'Col' in the board  obtained from file 'FilePath' without any regard to the  actual rules or if it is already occupied. The checks if the  places stone is dead or alive. |
| imove(FilePath)              | Make infinite moves without any legality checks, does not  check dead or alive, does not do anything except make  infinite moves                                                                                 |
