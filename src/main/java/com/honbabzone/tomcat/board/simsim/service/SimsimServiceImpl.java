package com.honbabzone.tomcat.board.simsim.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.honbabzone.tomcat.board.model.BoardBean;
import com.honbabzone.tomcat.board.simsim.dao.SimsimDao;

@Service
public class SimsimServiceImpl implements SimsimService {
    @Autowired
    SimsimDao simsimDao;
    
    /*
     * @Transactional
     * 트랜잭션 관련 옵션! 
     * 
     */
    @Override
    @Transactional(readOnly = true)
    public List<BoardBean> getbordList(BoardBean bean) {
        return simsimDao.getbordList(bean);
    }


    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
    public int boardInsert(BoardBean bean) {
        return simsimDao.boardInsert(bean);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
    public int boardUpdate(BoardBean bean) {
        return simsimDao.boardUpdate(bean);
    }

}
