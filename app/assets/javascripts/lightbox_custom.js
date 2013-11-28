function ilghtboxForAlbums() {
  var c = $("ul.thumbnails"),
  a = $('<div class="comments"></div>');
  $("ul.thumbnails li a").iLightBox().setOption({
    skin: "metro-black custom-class",
    fullViewPort: "fit",
    mobileOptimizer: !1,
    overlay: {
      opacity: 1,
      blur: !1
    },
    styles: {
      pageOffsetX: 300,
      nextOffsetX: 15,
      nextOpacity: 0,
      prevOffsetX: 15,
      prevOpacity: 0
    },
    thumbnails: {
      normalOpacity: 0.5,
      activeOpacity: 1
    },
    effects: {
      loadedFadeSpeed: 10,
      switchSpeed: 700
    },
    callback: {
      onOpen: function () {
        $("body").append(a);
        var b = this.itemsObject[this.vars.current].data("id");
        a.html("Image " + (this.vars.current + 1) + " of " + this.vars.total + ".<br>Image id is <b>" + b + "</b>.")
      },
      onHide: function () {
        a.hide().remove()
      },
      onAfterChange: function (b) {
        var c = this.itemsObject[b.currentItem].data("id");
        a.html("Image " + (b.currentItem + 1) + " of " + this.vars.total + ".<br>Image id is <b>" + c + "</b>.")
      },
      onAfterLoad: function (b) {
        a.fadeIn(180)
      },
      onEnterFullScreen: function () {
        a.hide()
      },
      onExitFullScreen: function () {
        a.show()
      }
    }
  });
}