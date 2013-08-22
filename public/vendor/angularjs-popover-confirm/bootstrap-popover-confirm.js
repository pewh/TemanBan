$('[data-popover-confirm]').popover({
  html: true,
  placement: 'top',
  trigger: 'manual',
  content: "<span data-popover-confirm-container> \
    <span class='btn btn-primary popover-confirm-btn'> \
      Confirm \
    </span> \
    <span class='btn popover-cancel-btn'> \
      Cancel \
    </span> \
  </span>"
})

$(document).on('click', '[data-popover-confirm]', function(){
  var btn = $(this),
    popover = btn.next();

  btn.popover('toggle');
});

$(document).on('click', '.popover-confirm-btn', function() {
  var popover = $(this).closest('.popover'),
    btn = popover.prev(),
    callback = btn.data('popover-confirm'),
    result = eval(callback);

  btn.popover('hide');
});

$(document).on('click', '.popover-cancel-btn', function() {
  var popover = $(this).closest('.popover'),
    btn = popover.prev();

  btn.popover('hide');
});
