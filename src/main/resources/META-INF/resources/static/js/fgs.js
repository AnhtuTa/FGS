function addDotsToNumber(n){
    var rx = /(\d+)(\d{3})/;
    return String(n).replace(/^\d+/, function(w){
        while(rx.test(w)){
            w = w.replace(rx, '$1.$2');
        }
        return w;
    });
}