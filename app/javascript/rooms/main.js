
document.addEventListener('turbolinks:load', function() { 
  const nav = document.querySelector('.header_nav_menu');
  const circle = document.querySelector('.image_header');
  const searchs = document.querySelectorAll('.header input');

  if (searchs) {
    searchs.forEach(search => {
      search.value = "";
    });
  }

  if(nav) {
    document.addEventListener('click', e => {
      if (!e.target.closest('.header_nav_menu') && !e.target.closest('.icon') ){
        if (nav.classList.contains('show')){
          nav.classList.remove('show');
          nav.classList.add('hide');
        } 
      } else if (e.target.closest('.icon')) {
        if (nav.classList.contains('hide')){
          nav.classList.remove('hide');
          nav.classList.add('show');
        } else {
          nav.classList.add('hide');
          nav.classList.remove('show');
        }
      }
    }); 
  }

 


});
