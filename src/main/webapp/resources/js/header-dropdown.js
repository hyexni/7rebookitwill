 
	  document.addEventListener("DOMContentLoaded", function () {
	    const icon = document.querySelector(".user-icon");
	    const menu = document.querySelector(".dropdown-menu");
	
	    if (icon && menu) {
	      icon.addEventListener("click", (e) => {
	        e.stopPropagation();
	        menu.classList.toggle("show");
	      });
	
	      document.addEventListener("click", (e) => {
	        if (!icon.contains(e.target)) {
	          menu.classList.remove("show");
	        }
	      });
	    }
	  });
