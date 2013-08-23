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

app.directive 'xeditable', (SocketService, $timeout) ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attr, ctrl) ->
        loadXeditable = ->
            element.editable
                showbuttons: false
                emptytext: '-'
                ajaxOptions:
                    type: 'PATCH'
                display: (value, srcData) ->
                    ctrl.$setViewValue(value)
                    element.html(value)
                    scope.$apply()
                success: (response, newValue) ->
                    # TODO get old value to compare
                    SocketService.emit 'update:item',
                        field: attr.field
                        name: response.name
                        newValue: newValue

        $timeout ->
            loadXeditable()
        , 10
