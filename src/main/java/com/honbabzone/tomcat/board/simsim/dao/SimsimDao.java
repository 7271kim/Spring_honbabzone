package com.honbabzone.tomcat.board.simsim.dao;

import java.util.List;

import com.honbabzone.tomcat.board.model.BoardBean;

public interface SimsimDao {
    public List<BoardBean> getbordList(BoardBean bean);
    public int boardInsert( BoardBean bean );
    public int boardUpdate( BoardBean bean );
}
