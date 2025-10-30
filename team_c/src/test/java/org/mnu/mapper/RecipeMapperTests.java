package org.mnu.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mnu.domain.RecipeVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class) // JUnit이 스프링과 함께 실행되도록 함
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml") // 스프링 설정 파일을 불러옴
@Log4j
public class RecipeMapperTests {

    // 의존성 주입(DI)으로 RecipeMapper를 자동으로 연결 [cite: 1029, 4970]
    @Setter(onMethod_ = @Autowired)

    private RecipeMapper mapper;
    
    // getList() 메서드를 테스트
    /*
    @Test
    public void testGetList() {
        log.info("--- getList() 메서드 테스트 시작 ---");
        // getList()를 실행하고, 각 결과를 로그로 출력
        mapper.getList().forEach(recipe -> log.info(recipe));
        log.info("--- getList() 메서드 테스트 끝 ---");
    }
     */
    // create() 메서드를 테스트
    
    @Test
    public void testCreate() {
        log.info("--- create() 메서드 테스트 시작 ---");
        
        RecipeVO recipe = new RecipeVO();
        recipe.setTitle("테스트 새 레시피");
        //recipe.setContent("테스트 레시피 내용입니다.");
        recipe.setWriter("testuser"); // TBL_MEMBER에 존재하는 아이디여야 합니다.
        recipe.setCost(10000L);
        recipe.setTime_required("30분");
        recipe.setIngredients("테스트 재료");

        mapper.create(recipe);
        
        log.info("생성된 레시피 정보: " + recipe);
        log.info("--- create() 메서드 테스트 끝 ---");
    }
    /*
    */
    // 여기에 read(), update(), delete() 테스트 메서드도 추가...
}
