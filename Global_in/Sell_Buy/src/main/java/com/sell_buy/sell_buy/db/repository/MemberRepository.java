package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {
    Member findByNickname(String searchQuery);

    boolean existsByLoginId(String loginId);

    boolean existsByEmail(String email);

    boolean existsByPhoneNum(String phoneNum);

    Optional<Member> findByLoginId(String loginId);

    Member getMemberByLoginId(String loginId);

    Member findByMemId(long memId);
}
