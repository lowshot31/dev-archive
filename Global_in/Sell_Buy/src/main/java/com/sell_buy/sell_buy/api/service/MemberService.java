package com.sell_buy.sell_buy.api.service;

import com.sell_buy.sell_buy.db.entity.Member;

import java.util.List;

public interface MemberService {


    Long registerMember(Member member) throws Exception;

//    Long login(Member member) throws Exception;

    Member updateMember(Member member);

    Member updateMember();

    Member deleteMember();

    Member getMemberByMemId(Long userId);

    Member getMemberByNickname(String nickname);

    List<Member> getAllMembers();

    Member getMemberByLoginId(String loginId);

    Member getMember(Long memId);
}
