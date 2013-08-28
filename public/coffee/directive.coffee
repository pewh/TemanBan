app.directive 'activeLink', ($location) ->
    restrict: 'A'
    scope: true
    link: (scope, element, attribute) ->
        scope.$on '$routeChangeSuccess', ->
            path = '/' + $location.path().split('/')[1]
            if path == element.children('a').attr('href')
                element.addClass 'active'
            else
                element.removeClass 'active'

app.directive 'buttonToggle', ->
    restrict: 'A'
    require: 'ngModel'
    link: ($scope, element, attr, ctrl) ->
        classToToggle = attr.buttonToggle

        element.bind 'click', ->
            checked = ctrl.$viewValue
            $scope.$apply (scope) ->
                ctrl.$setViewValue(!checked)

        $scope.$watch attr.ngModel, (newValue, oldValue) ->
            if newValue
                element.addClass(classToToggle)
            else
                element.removeClass(classToToggle)

app.directive 'confirmDelete', ->
    restrict: 'E'
    scope:
        deleteAction: '&ngClick'
    template: """
               <span ng-hide=confirm>
                   <a href=# ng-click="confirm = true">Delete</a>
               </span>
               <span ng-show=confirm>
                   <a href=# class="label label-danger" ng-click="deleteAction()">Yes</a>
                   <a href=# class="label label-default" ng-click="confirm = false">No</a>
               </span>
               """

app.directive 'xeditable', (FlashService, MomentService, SocketService, currencyFilter, $timeout) ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attr, ctrl) ->
        loadXeditable = ->
            element.editable
                showbuttons: false
                emptytext: '-'
                ajaxOptions:
                    type: 'PATCH'

                success: (response, newValue) ->
                    if attr.format == 'currency'
                        newValue = currencyFilter(newValue)

                    SocketService.emit 'update:item',
                        field: attr.field
                        name: response.name
                        oldValue: element.text()
                        newValue: newValue

                error: (response, newValue) ->
                    if response.status == 500
                        if response.responseJSON?.code == 11001
                            FlashService.error "#{newValue} sudah ada", MomentService.currentTime()
                        else if response.responseJSON?.name == 'ValidationError'
                            FlashService.error "#{attr.field} tidak boleh kosong", MomentService.currentTime()
                            element.editable 'toggle'

        $timeout ->
            loadXeditable()
        , 10

app.directive 'formGroup', ->
    template: """
              <div class="form-group">
                  <label class="control-label" for="" />
                  <div class="controls" ng-transclude />
              </div
              """
    replace: true
    transclude: true
    require: '^form' # must be within a form
    scope:
        label: '@'
        size: '@' # use =
    link: (scope, element) ->
        id = element.find(':input').attr('id')
        scope.for = id
