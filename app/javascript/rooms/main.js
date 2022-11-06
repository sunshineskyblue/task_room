
document.addEventListener('turbolinks:load', function() { 
  const nav = document.querySelector('.header_nav_menu');
  const headerForm = document.querySelector('.header form');
  const headerInputs = document.querySelectorAll('.header input');
  const area_input = document.querySelector('.header .area');
  const keyword_input = document.querySelector('.header .keyword');

  headerForm.addEventListener('submit', e => {
    if (area_input.value == "" && keyword_input.value == "" ) {
      e.preventDefault();
    }
  });

  headerInputs.forEach(input => {
    input.value = "";
  });

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
});
