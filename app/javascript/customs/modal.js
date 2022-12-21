document.addEventListener("turbolinks:load", function () {
  $("#modal-open").on("click", function () {
    $(this).on("blur");
    if ($("#modal-overlay")[0]) return false;

    $("body").append('<div id="modal-overlay"></div>');
    $("#modal-overlay").fadeIn("slow");

    centeringModalSyncer();

    $("#modal-content").fadeIn("slow");
    $("#modal-overlay, #modal-close")
      .off()
      .on("click", function () {
        $("#modal-content, #modal-overlay").fadeOut("slow", function () {
          $("#modal-overlay").remove();
        });
      });
  });

  $(window).on("resize", centeringModalSyncer);

  function centeringModalSyncer() {
    let w = $(window).width();
    let h = $(window).height();
    let cw = $("#modal-content").outerWidth();
    let ch = $("#modal-content").outerHeight();
    $("#modal-content").css({
      left: (w - cw) / 2 + "px",
      top: (h - ch) / 2 + "px",
    });
  }

  // モーデル2 Bestスポットの紹介
  $("#modal-open-best").on("click", function () {
    $(this).on("blur");
    if ($("#modal-overlay")[0]) return false;

    $("body").append('<div id="modal-overlay"></div>');
    $("#modal-overlay").fadeIn("slow");

    centeringModalBestSyncer();

    $("#modal-content-best").fadeIn("slow");
    $("#modal-overlay, #modal-close")
      .off()
      .on("click", function () {
        $("#modal-content-best, #modal-overlay").fadeOut("slow", function () {
          $("#modal-overlay").remove();
        });
      });
  });

  $(window).on("resize", centeringModalBestSyncer);

  function centeringModalBestSyncer() {
    let w = $(window).width();
    let h = $(window).height();
    let cw = $("#modal-content-best").outerWidth();
    let ch = $("#modal-content-best").outerHeight();
    $("#modal-content-best").css({
      left: (w - cw) / 2 + "px",
      top: (h - ch) / 2 + "px",
    });
  }
});
