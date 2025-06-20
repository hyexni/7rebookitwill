
// 토글 메뉴

function toggleSubMenu(el) {
  const submenu = el.nextElementSibling;
  const arrow = el.querySelector(".arrow");

  if (submenu.style.display === "block") {
    submenu.style.display = "none";
    if (arrow) arrow.textContent = "▾";
  } else {
    submenu.style.display = "block";
    if (arrow) arrow.textContent = "▴";
  }
}
