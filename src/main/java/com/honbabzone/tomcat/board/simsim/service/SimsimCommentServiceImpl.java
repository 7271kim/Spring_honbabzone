package com.honbabzone.tomcat.board.simsim.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.honbabzone.tomcat.board.model.CommentBean;
import com.honbabzone.tomcat.board.simsim.dao.SimsimCommentDao;

@Service
public class SimsimCommentServiceImpl implements SimsimCommentService {
    @Autowired
    SimsimCommentDao simsimCommentDao;
    
    @Override
    @Transactional(readOnly = true)
    public List<CommentBean> getCommentList(CommentBean commentBean) {
        return simsimCommentDao.getCommentList(commentBean);
    }
    
    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
    public int commnetInsert(CommentBean commentBean) {
        return simsimCommentDao.commnetInsert(commentBean);
    }
    
    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
    public int commnetUpdate(CommentBean commentBean) {
        return simsimCommentDao.commnetUpdate(commentBean);
    }

}
