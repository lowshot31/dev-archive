// FILE START
// FILE PATH: src\main\java\com\sell_buy\sell_buy\api\service\impl\BoardServiceimpl.java
package com.sell_buy.sell_buy.api.service.impl;


import com.sell_buy.sell_buy.common.exception.validation.BoardNotFoundException;
import com.sell_buy.sell_buy.common.exception.validation.InvalidBoardDataException;
import com.sell_buy.sell_buy.db.entity.Board;
import com.sell_buy.sell_buy.db.repository.BoardRepository;
import com.sell_buy.sell_buy.db.repository.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BoardServiceimpl implements BoardService {

    private final BoardRepository boardRepository;

    @Override
    public void insertBoard(Board vo) throws InvalidBoardDataException {
        validateInsertData(vo);
        boardRepository.save(vo);
    }

    @Override
    public void updateBoard(Board vo) throws BoardNotFoundException, InvalidBoardDataException {
        validateUpdateData(vo);
        Board board = boardRepository.findById(vo.getNoticId())
                .orElseThrow(() -> new BoardNotFoundException("수정할 게시글을 찾을 수 없습니다. ID: " + vo.getNoticId()));
        validateUpdateAuthorization(vo, board);
        board.setTitle(vo.getTitle());
        board.setContent(vo.getContent());
        boardRepository.save(board);
    }

    @Override
    public void deleteBoard(Board vo) throws InvalidBoardDataException {
        validateDeleteData(vo);
        boardRepository.deleteById(vo.getNoticId());
    }

    @Override
    public Board getBoard(Board vo) throws BoardNotFoundException, InvalidBoardDataException {
        validateGetData(vo);
        return boardRepository.findById(vo.getNoticId())
                .orElseThrow(() -> new BoardNotFoundException("해당하는 게시글을 찾을 수 없습니다. ID: " + vo.getNoticId()));
    }

    @Override
    public List<Board> getBoardList(Board vo) {
        if (vo == null) {
            return boardRepository.findAll();
        }
        if (StringUtils.hasText(vo.getSearchCondition()) && StringUtils.hasText(vo.getSearchKeyword())) {
            if (vo.getSearchCondition().equalsIgnoreCase("title")) {
                return boardRepository.findByTitleContaining(vo.getSearchKeyword());
            } else if (vo.getSearchCondition().equalsIgnoreCase("content")) {
                return boardRepository.findByContentContaining(vo.getSearchKeyword());
            }
        }
        return boardRepository.findAll();
    }

    private void validateInsertData(Board vo) throws InvalidBoardDataException {
        if (vo == null) {
            throw new InvalidBoardDataException("게시글 정보가 없습니다.");
        }
        if (vo.getUploaderId() == null) {
            throw new InvalidBoardDataException("로그인 후 이용해주세요");
        }
        validateTitleAndContent(vo.getTitle(), vo.getContent());
    }

    private void validateUpdateData(Board vo) throws InvalidBoardDataException {
        if (vo == null) {
            throw new InvalidBoardDataException("게시글 정보가 없습니다.");
        }
        if (vo.getNoticId() == null) {
            throw new InvalidBoardDataException("수정할 게시글 ID가 없습니다.");
        }
        if (vo.getUploaderId() == null) {
            throw new InvalidBoardDataException("로그인 후 이용해주세요");
        }
        validateTitleAndContent(vo.getTitle(), vo.getContent());
    }

    private void validateUpdateAuthorization(Board vo, Board board) throws InvalidBoardDataException {
        if (!board.getUploaderId().equals(vo.getUploaderId())) {
            throw new InvalidBoardDataException("수정 권한이 없습니다.");
        }
        if (!board.getTitle().equals(vo.getTitle())) {
            if (boardRepository.findByTitleContaining(vo.getTitle()).stream().anyMatch(b -> !b.getNoticId().equals(vo.getNoticId()))) {
                throw new InvalidBoardDataException("이미 존재하는 제목입니다.");
            }
        }
    }

    private void validateTitleAndContent(String title, String content) throws InvalidBoardDataException {
        if (!StringUtils.hasText(title)) {
            throw new InvalidBoardDataException("제목을 입력해주세요.");
        }
        if (!StringUtils.hasText(content)) {
            throw new InvalidBoardDataException("내용을 입력해주세요.");
        }
        if (title.length() > 255) {
            throw new InvalidBoardDataException("제목은 255자 이내로 입력해주세요.");
        }
        if (content.length() > 4000) {
            throw new InvalidBoardDataException("내용은 4000자 이내로 입력해주세요.");
        }
    }

    private void validateDeleteData(Board vo) throws InvalidBoardDataException {
        if (vo == null || vo.getNoticId() == null) {
            throw new InvalidBoardDataException("삭제할 게시글 정보가 유효하지 않습니다.");
        }
    }

    private void validateGetData(Board vo) throws InvalidBoardDataException {
        if (vo == null || vo.getNoticId() == null) {
            throw new InvalidBoardDataException("게시글 정보가 유효하지 않습니다.");
        }
    }
}