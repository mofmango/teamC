(function(){
  const ctx = document.body.getAttribute("data-ctx") || "";
  const typeEl = document.getElementById("mainType");
  const keyEl  = document.getElementById("mainKeyword");
  const btnEl  = document.getElementById("mainSearchBtn");

  function goSearch(){
    const type = typeEl.value;
    const keyword = (keyEl.value || "").trim();
    if(!keyword){
      alert("검색어를 입력하세요.");
      keyEl.focus();
      return;
    }
    location.href = ctx + "/recipe/list?type=" + encodeURIComponent(type)
                          + "&keyword=" + encodeURIComponent(keyword);
  }

  btnEl && btnEl.addEventListener("click", goSearch);
  keyEl && keyEl.addEventListener("keydown", (e)=>{
    if(e.key === "Enter") goSearch();
  });
})();