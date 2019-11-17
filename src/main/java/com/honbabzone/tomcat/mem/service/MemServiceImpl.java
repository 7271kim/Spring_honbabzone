package com.honbabzone.tomcat.mem.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.honbabzone.tomcat.mem.dao.MemDao;
import com.honbabzone.tomcat.mem.model.MemberBean;

@Service
public class MemServiceImpl implements MemService {
    @Autowired
    MemDao memDao;
    
    /*
     * @Transactional
     * 트랜잭션 관련 옵션! 
     * 
     */
    @Override
    @Transactional(readOnly = true)
    public List<MemberBean> getMemList(MemberBean memberBean) {
        return memDao.getMemList(memberBean);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
    public int memInsert(MemberBean memberBean) {
        return memDao.memInsert(memberBean);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
    public int memUpdate(MemberBean memberBean) {
        return memDao.memUpdate(memberBean);
    }

}
