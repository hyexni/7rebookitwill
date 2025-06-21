
function toggleSubMenu(elem) {
  const submenu = elem.nextElementSibling;

  document.querySelectorAll('.menu-title').forEach(title => {
    if (title !== elem) {
      title.classList.remove('open');
      const sib = title.nextElementSibling;
      if (sib && sib.classList.contains('submenu')) {
        sib.style.display = 'none';
      }
    }
  });

  if (submenu.style.display === 'block') {
    submenu.style.display = 'none';
    elem.classList.remove('open');
  } else {
    submenu.style.display = 'block';
    elem.classList.add('open');
  }
}

/*====== 하위 메뉴 hover 시 상위 강조 유지 ======*/
document.querySelectorAll('.submenu li a').forEach(item => {
  item.addEventListener('mouseenter', () => {
    document.querySelectorAll('.menu-title').forEach(title => {
      title.classList.remove('hovered');
    });
  });
});

/*전역 변수 선언*/
let statusChartInstance;

/*도넛 차트 함수*/
function drawStatusChart() {
  const chartElem = document.getElementById("statusChart");
  if (!chartElem) return;

  const ctx = chartElem.getContext("2d");
  if (!ctx) return;

  if (statusChartInstance) {
    statusChartInstance.destroy();
  }

  /*안전한 stats 값 세팅*/
  const safeStats = window.stats || {
    activeMembers: 0,
    withdrawnMembers: 0,
    todayNewMembers: 0,
    monthNewMembers: 0,
    totalMembers: 0
  };

  statusChartInstance = new Chart(ctx, {
    type: "doughnut",
    data: {
      labels: ["활성 회원", "탈퇴 회원"],
      datasets: [{
        data: [
          safeStats.activeMembers || 0.01,
          safeStats.withdrawnMembers || 0.01
        ],
        backgroundColor: ["#4CAF50", "#F44336"]
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { position: "bottom" } },
      layout: { padding: 10 }
    }
  });
}


/*DOM 로드 시 실행*/
document.addEventListener("DOMContentLoaded", function () {
  drawStatusChart();

  // 막대 차트
  const joinChartElem = document.getElementById("joinChart");
  if (joinChartElem) {
    const ctx = joinChartElem.getContext("2d");
    const s = window.stats || {};
    new Chart(ctx, {
      type: "bar",
      data: {
        labels: ["오늘", "이번 달", "전체"],
        datasets: [{
          label: "가입자 수",
          data: [
            s.todayNewMembers || 0,
            s.monthNewMembers || 0,
            s.totalMembers || 0
          ],
          backgroundColor: ["#2196F3", "#3F51B5", "#9C27B0"]
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        layout: { padding: { top: 10, bottom: 0 } },
        scales: { y: { beginAtZero: true, grace: "5%" } },
        plugins: { legend: { display: false } }
      }
    });
  }

  // Swiper 슬라이더
  const salesSwiper = new Swiper(".salesSwiper", {
    loop: true,
    pagination: { el: ".salesSwiper .swiper-pagination", clickable: true },
    autoplay: false,
    slidesPerView: 1,
    spaceBetween: 20,
  });

  const ratingSwiper = new Swiper(".ratingSwiper", {
    loop: true,
    pagination: { el: ".ratingSwiper .swiper-pagination", clickable: true },
    autoplay: false,
    slidesPerView: 1,
    spaceBetween: 20,
  });

  // 자동 넘김
  setInterval(() => {
    salesSwiper.slideNext();
    ratingSwiper.slideNext();
  }, 4000);
});
