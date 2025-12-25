package com.sell_buy.sell_buy.api.service;

import com.sell_buy.sell_buy.db.entity.Member;

public interface AuthenticationService {
    Member getAuthenticatedMember();
}
