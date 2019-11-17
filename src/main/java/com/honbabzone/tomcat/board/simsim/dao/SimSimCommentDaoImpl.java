package com.honbabzone.tomcat.board.simsim.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.honbabzone.tomcat.board.model.CommentBean;

@Repository
public class SimSimCommentDaoImpl implements SimsimCommentDao {

    private static Logger logger = LoggerFactory.getLogger(SimSimCommentDaoImpl.class);
    
    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<CommentBean> getCommentList(CommentBean commentBean) {
        return sqlSession.selectList("sisimcomment.getCommentList",commentBean);
    }

    @Override
    public int commnetInsert(CommentBean commentBean) {
        sqlSession.insert("sisimcomment.commnetInsert",commentBean);
        return commentBean.getSeq();
    }

    @Override
    public int commnetUpdate(CommentBean commentBean) {
        sqlSession.update("sisimcomment.commnetUpdate",commentBean);
        return commentBean.getSeq();
    }
  
}
