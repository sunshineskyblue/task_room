
document.addEventListener('turbolinks:load', function() { 
  const nav = document.querySelector('.header_nav_menu');
  const circle = document.querySelector('.circle');

  if (circle){
    circle.addEventListener('click', () => {
      console.log("clickに成功しました");
      nav.classList.toggle('hide');
      nav.classList.toggle('show');
    });
  }
});
