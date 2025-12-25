package com.sell_buy.sell_buy.db.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
public class Member implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "mem_seq")
    @SequenceGenerator(name = "mem_seq", sequenceName = "mem_seq", allocationSize = 1)
    @Column(name = "mem_id")
    private Long memId;
    @Column(name = "img_id")
    private Long imgId;
    @Column(name = "login_id", unique = true)
    private String loginId;
    private String password;
    private String name;
    @Column(unique = true)
    private String nickname;
    private String address;
    @Column(unique = true)
    private String email;
    @Column(name = "create_date")
    private LocalDateTime createDate;
    @Column(name = "phone_num", unique = true)
    private String phoneNum;
    @Column(name = "role")
    private String role;

    @PrePersist
    protected void onCreate() {
        if (createDate == null)
            createDate = LocalDateTime.now();
        System.out.println("createDate: " + createDate);
        role = "ROLE_USER";
    }

    public String printAll() {
        return "Member{" +
                "memId=" + memId +
                ", imgId=" + imgId +
                ", loginId='" + loginId + '\'' +
                ", password='" + password + '\'' +
                ", name='" + name + '\'' +
                ", nickname='" + nickname + '\'' +
                ", address='" + address + '\'' +
                ", email='" + email + '\'' +
                ", createDate=" + createDate +
                ", phoneNum='" + phoneNum + '\'' +
                ", role='" + role + '\'' +
                '}';
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of();
    }

    @Override
    public String getUsername() {
        return loginId;
    }
}
