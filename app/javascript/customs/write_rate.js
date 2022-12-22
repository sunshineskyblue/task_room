document.addEventListener("turbolinks:load", function () {
  const Stars1 = document.querySelectorAll(".cleanliness-stars input");
  const cleanliness = document.getElementById("cleanliness-value");

  const Stars2 = document.querySelectorAll(".information-stars input");
  const information = document.getElementById("information-value");

  const Stars3 = document.querySelectorAll(".communication-stars input");
  const communication = document.getElementById("communication-value");

  const Stars4 = document.querySelectorAll(".location-stars input");
  const location = document.getElementById("location-value");

  const Stars5 = document.querySelectorAll(".price-stars input");
  const price = document.getElementById("price-value");

  const Stars6 = document.querySelectorAll(".recommendation-stars input");
  const recommendation = document.getElementById("recommendation-value");

  const diamond = document.querySelector(".award .fa-gem");
  const award = document.getElementById("award-value");

  Stars1.forEach(function (star) {
    star.addEventListener("click", () => {
      cleanliness.value = star.value;
    });
  });

  Stars2.forEach(function (star) {
    star.addEventListener("click", () => {
      information.value = star.value;
    });
  });

  Stars3.forEach(function (star) {
    star.addEventListener("click", () => {
      communication.value = star.value;
    });
  });

  Stars4.forEach(function (star) {
    star.addEventListener("click", () => {
      location.value = star.value;
    });
  });

  Stars5.forEach(function (star) {
    star.addEventListener("click", () => {
      price.value = star.value;
    });
  });

  Stars6.forEach(function (star) {
    star.addEventListener("click", () => {
      recommendation.value = star.value;
    });
  });

  if (diamond) {
    diamond.addEventListener("click", () => {
      diamond.classList.toggle("blue-diamond");
      diamond.classList.toggle("gray-diamond");

      if (award.value == 0) {
        award.value = 1;
        return;
      }
      if (award.value == 1) {
        award.value = 0;
        return;
      }
    });
  }
});
