document.addEventListener('DOMContentLoaded', function () {
    var div = document.getElementById('flutter-container');
    div.addEventListener('click', function (event) {
        event.stopPropagation();
    });
});
