




document.addEventListener("DOMContentLoaded", function () {
	  // ───── 1. 차트 로딩 ─────
	  drawStatusChart();
	
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
	
	  // ───── 2. 슬라이더 초기화 ─────
	  const salesSwiperEl = document.querySelector(".salesSwiper");
	  const ratingSwiperEl = document.querySelector(".ratingSwiper");
	
	  let salesSwiper, ratingSwiper;
	
	  if (salesSwiperEl) {
	    salesSwiper = new Swiper(salesSwiperEl, {
	      loop: true,
	      pagination: { el: ".salesSwiper .swiper-pagination", clickable: true },
	      autoplay: false,
	      slidesPerView: 1,
	      spaceBetween: 20,
	    });
	  }
	
	  if (ratingSwiperEl) {
	    ratingSwiper = new Swiper(ratingSwiperEl, {
	      loop: true,
	      pagination: { el: ".ratingSwiper .swiper-pagination", clickable: true },
	      autoplay: false,
	      slidesPerView: 1,
	      spaceBetween: 20,
	    });
	  }
	
	  setInterval(() => {
	    if (salesSwiper) salesSwiper.slideNext();
	    if (ratingSwiper) ratingSwiper.slideNext();
	  }, 4000);
	
	 