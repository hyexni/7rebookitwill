<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	<div style="
	    display: grid;
	    grid-template-columns: repeat(auto-fit, minmax(320px,1fr));
	    gap: 30px;
	    margin-top: 30px;
	  " class="admin-container">
	  <!-- 도넛 차트 -->
	  <div style="background:#fff;border:1px solid #ddd;border-radius:10px;padding:20px;
	  			display:flex;flex-direction:column;height:280px;">
	    <h1 style="font-size: 20px;">회원 상태 비율</h1>
	    <canvas id="statusChart" style="flex:1;width:100% !important;height:auto !important;"></canvas>
	  </div>
	  <!-- 막대 차트 -->
	  <div style="background:#fff;border:1px solid #ddd;border-radius:10px;padding:20px;
	  			display:flex;flex-direction:column;height:280px;">
	    <h1 style="font-size: 20px;">가입자 수 추이</h1>
	    <canvas id="joinChart" style="flex:1;width:100% !important;height:auto !important;"></canvas>
	  </div>
	</div>
	
	<!-- ────────────────────────────────────── -->
	<!-- 3) 차트 초기화 -->
	<script>
	  // 도넛
	  new Chart(
		    document.getElementById("statusChart").getContext("2d"),
		    {
		      type: "doughnut",
		      data: {
		        labels: ["활성 회원", "탈퇴 회원"],
		        datasets: [{
		          data: [${stats.activeMembers}, ${stats.withdrawnMembers}],
		          backgroundColor: ["#4CAF50", "#F44336"]
		        }]
		      },
		      options: {
		        responsive: true,
		        maintainAspectRatio: false,
		        plugins: { legend: { position: "bottom" } },
		        layout: { padding: 10 }
		      }
		    }
		  );
	
	  // 막대
	  new Chart(
		    document.getElementById("joinChart").getContext("2d"),
		    {
		      type: "bar",
		      data: {
		        labels: ["오늘", "이번 달", "전체"],
		        datasets: [{
		          label: "가입자 수",
		          data: [${stats.todayNewMembers}, ${stats.monthNewMembers}, ${stats.totalMembers}],
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
		    }
	  );
	</script>
	