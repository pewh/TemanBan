<!DOCTYPE html>
<html ng-app=app>
<head>
    <meta name=viewport content="width=device-width, initial-scale=1">
    <title>PD Teman Ban</title>
    <link rel=stylesheet href=/vendor/select2/select2.css />
    <link rel=stylesheet href=/vendor/bootstrap/css/bootstrap.min.css />
    <link rel=stylesheet href=/vendor/bootstrap/css/bootstrap-responsive.css />
    <link rel=stylesheet href=/vendor/Sansation-fontfacekit/stylesheet.css />
    <link rel=stylesheet href=/css/style.css />
</head>
<body>
    <div class=row>
        <nav class=span3 ng-include src="'/template/menu.html'"></nav>

        <div id=content class=span9 ng-view></div>
    </div>

    <script src=/vendor/jquery/jquery.min.js></script>
    <script src=/vendor/underscore/underscore-min.js></script>
    <script src=/vendor/bootstrap/js/bootstrap.min.js></script>
    <script src=/vendor/select2/select2.min.js></script>
    <script src=/vendor/accounting/accounting.min.js></script>
    <script src=/vendor/angular/angular.min.js></script>
    <script src=/vendor/angular/angular-resource.js></script>
    <script src=/vendor/angular/highlight.js></script>
    <script src=/js/app.js></script>
</body>
</html>

