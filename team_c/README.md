mac os로 구현해서 해당 경로들 윈도우용으로만 교체해주고 본인 오라클DB로 바꿔서 사용하면 됨
http://localhost:8080/ 가 메인페이지임
-- 회원 테이블
CREATE TABLE TBL_MEMBER (
    userid VARCHAR2(50) PRIMARY KEY,
    userpw VARCHAR2(100) NOT NULL,
    username VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    regdate DATE DEFAULT SYSDATE,
    updatedate DATE DEFAULT SYSDATE
);

-- 레시피 게시판 테이블
CREATE TABLE TBL_RECIPE (
    bno NUMBER(10,0) PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    content VARCHAR2(4000) NOT NULL,
    writer VARCHAR2(50) NOT NULL,
    -- 예상 비용, 소요 시간, 재료 등 추가 컬럼
    cost NUMBER(10,0),
    time_required VARCHAR2(50),
    ingredients VARCHAR2(1000),
    regdate DATE DEFAULT SYSDATE,
    updatedate DATE DEFAULT SYSDATE,
    CONSTRAINT fk_recipe_writer FOREIGN KEY(writer) REFERENCES TBL_MEMBER(userid)
);

-- 레시피 게시판을 위한 시퀀스
CREATE SEQUENCE seq_recipe;

ALTER TABLE TBL_RECIPE ADD (image_path VARCHAR2(200));

CREATE TABLE TBL_LIKE (
    bno NUMBER(10, 0) NOT NULL,
    userid VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_like PRIMARY KEY (bno, userid),
    CONSTRAINT fk_like_recipe FOREIGN KEY (bno) REFERENCES TBL_RECIPE(bno),
    CONSTRAINT fk_like_member FOREIGN KEY (userid) REFERENCES TBL_MEMBER(userid)
);

ALTER TABLE TBL_RECIPE ADD (like_count NUMBER(10,0) DEFAULT 0);


CREATE TABLE TBL_BOOKMARK (
    bno NUMBER(10, 0) NOT NULL,
    userid VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_bookmark PRIMARY KEY (bno, userid),
    CONSTRAINT fk_bookmark_recipe FOREIGN KEY (bno) REFERENCES TBL_RECIPE(bno),
    CONSTRAINT fk_bookmark_member FOREIGN KEY (userid) REFERENCES TBL_MEMBER(userid)
);


-- 자유 게시판 테이블
CREATE TABLE TBL_FREE_BOARD (
    bno NUMBER(10,0) PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    content VARCHAR2(2000) NOT NULL,
    writer VARCHAR2(50) NOT NULL,
    regdate DATE DEFAULT SYSDATE,
    updatedate DATE DEFAULT SYSDATE,
    CONSTRAINT fk_free_writer FOREIGN KEY(writer) REFERENCES TBL_MEMBER(userid)
);

-- 자유 게시판을 위한 시퀀스
CREATE SEQUENCE seq_free_board;


ALTER TABLE TBL_RECIPE ADD (category VARCHAR2(50));


-- 태그 테이블
CREATE TABLE TBL_TAG (
    tagName VARCHAR2(100) PRIMARY KEY
);

-- 레시피와 태그의 관계 테이블
CREATE TABLE TBL_RECIPE_TAG (
    bno NUMBER(10, 0) NOT NULL,
    tagName VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_recipe_tag PRIMARY KEY (bno, tagName),
    CONSTRAINT fk_recipetag_recipe FOREIGN KEY (bno) REFERENCES TBL_RECIPE(bno),
    CONSTRAINT fk_recipetag_tag FOREIGN KEY (tagName) REFERENCES TBL_TAG(tagName)
);


-- 레시피테이블의 카테고리 삭제
ALTER TABLE TBL_RECIPE DROP COLUMN category;

-- 팔로우 테이블
CREATE TABLE TBL_FOLLOW (
    follower_id VARCHAR2(50) NOT NULL, -- 팔로우를 하는 사람
    following_id VARCHAR2(50) NOT NULL, -- 팔로우를 당하는 사람
    CONSTRAINT pk_follow PRIMARY KEY (follower_id, following_id),
    CONSTRAINT fk_follow_follower FOREIGN KEY (follower_id) REFERENCES TBL_MEMBER(userid),
    CONSTRAINT fk_follow_following FOREIGN KEY (following_id) REFERENCES TBL_MEMBER(userid)
);


ALTER TABLE TBL_RECIPE ADD (content_temp CLOB);
UPDATE TBL_RECIPE SET content_temp = content;
ALTER TABLE TBL_RECIPE DROP COLUMN content;
ALTER TABLE TBL_RECIPE RENAME COLUMN content_temp TO content;


-- 1단계: 임시 컬럼 추가
ALTER TABLE TBL_FREE_BOARD ADD (content_temp CLOB);

-- 2단계: 데이터 복사
UPDATE TBL_FREE_BOARD SET content_temp = content;

-- 3단계: 기존 컬럼 삭제
ALTER TABLE TBL_FREE_BOARD DROP COLUMN content;

-- 4단계: 임시 컬럼 이름 변경
ALTER TABLE TBL_FREE_BOARD RENAME COLUMN content_temp TO content;


ALTER TABLE TBL_RECIPE DROP COLUMN content;

CREATE TABLE TBL_RECIPE_STEP (
    step_id NUMBER(10, 0) PRIMARY KEY, -- 각 단계의 고유 ID
    bno NUMBER(10, 0) NOT NULL, -- 어떤 레시피(bno)에 속하는지
    step_order NUMBER(3, 0) NOT NULL, -- 단계 순서 (1, 2, 3...)
    description VARCHAR2(2000), -- 단계별 설명
    image_path VARCHAR2(200), -- 단계별 이미지 경로
    CONSTRAINT fk_step_recipe FOREIGN KEY (bno) REFERENCES TBL_RECIPE(bno) ON DELETE CASCADE
);

