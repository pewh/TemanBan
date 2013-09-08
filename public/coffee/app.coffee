###
$(document).ready ->
    chartingOptions =
        chart:
            plotBackgroundColor: null
            plotBorderWidth: null
            plotShadow: false
            renderTo: 'surplus-chart'
        title:
            text: 'Surplus'
        tooltip:
            pointFormat: '{series.name} <b>{point.percentage:.1f}%</b>'
        plotOptions:
            pie:
                allowPointSelect: false
                cursor: 'pointer'
                dataLabels:
                    enabled: true
                    color: '#000000'
                    connectorColor: '#000000'
                    format: '<b>{point.name}</b>: {point.percentange:.1f}%'
        series: [
            type: 'pie'
            name: 'Browser share'
            data: [
                ['Firefox',   45.0],
                ['IE',       26.8],
                {
                    name: 'Chrome',
                    y: 12.8,
                    sliced: true,
                    selected: true
                },
                ['Safari',    8.5],
                ['Opera',     6.2],
                ['Others',   0.7]
            ]
        ]
        chart = new Highcharts.Chart({
                 credits: {
                     enabled: true,
                     text: '',
                     href: ''
                 },
                 chart: {
                     renderTo: 'bm-container',
                     events: {
                         click: function () {
                             window.open('http://www.betmetrix.com', '_blank')
                         },
                     },
                     backgroundColor: '#FFFFFF',
                     zoomType: 'xy',
                     type: 'line',
                     marginLeft: 40,
                     marginRight: 40,
                     marginBottom: 40,
                 },
                 title: {
                     text: 'Election Worm',
                     x: -5,
                     style: {
                         color: '#000000',
                         fontWeight: 'bold',
                         fontSize: '17pt'
                     }
                 },
                 subtitle: {
                     text: 'Estimated Probability of Victory',
                     x: -5,
                     style: {
                         color: '#000000',
                         //fontWeight: 'bold',
                         fontSize: '13pt'
                     }
                 },
                 xAxis: {
                     type: 'datetime',
                     minRange: 7 * 24 * 3600000, // 1 week
                     dateTimeLabelFormats: {
                         second: '%H:%M:%S',
                         minute: '%H:%M',
                         hour: '%H:%M',
                         day: '%e %b',
                         week: '%e %b',
                         month: '%b \'%y',
                         year: '%Y'
                     },
                     //max: lnp[lnp.length-1][0]+604800000,
                     //tickInterval: 24*3600*1000*120,
                     //showFirstLabel: false,
                     minTickInterval: 1 * 24 * 3600000, //1 day
                     //maxTickInterval: 1 * 24 * 3600000*365, //30 day
                     startOnTick: false,
                     labels: {
                         style: {
                             color: '#969696',
                             //fontWeight: 'bold',
                             fontSize: '11pt'
                         }
                     }
                 },
                 yAxis: [{
                     //LHS axis
                     title: {
                         text: '%',
                         align: 'high',
                         rotation: 0,
                         offset: 10,
                         style: {
                             color: '#969696',
                             //fontWeight: 'bold',
                             fontSize: '11pt'
                         }
                     },
                     labels: {
                         style: {
                             color: '#969696',
                             //fontWeight: 'bold',
                             fontSize: '11pt'
                         }
                     },
                     showLastLabel: false,
                     showFirstLabel: false,
                     minRange: 3,
                     minTickInterval: 1,
                     min: 0,
                     max: 100,
                     opposite: false,
                     startOnTick: true,
                     //tickInterval: 5,
                     allowDecimals: false
                 }, {
                     //RHS axis
                     title: {
                         text: '%',
                         align: 'high',
                         rotation: 0,
                         offset: 20,
                         style: {
                             color: '#969696',
                             //fontWeight: 'bold',
                             fontSize: '11pt'
                         }
                     },
                     linkedTo: 0,
                     labels: {
                         style: {
                             color: '#969696',
                             //fontWeight: 'bold',
                             fontSize: '11pt'
                         }
                     },
                     showLastLabel: false,
                     minTickInterval: 1,
                     minRange: 3,
                     showFirstLabel: false,
                     startOnTick: true,
                     min: 0,
                     max: 100,
                     opposite: true,
                     //tickInterval: 10,
                     allowDecimals: false
                 }],
                 tooltip: {
                     xDateFormat: '%d-%b-%Y %l%P', //'%d-%b-%Y %l%P'
                     valueSuffix: '%',
                     valueDecimals: 1
                     //formatter: function () {
                     //  return this.x + '<br/><b>' + this.series.name + ':' + '</b>' + this.y + '%';
                     //}
                 },
                 legend: {
                     enabled: false
                     //    layout: 'vertical',
                     //    align: 'right',
                     //    verticalAlign: 'left',
                     //   x: -20,
                     //   y: 10,
                     //    borderWidth: 0
                 },
                 series: [{
                     name: 'Coalition',
                     data: lnp,
                     marker: {
                         enabled: false
                     },
                     yaxis: 0
                 }, {
                     name: 'ALP',
                     data: alp,
                     marker: {
                         enabled: false
                     },
                     yaxis: 0
                 }],
                 exporting: {
                     enabled: false
                 }
             });
