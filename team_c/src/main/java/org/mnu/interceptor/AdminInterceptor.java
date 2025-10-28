package org.mnu.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.mnu.domain.MemberVO;
import org.springframework.web.servlet.HandlerInterceptor;

public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HttpSession session = request.getSession();
        MemberVO member = (MemberVO) session.getAttribute("member");

        // 로그인을 안 했거나, 로그인했지만 관리자가 아닌 경우
        if (member == null || !"ROLE_ADMIN".equals(member.getRole())) {
            // 홈으로 리다이렉트
            response.sendRedirect("/");
            return false; // 컨트롤러 실행 중단
        }

        return true; // 관리자이므로 컨트롤러 계속 실행
    }
}