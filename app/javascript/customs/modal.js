document.addEventListener("turbolinks:load", function () {
  $("#modal-open").on("click", function () {
    //キーボード操作などにより、オーバーレイが多重起動するのを防止する
    $(this).on("blur"); //ボタンからフォーカスを外す
    if ($("#modal-overlay")[0]) return false;

    //オーバーレイを出現させる
    $("body").append('<div id="modal-overlay"></div>');
    $("#modal-overlay").fadeIn("slow");

    //コンテンツをセンタリングする
    centeringModalSyncer();

    //コンテンツをフェードインする
    $("#modal-content").fadeIn("slow");
    $("#modal-overlay, #modal-close")
      .off()
      .on("click", function () {
        //[#modal-content]と[#modal-overlay]をフェードアウトした後に…
        $("#modal-content, #modal-overlay").fadeOut("slow", function () {
          //[#modal-overlay]を削除する
          $("#modal-overlay").remove();
        });
      });
  });

  $("#modal-open-best-spot").on("click", function () {
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

  //リサイズされたら、センタリングをする関数[centeringModalSyncer()]を実行する
  $(window).on("resize", centeringModalSyncer);

  //センタリングを実行する関数
  function centeringModalSyncer() {
    //画面(ウィンドウ)の幅、高さを取得
    var w = $(window).width();
    var h = $(window).height();
    // コンテンツ(#modal-content)の幅、高さを取得
    var cw = $("#modal-content").outerWidth();
    var ch = $("#modal-content").outerHeight();
    $("#modal-content").css({
      left: (w - cw) / 2 + "px",
      top: (h - ch) / 2 + "px",
    });
  }
});
