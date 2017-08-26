var target = document.getElementById('spinner');
var spinner = new Spinner({}).spin(target);

new Vue({
    el: '#app',
    data: {
        message: null,
        showSpinner: false
    },
    methods: {
        callScript: function () {
            var vue = this;
            var req = new XMLHttpRequest();

            vue.showSpinner = true;
            vue.message = null;

            req.addEventListener('load', function () {
                if (this.status == 200)
                {
                    vue.message = this.responseText;
                }
                else if (this.status == 503)
                {
                    alert('The server is temporarily overloaded. Please try again in a few minutes.');
                }
                else
                {
                    alert('Something went wrong. Please report to...');
                }
                vue.showSpinner = false;
            });
            req.open('POST', '/call-script');
            req.send();
        }
    }
})

