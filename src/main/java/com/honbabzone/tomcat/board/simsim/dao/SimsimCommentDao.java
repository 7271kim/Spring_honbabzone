package com.honbabzone.tomcat.board.simsim.dao;

import java.util.List;

import com.honbabzone.tomcat.board.model.CommentBean;

public interface SimsimCommentDao {
    public List<CommentBean> getCommentList( CommentBean commentBean );
    public int commnetInsert( CommentBean commentBean );
    public int commnetUpdate( CommentBean commentBean );
}
