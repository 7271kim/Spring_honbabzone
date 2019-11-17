package com.honbabzone.tomcat.board.model;

import java.util.HashMap;

public class CommentBean {
	private int seq;
	private String id;
	private int useFlag;
	private int readCount;
	private String sContent;
	private String sJoindate;
	private String sJoinUpdate;
	private int sGroup = 0;
	private int childrenCount = 0;
	private int isChild;
	
	  // 동적 SQL을 위한 필드
    private HashMap<String, String> where;
    private HashMap<String, String> whereNot;
    private HashMap<String, String> like;
    
    // 추후 가지고 오는 list 개수 설정위해 
    private int limitStart = 0;
    private int limitEnd;
    
    
    public int getIsChild() {
        return isChild;
    }
    public void setIsChild(int isChild) {
        this.isChild = isChild;
    }
    public int getChildrenCount() {
        return childrenCount;
    }
    public void setChildrenCount(int childrenCount) {
        this.childrenCount = childrenCount;
    }
    public int getSeq() {
        return seq;
    }
    public void setSeq(int seq) {
        this.seq = seq;
    }
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public int getUseFlag() {
        return useFlag;
    }
    public void setUseFlag(int useFlag) {
        this.useFlag = useFlag;
    }
    public int getReadCount() {
        return readCount;
    }
    public void setReadCount(int readCount) {
        this.readCount = readCount;
    }
    public String getsContent() {
        return sContent;
    }
    public void setsContent(String sContent) {
        this.sContent = sContent;
    }
    public String getsJoindate() {
        return sJoindate;
    }
    public void setsJoindate(String sJoindate) {
        this.sJoindate = sJoindate;
    }
    public String getsJoinUpdate() {
        return sJoinUpdate;
    }
    public void setsJoinUpdate(String sJoinUpdate) {
        this.sJoinUpdate = sJoinUpdate;
    }
    public int getsGroup() {
        return sGroup;
    }
    public void setsGroup(int sGroup) {
        this.sGroup = sGroup;
    }
    public HashMap<String, String> getWhere() {
        return where;
    }
    public void setWhere(HashMap<String, String> where) {
        this.where = where;
    }
    public HashMap<String, String> getWhereNot() {
        return whereNot;
    }
    public void setWhereNot(HashMap<String, String> whereNot) {
        this.whereNot = whereNot;
    }
    public HashMap<String, String> getLike() {
        return like;
    }
    public void setLike(HashMap<String, String> like) {
        this.like = like;
    }
    public int getLimitStart() {
        return limitStart;
    }
    public void setLimitStart(int limitStart) {
        this.limitStart = limitStart;
    }
    public int getLimitEnd() {
        return limitEnd;
    }
    public void setLimitEnd(int limitEnd) {
        this.limitEnd = limitEnd;
    }
    
    
}
