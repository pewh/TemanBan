"use strict";

var directives = angular.module('3rdpartyforms.directives', []);

directives.directive('ngPopoverConfirm', function() {
  return {
    restrict: 'A',
    link: function (scope, element, attrs) {
      element.popover({
        html: true,
        placement: 'left',
        trigger: 'manual',
        content: "<span data-popover-confirm-container> \
          <span class='btn btn-primary popover-confirm-btn'> \
            Confirm \
          </span> \
          <span class='btn popover-cancel-btn'> \
            Cancel \
          </span> \
        </span>"
      });

      $(document).off('click', '[ng-popover-confirm]');
      $(document).on('click', '[ng-popover-confirm]', function(){
        var btn = $(this),
          popover = btn.next();

        btn.popover('toggle');
      });

      $(document).off('click', '.popover-confirm-btn');
      $(document).on('click', '.popover-confirm-btn', function() {
        var popover = $(this).closest('.popover'),
          btn = popover.prev(),
          callback = btn.attr('ng-popover-confirm'),
          result = eval('scope.' + callback);

        btn.popover('hide');
      });

      $(document).off('click', '.popover-cancel-btn');
      $(document).on('click', '.popover-cancel-btn', function() {
        var popover = $(this).closest('.popover'),
          btn = popover.prev();

        btn.popover('hide');
      });
    }
  }
});
