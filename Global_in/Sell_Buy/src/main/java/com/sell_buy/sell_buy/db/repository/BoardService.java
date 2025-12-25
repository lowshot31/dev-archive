// FILE START
// FILE PATH: src\main\java\com\sell_buy\sell_buy\api\service\BoardService.java
package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.common.exception.validation.BoardNotFoundException;
import com.sell_buy.sell_buy.common.exception.validation.InvalidBoardDataException;
import com.sell_buy.sell_buy.db.entity.Board;
import java.util.List;

public interface BoardService {
    void insertBoard(Board vo) throws InvalidBoardDataException;
    void updateBoard(Board vo) throws InvalidBoardDataException, BoardNotFoundException;
    void deleteBoard(Board vo) throws InvalidBoardDataException;
    Board getBoard(Board vo) throws InvalidBoardDataException, BoardNotFoundException;
    List<Board> getBoardList(Board vo);
}
// FILE END