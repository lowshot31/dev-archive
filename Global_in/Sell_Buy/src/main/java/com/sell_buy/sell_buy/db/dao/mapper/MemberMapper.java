package com.sell_buy.sell_buy.db.dao.mapper;

import com.sell_buy.sell_buy.api.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MemberMapper {
    List<MemberVO> selectAllMembers();
}