CREATE SEQUENCE seq_recipe_step;

-- 식재료 관리
CREATE TABLE TBL_USER_INGREDIENTS (
    userid VARCHAR2(50) NOT NULL,
    ingredient_name VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_user_ingredients PRIMARY KEY (userid, ingredient_name),
    CONSTRAINT fk_ingredients_member FOREIGN KEY (userid) REFERENCES TBL_MEMBER(userid) ON DELETE CASCADE
);

ALTER TABLE TBL_MEMBER ADD (role VARCHAR2(50) DEFAULT 'ROLE_USER');


UPDATE TBL_MEMBER SET role = 'ROLE_ADMIN' WHERE userid = 'testuser';


-- 신고   
CREATE TABLE TBL_REPORT (
    report_id NUMBER(10, 0) PRIMARY KEY, -- 신고 번호 (고유 ID)
    bno NUMBER(10, 0) NOT NULL, -- 신고된 게시글 번호
    reporter_id VARCHAR2(50) NOT NULL, -- 신고한 사용자 아이디
    reported_id VARCHAR2(50) NOT NULL, -- 신고된 게시글의 작성자
    report_content VARCHAR2(500), -- 신고 사유
    report_date DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'PENDING', -- 처리 상태 (PENDING, COMPLETED)
    CONSTRAINT fk_report_recipe FOREIGN KEY (bno) REFERENCES TBL_RECIPE(bno) ON DELETE CASCADE,
    CONSTRAINT fk_report_reporter FOREIGN KEY (reporter_id) REFERENCES TBL_MEMBER(userid)
);

CREATE SEQUENCE seq_report;

ALTER TABLE TBL_RECIPE_STEP ADD (ingredients VARCHAR2(500));
ALTER TABLE TBL_RECIPE_STEP DROP COLUMN ingredients;
ALTER TABLE TBL_RECIPE DROP COLUMN ingredients;
ALTER TABLE TBL_RECIPE ADD (ingredients CLOB);


CREATE TABLE TBL_COMMENT (
  comment_id    NUMBER          PRIMARY KEY,
  bno           NUMBER          NOT NULL,
  userid        VARCHAR2(50)    NOT NULL,
  content       CLOB            NOT NULL,
  regdate       DATE            DEFAULT SYSDATE,
  CONSTRAINT FK_COMMENT_RECIPE
    FOREIGN KEY (bno) REFERENCES TBL_RECIPE(bno)
    ON DELETE CASCADE,
  CONSTRAINT FK_COMMENT_USER
    FOREIGN KEY (userid) REFERENCES TBL_MEMBER(userid)
    ON DELETE CASCADE
);


-- 영양성분 테이블 (레시피 1 : 1)
CREATE TABLE TBL_NUTRITION (
  RECIPE_ID      NUMBER       PRIMARY KEY,        -- FK → TBL_RECIPE.RECIPE_ID
  CALORIES       NUMBER(10,2) DEFAULT 0 CHECK (CALORIES      >= 0),
  CARBOHYDRATE   NUMBER(10,2) DEFAULT 0 CHECK (CARBOHYDRATE  >= 0),
  PROTEIN        NUMBER(10,2) DEFAULT 0 CHECK (PROTEIN       >= 0),
  FAT            NUMBER(10,2) DEFAULT 0 CHECK (FAT           >= 0),

  ING_HASH       VARCHAR2(64),        -- 재료문자열+인분 수 해시
  COMPUTED_AT    DATE DEFAULT SYSDATE -- 언제 계산했는지
);

ALTER TABLE TBL_NUTRITION
  ADD CONSTRAINT FK_NUT_RECIPE
  FOREIGN KEY (RECIPE_ID)
  REFERENCES TBL_RECIPE(BNO)
  ON DELETE CASCADE;

CREATE SEQUENCE SEQ_COMMENT
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
------------------------------------------------------------------------------
-- [SEQ_COMMENT] 안전 드랍 + 재생성
------------------------------------------------------------------------------

-- 1) SEQ_COMMENT 드랍(없어도 에러 안나게)
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_COMMENT';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -2289 THEN -- ORA-02289: sequence does not exist
      RAISE;
    END IF;
END;
/
COMMIT;

-- 2) SEQ_COMMENT 생성
CREATE SEQUENCE SEQ_COMMENT
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
/

-- 자유게시판 댓글 테이블
CREATE TABLE TBL_FREE_REPLY (
    rno        NUMBER(10,0)   PRIMARY KEY,      -- 댓글 번호
    bno        NUMBER(10,0)   NOT NULL,         -- 자유게시판 글 번호
    reply      CLOB           NOT NULL,         -- 댓글 내용
    replyer    VARCHAR2(50)   NOT NULL,         -- 작성자 ID (TBL_MEMBER.userid)
    replydate  DATE           DEFAULT SYSDATE,  -- 작성일
    CONSTRAINT fk_free_reply_board
        FOREIGN KEY (bno) REFERENCES TBL_FREE_BOARD(bno) ON DELETE CASCADE,
    CONSTRAINT fk_free_reply_member
        FOREIGN KEY (replyer) REFERENCES TBL_MEMBER(userid) ON DELETE CASCADE
);

-- 자유게시판 댓글 시퀀스
CREATE SEQUENCE SEQ_FREE_REPLY
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


INSERT INTO TBL_MEMBER(userid, userpw, username, email, role)
VALUES ('admin', '111111', '관리자', 'admin@example.com', 'ROLE_ADMIN');

INSERT INTO TBL_MEMBER(userid, userpw, username, email, role)
VALUES ('user1', '222222', '일반유저', 'user1@example.com', 'ROLE_USER');


commit;
