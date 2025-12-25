package com.sell_buy.sell_buy.api.service.impl;

import com.sell_buy.sell_buy.api.service.MemberService;
import com.sell_buy.sell_buy.common.validation.IdValidation;
import com.sell_buy.sell_buy.common.validation.PasswordValidation;
import com.sell_buy.sell_buy.common.validation.StringValidation;
import com.sell_buy.sell_buy.common.validation.Validator;
import com.sell_buy.sell_buy.db.dao.mapper.MemberMapper;
import com.sell_buy.sell_buy.db.entity.Member;
import com.sell_buy.sell_buy.db.entity.Point;
import com.sell_buy.sell_buy.db.repository.MemberRepository;
import com.sell_buy.sell_buy.db.repository.PointRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberMapper memberMapper;
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;
    private final PointRepository pointRepository;

    @Override
    public Long registerMember(Member member) throws Exception {
        if (member.getLoginId().isEmpty() || member.getPassword().isEmpty() || member.getNickname().isEmpty()) {
            throw new Exception("Invalid input");

        }
        System.out.println(member.getLoginId());
        Validator<StringValidation> validator = new Validator<>(new IdValidation(member.getLoginId()),
                new PasswordValidation(member.getPassword()));
        if (!validator.isValid()) {
            throw new Exception("Invalid input");
        }
        if (memberRepository.findByLoginId(member.getLoginId()).isPresent()) {
            throw new Exception("Login ID already exists");
        }
        member.setPassword(passwordEncoder.encode(member.getPassword()));
        Member registeredMember = memberRepository.save(member);
        Point point = Point.builder().memId(registeredMember.getMemId()).balance(0).build();
        pointRepository.save(point);

        return registeredMember.getMemId();
    }

    @Override
    public Member updateMember(Member member) {
        return null;
    }

    @Override
    public Member getMemberByLoginId(String loginId) {
        return memberRepository.getMemberByLoginId(loginId);
    }

    @Override
    public Member getMember(Long memId) {
        return memberRepository.findById(memId).orElse(null);
    }


    @Override
    public Member updateMember() {
        return null;
    }

    @Override
    public Member deleteMember() {
        return null;
    }

    @Override
    public Member getMemberByMemId(Long userId) {
        return null;
    }

    @Override
    public Member getMemberByNickname(String nickname) {
        return memberRepository.findByNickname(nickname);
    }

    @Override
    public List<Member> getAllMembers() {
        return List.of();
    }

}

/*    public Long login(Member member) throws Exception {
        String loginId = member.getLoginId();
        String password = member.getPassword();
        return login(loginId, password);
    }*/

    /*private Long login(String loginId, String password) throws Exception {
        Optional<Member> member = memberRepository.findByLoginId(loginId);
        try {
            Validator<StringValidation> validator = new Validator<>(new IdValidation(loginId), new PasswordValidation(password));
            if (!validator.isValid()) {
                throw new Exception("Invalid input");
            }
        } catch (Exception e) {
            throw new Exception(e);
        }
        if (passwordEncoder.matches(password, member.getPassword())) {
            return member.getMemId();
        }

        throw new Exception("Login failed");
    }*/



