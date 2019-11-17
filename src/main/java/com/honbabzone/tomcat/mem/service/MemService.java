package com.honbabzone.tomcat.mem.service;

import java.util.List;

import com.honbabzone.tomcat.mem.model.MemberBean;

public interface MemService {
    public List<MemberBean> getMemList(MemberBean memberBean);
    public int memInsert( MemberBean memberBean );
    public int memUpdate( MemberBean memberBean );
}
