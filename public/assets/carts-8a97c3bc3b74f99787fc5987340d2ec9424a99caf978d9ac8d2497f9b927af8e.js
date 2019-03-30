(function() {
  jQuery(function() {
    return $('.remove').click(function(e) {
      var $this, url;
      e.preventDefault();
      $this = $(this).closest('a');
      url = $this.data('targeturl');
      return $.ajax({
        url: url,
        type: 'put',
        success: function(data) {
          return $('.cart-count').html(data);
        }
      });
    });
  });

}).call(this);
