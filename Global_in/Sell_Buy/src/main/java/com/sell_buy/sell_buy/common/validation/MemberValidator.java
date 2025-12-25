package com.sell_buy.sell_buy.common.validation;

import com.sell_buy.sell_buy.db.entity.Member;
import com.sell_buy.sell_buy.db.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import java.util.regex.Pattern;

@Component
@RequiredArgsConstructor
public class MemberValidator implements Validator {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{10,}$");
    private static final Pattern LOGIN_ID_PATTERN = Pattern.compile("^.{1,20}$");
    private static final Pattern NICKNAME_PATTERN = Pattern.compile("^[가-힣a-zA-Z0-9]{2,10}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^010-\\d{4}-\\d{4}$");
    private final MemberRepository memberRepository;

    @Override
    public boolean supports(Class<?> clazz) {
        return Member.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        Member member = (Member) target;

        if (memberRepository.existsByLoginId(member.getLoginId())) {
            errors.rejectValue("loginId", "Duplicate.loginId", "Login ID already exists");
        }
        if (memberRepository.existsByEmail(member.getEmail())) {
            errors.rejectValue("email", "Duplicate.email", "Email already exists");
        }
        if (memberRepository.existsByPhoneNum(member.getPhoneNum())) {
            errors.rejectValue("phoneNum", "Duplicate.phoneNum", "Phone number already exists");
        }

        if (!EMAIL_PATTERN.matcher(member.getEmail()).matches()) {
            errors.rejectValue("email", "Invalid.email", "Invalid email format");
        }
        if (!PASSWORD_PATTERN.matcher(member.getPassword()).matches()) {
            errors.rejectValue("password", "Invalid.password", "Password must be at least 10 characters long and include uppercase, lowercase, number, and special character");
        }
        if (!LOGIN_ID_PATTERN.matcher(member.getLoginId()).matches()) {
            errors.rejectValue("loginId", "Invalid.loginId", "Login ID must be up to 20 characters long");
        }
        if (!NICKNAME_PATTERN.matcher(member.getNickname()).matches()) {
            errors.rejectValue("nickname", "Invalid.nickname", "Nickname must be between 2 and 10 characters long and can include Korean characters");
        }
        if (!PHONE_PATTERN.matcher(member.getPhoneNum()).matches()) {
            errors.rejectValue("phoneNum", "Invalid.phoneNum", "Phone number must be in the format 010-0000-0000");
        }
    }
}