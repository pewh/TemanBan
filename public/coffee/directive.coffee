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
