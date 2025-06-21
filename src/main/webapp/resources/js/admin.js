
// 토글 메뉴

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



//도넛 차트
new Chart(document.getElementById("statusChart").getContext("2d"), {
  type: "doughnut",
  data: {
    labels: ["활성 회원", "탈퇴 회원"],
    datasets: [{
      data: [stats.activeMembers, stats.withdrawnMembers],
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

// 막대 차트
new Chart(document.getElementById("joinChart").getContext("2d"), {
  type: "bar",
  data: {
    labels: ["오늘", "이번 달", "전체"],
    datasets: [{
      label: "가입자 수",
      data: [stats.todayNewMembers, stats.monthNewMembers, stats.totalMembers],
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

