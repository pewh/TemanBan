// Generated by CoffeeScript 1.6.3
(function() {
  var app;

  String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
  };

  app = angular.module('app', ['restangular', 'ngResource', 'ui.state', 'ui.highlight', 'ui.bootstrap.buttons', 'ui.select2']);

  app.config(function($routeProvider, $stateProvider, $urlRouterProvider, $provide, $locationProvider) {
    $routeProvider.otherwise('/');
    return $stateProvider.state('home', {
      url: '/',
      templateUrl: '/template/home.html',
      controller: 'HomeController'
    }).state('item', {
      url: '/item',
      templateUrl: '/template/item/list.html',
      controller: 'ItemController'
    }).state('item.new', {
      url: '/new',
      templateUrl: '/template/item/new.html',
      controller: 'ItemController'
    }).state('supplier', {
      url: '/supplier',
      templateUrl: '/template/supplier/list.html',
      controller: 'SupplierController'
    }).state('supplier.new', {
      url: '/new',
      templateUrl: '/template/supplier/new.html',
      controller: 'SupplierController'
    }).state('customer', {
      url: '/customer',
      templateUrl: '/template/customer/list.html',
      controller: 'CustomerController'
    }).state('customer.new', {
      url: '/new',
      templateUrl: '/template/customer/new.html',
      controller: 'CustomerController'
    }).state('purchase_invoice', {
      url: '/invoice/purchase',
      templateUrl: '/template/invoice/purchase/list.html',
      controller: 'PurchaseInvoiceController'
    }).state('purchase_invoice.edit', {
      url: '/{id}/edit',
      templateUrl: '/template/invoice/purchase/edit.html',
      controller: 'PurchaseInvoiceController'
    }).state('sales_invoice', {
      url: '/invoice/sales',
      templateUrl: '/template/invoice/sales/list.html',
      controller: 'SalesInvoiceController'
    }).state('sales_invoice.edit', {
      url: '/new',
      templateUrl: '/template/invoice/sales/edit.html',
      controller: 'SalesInvoiceController'
    }).state('purchase_transaction', {
      url: '/transaction/purchase',
      templateUrl: '/template/transaction/purchase/new.html',
      controller: 'PurchaseTransactionController'
    }).state('sales_transaction', {
      url: '/transaction/sales',
      templateUrl: '/template/transaction/sales/new.html',
      controller: 'SalesTransactionController'
    }).state('statistic_transaction', {
      url: '/statistic/transaction',
      templateUrl: '/template/statistic/transaction.html',
      controller: 'TransactionStatisticController'
    }).state('statistic_stock', {
      url: '/statistic/stock',
      templateUrl: '/template/statistic/stock.html',
      controller: 'StockStatisticController'
    });
  });

  app.run(function($rootScope, $location, Restangular, AuthenticationService, SocketService) {
    Restangular.setBaseUrl('/api');
    if (location.pathname === '/login.html' && AuthenticationService.isLoggedIn()) {
      $location.path('/').replace();
    }
    return $rootScope.$on('$stateChangeStart', function(event, next, current) {
      if (!AuthenticationService.isLoggedIn()) {
        return location.replace('/login.html');
      }
    });
  });

  app.directive('activeLink', function($location) {
    return {
      restrict: 'A',
      scope: true,
      link: function(scope, element, attribute) {
        return scope.$on('$stateChangeSuccess', function() {
          var linkPath, path;
          window.z = $location.path();
          path = '/' + $location.path().split('/')[1];
          linkPath = element.children('a').attr('href');
          if (path === linkPath.substr(2)) {
            return element.addClass('active');
          } else {
            return element.removeClass('active');
          }
        });
      }
    };
  });

  app.directive('buttonToggle', function() {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function($scope, element, attr, ngModel) {
        var classToToggle;
        classToToggle = attr.buttonToggle;
        element.bind('click', function() {
          var checked;
          checked = ngModel.$viewValue;
          return $scope.$apply(function(scope) {
            return ngModel.$setViewValue(!checked);
          });
        });
        return $scope.$watch(attr.ngModel, function(newValue, oldValue) {
          console.log('tes');
          if (newValue) {
            return element.addClass(classToToggle);
          } else {
            return element.removeClass(classToToggle);
          }
        });
      }
    };
  });

  app.directive('confirmDelete', function() {
    return {
      restrict: 'E',
      scope: {
        deleteAction: '&ngClick'
      },
      template: "<span ng-hide=confirm>\n    <a href=\"javascript:void(0)\" ng-click=\"confirm = true\">Delete</a>\n</span>\n<span ng-show=confirm>\n    <a href=\"javascript:void(0)\" class=\"label label-danger\" ng-click=\"deleteAction()\">Yes</a>\n    <a href=\"javascript:void(0)\" class=\"label label-default\" ng-click=\"confirm = false\">No</a>\n</span>"
    };
  });

  app.directive('xeditable', function(FlashService, MomentService, SocketService, Restangular, currencyFilter, $timeout) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function(scope, element, attr, ctrl) {
        var loadXeditable;
        loadXeditable = function() {
          return element.editable({
            showbuttons: false,
            emptytext: '-',
            ajaxOptions: {
              type: 'PATCH'
            },
            success: function(response, newValue) {
              if (attr.format === 'currency') {
                newValue = currencyFilter(newValue, 'IDR');
              }
              if (attr.nocommit == null) {
                return SocketService.emit("update:" + attr.category, {
                  field: attr.field,
                  name: response.name,
                  oldValue: element.text(),
                  newValue: newValue
                });
              }
            },
            error: function(response, newValue) {
              var _ref, _ref1;
              if (response.status === 500) {
                if (((_ref = response.responseJSON) != null ? _ref.code : void 0) === 11001) {
                  return FlashService.error("" + newValue + " sudah ada", MomentService.currentTime());
                } else if (((_ref1 = response.responseJSON) != null ? _ref1.name : void 0) === 'ValidationError') {
                  FlashService.error("" + attr.field + " tidak boleh kosong", MomentService.currentTime());
                  return element.editable('toggle');
                }
              }
            }
          });
        };
        return $timeout(function() {
          return loadXeditable();
        }, 10);
      }
    };
  });

  app.directive('formGroup', function() {
    return {
      template: "<div class=\"form-group\">\n    <label class=\"control-label\" for=\"\" />\n    <div class=\"controls\" ng-transclude />\n</div",
      replace: true,
      transclude: true,
      require: '^form',
      scope: {
        label: '@',
        size: '@'
      },
      link: function(scope, element) {
        var id;
        id = element.find(':input').attr('id');
        return scope["for"] = id;
      }
    };
  });

  app.filter('currency', function() {
    return function(number, currencyCode) {
      var chosenCurrency, currency;
      currency = {
        IDR: {
          sign: 'Rp',
          thousand: '.',
          decimal: ',',
          suffix: ',-'
        }
      };
      if (number) {
        chosenCurrency = currency[currencyCode];
        return accounting.formatMoney(number, chosenCurrency.sign, chosenCurrency.decimal, chosenCurrency.thousand) + chosenCurrency.suffix;
      } else {
        return '-';
      }
    };
  });

  app.factory('SessionService', function() {
    return {
      get: function(key) {
        return sessionStorage.getItem(key);
      },
      set: function(key, val) {
        return sessionStorage.setItem(key, val);
      },
      unset: function(key) {
        return sessionStorage.removeItem(key);
      }
    };
  });

  app.factory('AuthenticationService', function($rootScope, $location, $http, SessionService, FlashService) {
    return {
      login: function(credentials) {
        return $http.post('/auth/login', credentials).success(function(data) {
          if (data.length) {
            SessionService.set('authenticated', true);
            SessionService.set('username', credentials.username);
            SessionService.set('role', credentials.role);
            return location.replace('/');
          } else {
            return FlashService.error('Username atau password salah');
          }
        });
      },
      logout: function() {
        SessionService.unset('authenticated');
        SessionService.unset('username');
        return SessionService.unset('role');
      },
      isLoggedIn: function() {
        return SessionService.get('authenticated');
      },
      currentUser: function() {
        return SessionService.get('username');
      },
      currentRole: function() {
        return SessionService.get('role');
      }
    };
  });

  app.factory('FlashService', function($rootScope) {
    return toastr;
  });

  app.factory('MomentService', function($rootScope) {
    return {
      currentTime: function() {
        return moment().format('HH:mm:ss');
      }
    };
  });

  app.factory('SocketService', function($rootScope, $timeout) {
    var socket;
    socket = io.connect();
    return {
      on: function(eventName, callback) {
        return socket.on(eventName, function() {
          var args;
          args = arguments;
          return $timeout(function() {
            return callback.apply(socket, args);
          }, 0);
        });
      },
      emit: function(eventName, data, callback) {
        return socket.emit(eventName, data, function() {
          var args;
          args = arguments;
          if (callback) {
            return callback.apply(socket, args);
          }
        });
      },
      removeAllListeners: function() {
        return socket.removeAllListeners();
      }
    };
  });

  app.controller('CustomerController', function($scope, $routeParams, $location, Restangular, FlashService, MomentService, SocketService, filterFilter) {
    var customers, reload;
    customers = Restangular.all('customers');
    (reload = function() {
      return $scope.data = customers.getList();
    })();
    SocketService.on('create:customer', function(data) {
      FlashService.info("Pelanggan " + data.name + " telah ditambah", MomentService.currentTime());
      return reload();
    });
    SocketService.on('update:customer', function(data) {
      var message;
      message = "Pelanggan telah di-update <br />\nNama:    <strong>" + data.name + "</strong> <br />\nKolom:   <strong>" + data.field + "</strong> <br />\nSebelum: <strong>" + data.oldValue + "</strong> <br />\nSesudah: <strong>" + data.newValue + "</strong>";
      FlashService.info(message, MomentService.currentTime());
      return reload();
    });
    SocketService.on('delete:customer', function(data) {
      FlashService.info("Pelanggan " + data.name + " telah dihapus", MomentService.currentTime());
      return reload();
    });
    $scope.add = function() {
      return customers.post($scope.customer).then(function(customer) {
        SocketService.emit('create:customer', customer);
        $scope.customer = {
          name: '',
          address: '',
          contact: ''
        };
        return angular.element('#name').focus();
      }, function(err) {
        if (err.status === 500) {
          if (err.data.code === 11000) {
            return FlashService.error('Nama pelanggan sudah ada', MomentService.currentTime());
          }
        }
      });
    };
    $scope.remove = function(id) {
      return Restangular.one('customers', id).remove().then(function(customer) {
        return SocketService.emit('delete:customer', customer);
      });
    };
    $scope.$watch('showNewForm', function(val) {
      if ($scope.showNewForm) {
        return $location.path('/customer/new');
      } else {
        return $location.path('/customer');
      }
    });
    return $scope.$on('$destroy', function(event) {
      return SocketService.removeAllListeners();
    });
  });

  app.controller('HomeController', function($scope, $routeParams, $location, SocketService) {});

  app.controller('ItemController', function($scope, $routeParams, $location, Restangular, FlashService, MomentService, SocketService, filterFilter) {
    var items, reload;
    items = Restangular.all('items');
    (reload = function() {
      $scope.data = items.getList();
      return $scope.suppliers = Restangular.all('suppliers').getList();
    })();
    SocketService.on('create:item', function(data) {
      var message;
      message = "Barang " + data.name + " telah ditambah";
      FlashService.info(message, MomentService.currentTime());
      return reload();
    });
    SocketService.on('update:item', function(data) {
      var message;
      message = "Barang telah di-update <br />\nNama:    <strong>" + data.name + "</strong> <br />\nKolom:   <strong>" + data.field + "</strong> <br />\nSebelum: <strong>" + data.oldValue + "</strong> <br />\nSesudah: <strong>" + data.newValue + "</strong>";
      FlashService.info(message, MomentService.currentTime());
      return reload();
    });
    SocketService.on('delete:item', function(data) {
      FlashService.info("Barang " + data.name + " telah dihapus", MomentService.currentTime());
      return reload();
    });
    $scope.watchStock = function(index) {
      var _ref;
      return {
        'danger': !$scope.data.$$v[index].stock,
        'warning': (0 < (_ref = $scope.data.$$v[index].stock) && _ref < 5)
      };
    };
    $scope.add = function() {
      return items.post($scope.item).then(function(item) {
        SocketService.emit('create:item', item);
        $scope.item = {
          stock: 1,
          purchase_price: 1,
          sales_price: 1
        };
        return angular.element('#name').focus();
      }, function(err) {
        if (err.status === 500) {
          if (err.data.code === 11000) {
            return FlashService.error('Nama barang sudah ada', MomentService.currentTime());
          }
        }
      });
    };
    $scope.remove = function(id) {
      return Restangular.one('items', id).remove().then(function(item) {
        return SocketService.emit('delete:item', item);
      });
    };
    $scope.$watch('showNewForm', function(val) {
      if ($scope.showNewForm) {
        return $location.path('/item/new');
      } else {
        return $location.path('/item');
      }
    });
    /*
    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)
    
        if val isnt undefined
            SocketService.emit 'search:item', $scope.filteredData.length
    
    $scope.$on '$routeChangeStart', (scope, next, current) ->
        SocketService.emit 'search:item', $scope.data.length
    */

    return $scope.$on('$destroy', function(event) {
      return SocketService.removeAllListeners();
    });
  });

  app.controller('LoginController', function($scope, AuthenticationService) {
    $scope.credentials = {
      username: '',
      password: ''
    };
    return $scope.login = function() {
      return AuthenticationService.login($scope.credentials);
    };
  });

  app.controller('MenuController', function($scope, AuthenticationService) {
    $scope.activeLink = 'item';
    $scope.isLoggedIn = AuthenticationService.isLoggedIn();
    $scope.currentUser = AuthenticationService.currentUser();
    $scope.currentRole = AuthenticationService.currentRole();
    return $scope.logout = function() {
      return AuthenticationService.logout();
    };
    /*
    $scope.count = {}
    
    categories = [
        resource: ItemResource
        scopeName: 'item'
        event: ['connect', 'create:item', 'delete:item', 'search:item']
    ,
        resource: SupplierResource
        scopeName: 'supplier'
        event: ['connect', 'create:supplier', 'delete:supplier', 'search:supplier']
    ,
        resource: CustomerResource
        scopeName: 'customer'
        event: ['connect', 'create:customer', 'delete:customer', 'search:customer']
    ]
    
    categories.map (category) ->
        category.event.map (event) ->
            SocketService.on event, (data) ->
                if event.match(/^search:/)?
                    $scope.count[category.scopeName] = data
                else
                    category.resource.query (res) ->
                        $scope.count[category.scopeName] = res.length
    */

    /*
    
    SocketService.on 'connect', (data) ->
        ItemResource.query (res) -> $scope.count.item = res.length
        SupplierResource.query (res) -> $scope.count.supplier = res.length
        CustomerResource.query (res) -> $scope.count.customer = res.length
    
    # ITEM
    SocketService.on 'create:item', (data) ->
        ItemResource.query (res) ->
            $scope.count.item = res.length
    
    SocketService.on 'delete:item', (data) ->
        console.log 'oe'
        ItemResource.query (res) -> $scope.count.item = res.length
    
    SocketService.on 'search:item', (data) -> $scope.count.item = data
    
    # SUPPLIER
    SocketService.on 'create:supplier', (data) ->
        SupplierResource.query (res) -> $scope.count.supplier = res.length
    
    SocketService.on 'delete:supplier', (data) ->
        SupplierResource.query (res) -> $scope.count.supplier = res.length
    
    SocketService.on 'search:supplier', (data) -> $scope.count.supplier = data
    
    # CUSTOMER
    SocketService.on 'create:customer', (data) ->
        CustomerResource.query (res) -> $scope.count.customer = res.length
    
    SocketService.on 'delete:customer', (data) ->
        CustomerResource.query (res) -> $scope.count.customer = res.length
    
    SocketService.on 'search:customer', (data) -> $scope.count.customer = data
    */

  });

  app.controller('PurchaseInvoiceController', function($scope, Restangular, SocketService, FlashService, MomentService) {
    var invoices, reload;
    invoices = Restangular.all('purchase_invoices');
    (reload = function() {
      return $scope.data = invoices.getList();
    })();
    SocketService.on('delete:purchase_invoice', function(data) {
      FlashService.info("Faktur beli " + data.code + " telah dihapus", MomentService.currentTime());
      return reload();
    });
    $scope.calculateTotalPrice = function(details) {
      var purchase_price, stock, sumZipped, zipped;
      stock = _.pluck(details, 'quantity');
      purchase_price = _.pluck(_.pluck(details, 'item'), 'purchase_price');
      zipped = _.zip(stock, purchase_price);
      sumZipped = _.map(zipped, function(z) {
        return z[0] * z[1];
      });
      return _.reduce(sumZipped, function(c, v) {
        return c + v;
      });
    };
    $scope.calculateTotalQty = function(details) {
      var stock;
      stock = _.pluck(details, 'quantity');
      return _.reduce(stock, function(c, v) {
        return c + v;
      });
    };
    $scope.edit = function(id) {
      return Restangular.one('purchase_invoices', id).put().then(function(invoice) {
        return console.log(invoice);
      });
    };
    $scope.remove = function(id) {
      return Restangular.one('purchase_invoices', id).remove().then(function(invoice) {
        return SocketService.emit('delete:purchase_invoice', invoice);
      });
    };
    $scope.collapseInvoice = {};
    $scope.itemlist = function(invoiceId) {
      return $scope.collapseInvoice[invoiceId] = !$scope.collapseInvoice[invoiceId];
    };
    return $scope.$on('$destroy', function(event) {
      return SocketService.removeAllListeners();
    });
  });

  app.controller('PurchaseTransactionController', function($scope, Restangular, FlashService, SocketService, MomentService) {
    var clearCart;
    $scope.cart = [];
    $scope.suppliers = Restangular.all('suppliers').getList();
    $scope.items = Restangular.all('items').getList();
    setInterval(function() {
      return $scope.$apply(function() {
        return $scope.datetime = (new Date()).toISOString();
      });
    }, 1000);
    clearCart = function() {
      $scope.code = '';
      $scope.supplier = '';
      return $scope.cart = [];
    };
    SocketService.on('create:purchase_invoice', function(data) {
      var message;
      message = "Faktur pembelian " + data.code + " telah ditambah";
      FlashService.info(message, MomentService.currentTime());
      return clearCart();
    });
    $scope.addToCart = function() {
      var selectedItem;
      selectedItem = (_.where($scope.items.$$v, {
        _id: $scope.item
      }))[0];
      if (_.contains($scope.cart, selectedItem)) {
        return angular.element("[data-id='" + selectedItem._id + "']").focus();
      } else {
        return $scope.cart.push(selectedItem);
      }
    };
    $scope.updateTotal = function(index) {
      console.log(index);
      return $scope.cart[index].total = $scope.cart[index].qty * $scope.cart[index].purchase_price;
    };
    $scope.grandTotal = function() {
      var a, total;
      total = _.pluck($scope.cart, 'total');
      a = _.reduce(total, function(c, x) {
        return c + x;
      });
      return a;
    };
    $scope.clear = function(index) {
      return $scope.cart.splice(index, 1);
    };
    $scope.clearAll = function() {
      return $scope.cart.splice(0);
    };
    $scope.filteredItems = function() {
      return _.where($scope.items.$$v, {
        suppliers: {
          _id: $scope.supplier
        }
      });
    };
    return $scope.submit = function() {
      var invoice, items;
      items = _.map($scope.cart, function(cart) {
        return {
          item: _.values(_.pick(cart, '_id'))[0],
          quantity: _.values(_.pick(cart, 'qty'))[0]
        };
      });
      invoice = {
        created_at: $scope.datetime,
        code: $scope.code,
        supplier: $scope.supplier.name,
        details: items
      };
      Restangular.all('purchase_invoices').post(invoice).then(function(result) {
        return SocketService.emit('create:purchase_invoice', result);
      }, function(err) {
        if (err.status === 500) {
          if (err.data.code === 11000) {
            return FlashService.error('Kode faktur sudah ada', MomentService.currentTime());
          }
        }
      });
      return angular.element('#invoice_code').focus();
    };
  });

  app.controller('SalesInvoiceController', function($scope) {});

  app.controller('SalesTransactionController', function($scope, Restangular, FlashService, SocketService, MomentService) {
    var clearCart;
    $scope.cart = [];
    $scope.customers = Restangular.all('customers').getList();
    $scope.items = Restangular.all('items').getList();
    setInterval(function() {
      return $scope.$apply(function() {
        return $scope.datetime = (new Date()).toISOString();
      });
    }, 1000);
    clearCart = function() {
      $scope.code = '';
      $scope.customer = '';
      return $scope.cart = [];
    };
    SocketService.on('create:sales_invoice', function(data) {
      var message;
      message = "Faktur penjualan " + data.code + " telah ditambah";
      FlashService.info(message, MomentService.currentTime());
      return clearCart();
    });
    $scope.addToCart = function() {
      var selectedItem;
      selectedItem = (_.where($scope.items.$$v, {
        _id: $scope.item
      }))[0];
      if (_.contains($scope.cart, selectedItem)) {
        return angular.element("[data-id='" + selectedItem._id + "']").focus();
      } else {
        if (selectedItem.stock === 0) {
          return FlashService.error("Stok " + selectedItem.name + " tidak tersedia");
        } else {
          return $scope.cart.push(selectedItem);
        }
      }
    };
    $scope.updateTotal = function(index) {
      console.log(index);
      return $scope.cart[index].total = $scope.cart[index].qty * $scope.cart[index].sales_price;
    };
    $scope.grandTotal = function() {
      var a, total;
      total = _.pluck($scope.cart, 'total');
      a = _.reduce(total, function(c, x) {
        return c + x;
      });
      return a;
    };
    $scope.clear = function(index) {
      return $scope.cart.splice(index, 1);
    };
    $scope.clearAll = function() {
      return $scope.cart.splice(0);
    };
    return $scope.submit = function() {
      var invoice, items;
      items = _.map($scope.cart, function(cart) {
        return {
          item: _.values(_.pick(cart, '_id'))[0],
          quantity: _.values(_.pick(cart, 'qty'))[0]
        };
      });
      invoice = {
        created_at: $scope.datetime,
        code: $scope.code,
        customer: $scope.customer,
        details: items
      };
      Restangular.all('sales_invoices').post(invoice).then(function(result) {
        return SocketService.emit('create:sales_invoice', result);
      }, function(err) {
        if (err.status === 500) {
          if (err.data.code === 11000) {
            return FlashService.error('Kode faktur sudah ada', MomentService.currentTime());
          }
        }
      });
      return angular.element('#invoice_code').focus();
    };
  });

  app.controller('StockStatisticController', function($scope) {});

  app.controller('SupplierController', function($scope, $routeParams, $location, Restangular, FlashService, MomentService, SocketService, filterFilter) {
    var items, reload, suppliers;
    suppliers = Restangular.all('suppliers');
    items = Restangular.all('items');
    items.getList().then(function(x) {
      return $scope.itemsBySupplier = function(supplierId) {
        return _.where(x, {
          suppliers: {
            _id: supplierId
          }
        });
      };
    });
    (reload = function() {
      return $scope.data = suppliers.getList();
    })();
    SocketService.on('create:supplier', function(data) {
      var message;
      message = "Pemasok " + data.name + " telah ditambah";
      FlashService.info(message, MomentService.currentTime());
      return reload();
    });
    SocketService.on('update:supplier', function(data) {
      var message;
      message = "Pemasok telah di-update <br />\nNama:    <strong>" + data.name + "</strong> <br />\nKolom:   <strong>" + data.field + "</strong> <br />\nSebelum: <strong>" + data.oldValue + "</strong> <br />\nSesudah: <strong>" + data.newValue + "</strong>";
      FlashService.info(message, MomentService.currentTime());
      return reload();
    });
    SocketService.on('delete:supplier', function(data) {
      FlashService.info("Pemasok " + data.name + " telah dihapus", MomentService.currentTime());
      return reload();
    });
    $scope.watchStock = function(item) {
      var _ref;
      return {
        'danger': !item.stock,
        'warning': (0 < (_ref = item.stock) && _ref < 5)
      };
    };
    $scope.collapseSupplier = {};
    $scope.itemlist = function(supplierId) {
      return $scope.collapseSupplier[supplierId] = !$scope.collapseSupplier[supplierId];
    };
    $scope.add = function() {
      return suppliers.post($scope.supplier).then(function(supplier) {
        SocketService.emit('create:supplier', supplier);
        $scope.supplier = {
          name: '',
          address: '',
          contact: ''
        };
        return angular.element('#name').focus();
      }, function(err) {
        if (err.status === 500) {
          if (err.data.code === 11000) {
            return FlashService.error('Nama pemasok sudah ada', MomentService.currentTime());
          }
        }
      });
    };
    $scope.remove = function(id) {
      return Restangular.one('suppliers', id).remove().then(function(supplier) {
        return SocketService.emit('delete:supplier', supplier);
      });
    };
    $scope.$watch('showNewForm', function(val) {
      if ($scope.showNewForm) {
        return $location.path('/supplier/new');
      } else {
        return $location.path('/supplier');
      }
    });
    /*
    $scope.$watch 'search', (val) ->
        $scope.filteredData = filterFilter($scope.data, val)
    
        if val isnt undefined
            SocketService.emit 'search:supplier', $scope.filteredData?.length
    */

    $scope.$on('$routeChangeStart', function(scope, next, current) {
      return SocketService.emit('search:supplier', $scope.data.length);
    });
    return $scope.$on('$destroy', function(event) {
      return SocketService.removeAllListeners();
    });
  });

  app.controller('TransactionStatisticController', function($scope) {});

}).call(this);
