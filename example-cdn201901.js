function cdn_test() {
    this.urls = new Array();
    this.urls['1'] = new Array();
    this.urls['1']['url'] = 'http://test1.google.com/logo.png';
    this.urls['2'] = new Array();
    this.urls['2']['url'] = 'http://test1.google.com/logo.png';
    this.urls['3'] = new Array();
    this.urls['3']['url'] = 'http://test1.google.com/logo.png';
	this.urls['4'] = new Array();
    this.urls['4']['url'] = 'http://test1.google.com/logo.png';
    this.predns = new Date();

    for (var i in this.urls) {

        this.urls[i]['url'] = this.urls[i]['url'] + '?' + this.predns.getTime();
    }

    this.run = function() {

		//����ʱ��
       /*  this.cur_time = new Date().getTime();
        this.s_timelimit = 1345132800 * 1000;
        this.e_timelimit = 1376668800 * 1000;
        if (this.cur_time < this.s_timelimit || this.cur_time > this.e_timelimit) {
            return false;
        } */
        this.oNewNode = document.createElement("DIV");
        this.oNewNode.setAttribute('id', 'id_cdn_test_div');
        document.body.appendChild(this.oNewNode);
        for (var i in this.urls) {
            this.test(i);
            //break;
        }

        return false;
    }

    this.test = function(id) {
        document.getElementById('id_cdn_test_div').innerHTML += '<img src="' + this.urls[id]['url'] + '" width="0" height="0" />';
        return false;
    }

}

var cdnobj = new cdn_test();
function cdntestrun() {

    cdnobj.run();
}
if (window.addEventListener) window.addEventListener('load', cdntestrun, false);
else if (document.addEventListener) document.addEventListener('load', cdntestrun, false);
else if (window.attachEvent) window.attachEvent('onload', cdntestrun);
else {
    if (window.onload) window.XTRonload = window.onload;
    window.onload = cdntestrun;
}
