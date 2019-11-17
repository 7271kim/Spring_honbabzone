package com.honbabzone.tomcat.mem.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.honbabzone.tomcat.mem.model.MemberBean;

@Repository
public class MemDaoImpl implements MemDao {

    
    private static Logger logger = LoggerFactory.getLogger(MemDaoImpl.class);
    
    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<MemberBean> getMemList(MemberBean memberBean) {
        return sqlSession.selectList("member.getMemList",memberBean);
    }

    @Override
    public int memInsert(MemberBean memberBean) {
        sqlSession.insert("member.memInsert",memberBean);
        // sqlSession.insert("member.memInsert",memberBean); 문을통해 <selectKey>의 결과값들이 memberBean을 통해 리턴된다! 때문에 자동 increament인 seq를 잡을 수 있음
        int seq = memberBean.getSeq();
        return seq;
    }

    @Override
    public int memUpdate(MemberBean memberBean) {
        sqlSession.insert("member.memUpdate",memberBean);
        // sqlSession.insert("member.memInsert",memberBean); 문을통해 <selectKey>의 결과값들이 memberBean을 통해 리턴된다! 때문에 자동 increament인 seq를 잡을 수 있음
        int seq = memberBean.getSeq();
        return seq;
    }
    
  
}