###

app = angular.module 'app', ['restangular', 'ngResource', 'ui.state', 'ui.highlight', 'ui.bootstrap.buttons', 'ui.select2']

app.config ($routeProvider, $stateProvider, $urlRouterProvider, $provide, $locationProvider) ->
    $routeProvider.otherwise('/')

    $stateProvider
        .state 'home',
            url: '/'
            templateUrl: '/template/home.html'
            controller: 'HomeController'

        .state 'item',
            url: '/item'
            templateUrl: '/template/item/list.html'
            controller: 'ItemController'
        .state 'item.new',
            url: '/new'
            templateUrl: '/template/item/new.html'
            controller: 'ItemController'

        .state 'supplier',
            url: '/supplier'
            templateUrl: '/template/supplier/list.html'
            controller: 'SupplierController'
        .state 'supplier.new',
            url: '/new'
            templateUrl: '/template/supplier/new.html'
            controller: 'SupplierController'

        .state 'customer',
            url: '/customer'
            templateUrl: '/template/customer/list.html'
            controller: 'CustomerController'
        .state 'customer.new',
            url: '/new'
            templateUrl: '/template/customer/new.html'
            controller: 'CustomerController'

        .state 'purchase_invoice',
            url: '/invoice/purchase'
            templateUrl: '/template/invoice/purchase/list.html'
            controller: 'PurchaseInvoiceController'
        .state 'purchase_invoice_edit',
            url: '/invoice/purchase/:id/edit'
            templateUrl: '/template/invoice/purchase/edit.html'
            controller: 'EditPurchaseInvoiceController'

        .state 'sales_invoice',
            url: '/invoice/sales'
            templateUrl: '/template/invoice/sales/list.html'
            controller: 'SalesInvoiceController'
        .state 'sales_invoice.edit',
            url: '/new'
            templateUrl: '/template/invoice/sales/edit.html'
            controller: 'EditSalesInvoiceController'

        .state 'purchase_transaction',
            url: '/transaction/purchase'
            templateUrl: '/template/transaction/purchase/new.html'
            controller: 'PurchaseTransactionController'

        .state 'sales_transaction',
            url: '/transaction/sales'
            templateUrl: '/template/transaction/sales/new.html'
            controller: 'SalesTransactionController'

        .state 'statistic',
            url: '/statistic'
            templateUrl: '/template/statistic/index.html'
            controller: 'StatisticController'

app.run ($rootScope, $location, Restangular, AuthenticationService, SocketService) ->
    Restangular.setBaseUrl '/api'
    Restangular.setRestangularFields id: '_id'

    if location.pathname == '/login.html' and AuthenticationService.isLoggedIn()
        $location.path('/').replace()

    $rootScope.$on '$stateChangeStart', (event, next, current) ->
        location.replace '/login.html' if not AuthenticationService.isLoggedIn()
