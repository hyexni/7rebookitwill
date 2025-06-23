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
	
	  // ───── 3. 리뷰 모달 로직 ─────
	  document.querySelectorAll('.openModalBtn').forEach(btn => {
	    btn.addEventListener('click', function () {
	      document.getElementById('modalBookTitle').textContent = this.dataset.book;
	      document.getElementById('modalWriter').textContent = this.dataset.writer;
	      document.getElementById('modalDate').textContent = this.dataset.date;
	      document.getElementById('modalScore').textContent = this.dataset.score;
	      document.getElementById('modalText').textContent = this.dataset.text;
	      document.getElementById('modalReviewId').value = this.dataset.id;
	      document.getElementById('modalReason').value = '';
	      document.getElementById('reviewModal').style.display = 'block';
	    });
	  });
	
	  const modal = document.getElementById('reviewModal');
	  window.addEventListener('click', function (e) {
	    if (e.target == modal) modal.style.display = 'none';
	  });
	
	  const closeBtn = document.querySelector('.modal .close');
	  if (closeBtn) {
	    closeBtn.addEventListener('click', () => {
	      modal.style.display = 'none';
	    });
	  }
	
	  document.getElementById('hideBtn')?.addEventListener('click', () => handleReviewAction('hide'));
	  document.getElementById('deleteBtn')?.addEventListener('click', () => handleReviewAction('delete'));
	});
	
	// ───── 4. 리뷰 숨김/삭제 함수 (밖에 둬도 OK) ─────
	function handleReviewAction(type) {
	  const reviewId = document.getElementById('modalReviewId').value;
	  const reason = document.getElementById('modalReason').value.trim();
	
	  if (!reason) return alert('사유를 입력해주세요.');
	  if (type === 'delete' && !confirm('정말 삭제하시겠습니까?')) return;
	
	  const form = document.getElementById('reviewActionForm');
	  document.getElementById('modalReasonHidden').value = reason;
	
	  form.action = `${ctx}/admin/review_${type}`;
	  form.submit();
	}
	
	
