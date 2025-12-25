package com.sell_buy.sell_buy.api.controller;

import com.sell_buy.sell_buy.api.service.MemberService;
import com.sell_buy.sell_buy.common.exception.validation.BoardNotFoundException;
import com.sell_buy.sell_buy.common.exception.validation.InvalidBoardDataException;
import com.sell_buy.sell_buy.db.entity.Board;
import com.sell_buy.sell_buy.db.entity.Member;
import com.sell_buy.sell_buy.db.repository.BoardService;
import com.sell_buy.sell_buy.db.repository.MemberRepository;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RequiredArgsConstructor
@Controller
@RequestMapping("/board")
public class BoardController {

    private final Logger logger = LoggerFactory.getLogger(BoardController.class);

    private final MemberRepository memberRepository;

    private final BoardService boardService;
    private final MemberService memberService;

    @ModelAttribute("conditionMap")
    public Map<String, String> searchConditionMap() {
        Map<String, String> conditionMap = new HashMap<>();
        conditionMap.put("제목", "title");
        conditionMap.put("내용", "content");
        return conditionMap;
    }

    @GetMapping("") // 또는 @GetMapping("/")
    public String boardMain() {
        logger.info("board 메인 페이지 요청");
        return "redirect:/board/getBoardList.do";
    }

    @GetMapping("/insertBoardView.do")
    public String insertBoardView(HttpSession session, Model model) {
        logger.info("글 등록 페이지 요청");
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication(); // Spring Security 인증 정보 가져오기
        if (!authentication.isAuthenticated() || authentication.getName().equals("anonymousUser")) { // 로그인 여부 체크 (Spring Security 방식)
            return "redirect:/member/login?error=true&loginId="; // 로그인 페이지로 리다이렉트
        }
        return "insertBoardView"; // src/main/webapp/WEB-INF/jsp/insertBoardView.jsp
    }

    // uploaderId 파라미터 제거, HttpSession 사용
    @PostMapping("/insertBoard.do")
    public String insertBoard(@RequestParam("title") String title,
                              @RequestParam("content") String content) throws InvalidBoardDataException { // HttpSession 파라미터 제거
        logger.info("글 등록 처리 시작 - 제목: {}, 내용: {}", title, content);
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication(); // Spring Security 인증 정보 가져오기
        if (!authentication.isAuthenticated() || authentication.getName().equals("anonymousUser")) { // 로그인 여부 체크 (Spring Security 방식)
            throw new InvalidBoardDataException("로그인 후 이용해주세요."); // 예외 변경 (InvalidBoardDataException 사용)
        }

        String loginId = authentication.getName(); // Spring Security 인증 정보에서 loginId 가져오기

        Board board = new Board();
        // MemberService 를 이용해 loginId 로 Member 정보 가져옴.
        Member member = memberService.getMemberByLoginId(loginId); // MemberService 사용
        if (member == null) {
            throw new InvalidBoardDataException("존재하지 않는 사용자입니다."); // 예외 변경 (InvalidBoardDataException 사용)
        }
        board.setUploaderId(member.getMemId());
        board.setTitle(title);
        board.setContent(content);
        boardService.insertBoard(board);
        logger.info("글 등록 처리 완료 - 게시글 ID: {}", board.getNoticId());
        return "redirect:/board/getBoardList.do";
    }

    @GetMapping("/updateBoardView.do")
    public String updateBoardView(@RequestParam("noticId") Long noticId, Model model) throws InvalidBoardDataException, BoardNotFoundException {
        logger.info("글 수정 페이지 요청 - 게시글 ID: {}", noticId);
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (!authentication.isAuthenticated() || authentication.getName().equals("anonymousUser")) {
            return "redirect:/member/login?error=true&loginId=";
        }

        // Spring Security 에서 loginId 가져오기
        String loginId = authentication.getName();

        // loginId가 null 또는 "anonymousUser"인 경우 예외 처리 또는 로그인 페이지로 리다이렉트
        if (loginId == null || "anonymousUser".equals(loginId)) {
            logger.warn("updateBoardView.do - loginId가 null 또는 익명 사용자입니다.");
            return "redirect:/member/login?error=true&loginId="; // 또는 예외 처리
        }


        Board board = new Board();
        board.setNoticId(noticId);
        board = boardService.getBoard(board);
        if (board == null) {
            throw new BoardNotFoundException("수정할 게시글을 찾을 수 없습니다.");
        }

        // 수정 페이지에 게시글 정보 전달
        model.addAttribute("board", board);
        return "updateBoardView";
    }


    @PostMapping("/updateBoard.do")
    public String updateBoard(@RequestParam("title") String title,
                              @RequestParam("content") String content,
                              @RequestParam("noticId") Long noticId) throws InvalidBoardDataException, BoardNotFoundException {
        logger.info("글 수정 처리 시작 - 게시글 ID: {}, 제목: {}, 내용: {}", noticId, title, content);
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (!authentication.isAuthenticated() || authentication.getName().equals("anonymousUser")) {
            throw new InvalidBoardDataException("로그인 후 이용해주세요.");
        }

        String loginId = authentication.getName();
        Member member = memberService.getMemberByLoginId(loginId);
        if (member == null) {
            throw new InvalidBoardDataException("존재하지 않는 사용자입니다.");
        }

        // Board 객체 생성 - builder() 대신 setter 메서드 사용
        Board vo = new Board();
        vo.setNoticId(noticId);
        vo.setUploaderId(member.getMemId()); // 로그인한 사용자 ID로 설정
        vo.setTitle(title);
        vo.setContent(content);


        try {
            boardService.updateBoard(vo); // BoardService 를 통해 게시글 수정
            logger.info("글 수정 처리 완료 - 게시글 ID: {}", noticId);
        } catch (InvalidBoardDataException e) {
            logger.error("InvalidBoardDataException 발생: {}", e.getMessage());
            throw e;
        } catch (BoardNotFoundException e) {
            logger.error("BoardNotFoundException 발생: {}", e.getMessage());
            throw e;
        } catch (Exception e) {
            logger.error("예상치 못한 오류 발생", e);
            throw e; // 예외 다시 던지기
        }

        return "redirect:/board/getBoardList.do";
    }


    @GetMapping("/deleteBoard.do")
    public String deleteBoard(Board vo) throws InvalidBoardDataException {
        logger.info("글 삭제 처리 - 게시글 ID: {}", vo.getNoticId());
        boardService.deleteBoard(vo);
        return "redirect:/board/getBoardList.do";
    }

    @GetMapping("/getBoard.do")
    public String getBoard(Board vo, Model model) throws InvalidBoardDataException, BoardNotFoundException {
        logger.info("글 상세 조회 처리 - 게시글 ID: {}", vo.getNoticId());
        model.addAttribute("board", boardService.getBoard(vo));
        return "getBoard"; // src/main/webapp/WEB-INF/jsp/getBoard.jsp
    }

    @GetMapping("/getBoardList.do")
    public String getBoardList(Board vo, Model model) {
        logger.info("글 목록 검색 처리 - 검색 조건: {}, 검색 키워드: {}", vo.getSearchCondition(), vo.getSearchKeyword());
        if (vo.getSearchCondition() == null) vo.setSearchCondition("title");
        if (vo.getSearchKeyword() == null) vo.setSearchKeyword("");
        model.addAttribute("boardList", boardService.getBoardList(vo));
        return "getBoardList"; // src/main/webapp/WEB-INF/jsp/getBoardList.jsp
    }

    public MemberService getMemberService() {
        return memberService;
    }
}