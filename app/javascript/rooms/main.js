
document.addEventListener('turbolinks:load', function() { 
  const nav = document.querySelector('.header_nav_menu');
  const searchs = document.querySelectorAll('.header input');

  if (searchs) {
    searchs.forEach(search => {
      search.value = "";
    });
  }

  if(nav) {
    document.addEventListener('click', e => {
      if (e.target.closest('.icon') && nav.classList.contains('hide')) {
        //アイコンをクリックし、メニューを表示
        nav.classList.add('show');
        nav.classList.remove('hide');
      } else if (!e.target.closest('.header_nav_menu') && nav.classList.contains('show')){
        //メニュー以外をクリックし、メニューを非表示
        nav.classList.add('hide');
        nav.classList.remove('show');
      } 
    }); 
  }
});
