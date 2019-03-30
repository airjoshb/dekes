(function() {
  jQuery(function() {
    return $(window).load(function() {
      return $('a[data-target]').click(function(e) {
        var $this, url;
        e.preventDefault();
        $this = $(this);
        url = $this.data('addurl');
        return $.ajax({
          url: url,
          type: 'put',
          success: function(data) {
            return $('.cart-count').html(data);
          }
        });
      });
    });
  });

}).call(this);
