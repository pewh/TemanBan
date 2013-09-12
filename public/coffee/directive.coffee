app.directive 'activeLink', ($location) ->
    restrict: 'A'
    scope: true
    link: (scope, element, attribute) ->
        scope.$on '$stateChangeSuccess', ->
            window.z = $location.path()
            path = '/' + $location.path().split('/')[1]
            linkPath = element.children('a').attr('href')
            if path == linkPath.substr(2)
                element.addClass 'active'
            else
                element.removeClass 'active'

app.directive 'buttonToggle', ->
    restrict: 'A'
    require: 'ngModel'
    link: ($scope, element, attr, ngModel) ->
        classToToggle = attr.buttonToggle

        element.bind 'click', ->
            checked = ngModel.$viewValue
            $scope.$apply (scope) ->
                ngModel.$setViewValue(!checked)

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
                   <a href="javascript:void(0)" ng-click="confirm = true">Delete</a>
               </span>
               <span ng-show=confirm>
                   <a href="javascript:void(0)" class="label label-danger" ng-click="deleteAction()">Yes</a>
                   <a href="javascript:void(0)" class="label label-default" ng-click="confirm = false">No</a>
               </span>
               """

app.directive 'xeditable', (FlashService, MomentService, SocketService, Restangular, currencyFilter, $timeout) ->
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
                        newValue = currencyFilter(newValue, 'IDR')

                    unless attr.nocommit?
                        SocketService.emit "update:#{attr.category}",
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

app.directive 'chartPie', ->
    restrict: 'E'
    replace: true
    scope:
        items: '='
    template: '<div style="height: 200px"></div>'

    link: (scope, element, attrs) ->
        idContainer = attrs.id
        element.find('div').attr('id', idContainer)

        options =
            credits:
                enabled: false
            chart:
                renderTo: idContainer
                plotBackgroundColor: null
                plotBorderWidth: null
                plotShadow: null
            title:
                text: attrs.title
            tooltip:
                formatter: -> false
            plotOptions:
                pie:
                    cursor: 'pointer'
                    dataLabels:
                        enabled: true
                        color: '#000'
                        connectorColor: '#000'
                        formatter: ->
                            """
                            <b>#{this.point.name}</b>
                            <br />
                            #{this.percentage.toFixed()}%
                            """
            series: [
                type: 'pie'
                name: attrs.pieSubtitle
                data: scope.items
            ]

        chart = new Highcharts.Chart(options)

        scope.$watch 'items', (newVal) ->
            chart.series[0].setData(newVal, true)
        , true

app.directive 'chartLine', ->
    restrict: 'E'
    replace: true
    scope:
        items: '='
    template: '<div style="height: 200px"></div>'

    link: (scope, element, attrs) ->
        idContainer = attrs.id
        element.find('div').attr('id', idContainer)

        options =
            credits:
                enabled: false
            chart:
                renderTo: idContainer
                plotShadow: null
            title:
                text: attrs.title
            tooltip:
                shared: true
                crosshairs: true
                formatter: ->
                    """
                    <b>#{moment(parseInt(@x, 10)).format('D MMM YY')}</b> <br />
                    Beli: Rp.#{@points[0].y} <br />
                    Jual: Rp.#{@points[1].y}
                    """
            legend:
                align: 'right'
                verticalAlign: 'top'
                y: 20
                floating: true
                borderWidth: 0
            xAxis:
                type: 'datetime'
                tickInterval: 24 * 3600 * 1000 # one day
                dateTimeLabelFormats:
                    day: '%e %b %y'
                labels:
                    align: 'center'
            yAxis:
                title:
                    text: 'Total Transaksi (Rp.)'
            series: [
                name: 'Beli'
                color: '#D9534F'
            ,
                name: 'Jual'
                color: '#1f6377'
            ]

        chart = new Highcharts.Chart(options)

        scope.$watch 'items', (newVal) ->
            chart.series[0].setData(newVal[0].data, true)
            chart.series[1].setData(newVal[1].data, true)

app.directive 'dateRangePicker', ->
    restrict: 'A'
    replace: true
    scope:
        dateStart: '&'
        dateEnd: '&'
        ctrlDateStart: '='
        ctrlDateEnd: '='
        onChange: '&change'
    template: """
              <div class=input-group>
                  <span class=input-group-addon>
                      <i class="glyphicon glyphicon-calendar"></i>
                  </span>
                  <input id=daterangepicker
                         class="form-control readonly-fake"
                         readonly
                         data-datestart="{{ dateStart }}"
                         data-dateend="{{ dateEnd }}"
                         value="{{ dateStart | date:'dd MMM y' }} - {{ dateEnd | date:'dd MMM y' }}">
                  </input>
              </div>
              """
    link: (scope, element, attrs) ->
        scope.dateStart = moment().startOf('week').toISOString()
        scope.dateEnd = moment().toISOString()

        element.find('#daterangepicker').daterangepicker
            ranges:
                'This week': [moment().startOf('week'), moment()]
                'This month': [moment().startOf('month'), moment()]
                'This year': [moment().startOf('year'), moment()]
            startDate: moment().startOf('week')
            endDate: moment()
            maxDate: moment()
            format: 'DD MMM YYYY'
            showDropdowns: true
        ,
            (start, end) ->
                scope.dateStart = start.add('day', 1).toISOString()
                scope.dateEnd = end.add('day', 1).toISOString()

                scope.$apply ->
                    scope.onChange
                        dateStart: start
                        dateEnd: end
                        ctrlDateStart: start
                        ctrlDateEnd: end

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
