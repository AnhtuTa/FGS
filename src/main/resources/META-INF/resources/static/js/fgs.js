function addDotsToNumber(n){
    var rx = /(\d+)(\d{3})/;
    return String(n).replace(/^\d+/, function(w){
        while(rx.test(w)){
            w = w.replace(rx, '$1.$2');
        }
        return w;
    });
}
/**
 * format giá trị datetime theo locale Mỹ
 * @param date tham số có kiểu Date
 * @returns 1 chuỗi datetime đã được format
 */
function formatDateUS(date) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'pm' : 'am';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var strTime = hours + ':' + minutes + ' ' + ampm;
    return (date.getMonth() + 1) + "-" + date.getDate() + "-" + date.getFullYear() + ", at " + strTime;
}
/**
 * format giá trị datetime theo locale Việt Nam
 * @param date tham số có kiểu Date
 * @returns 1 chuỗi datetime đã được format
 */
function formatDateVN(date) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    hours = hours < 10 ? '0' + hours : hours;
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var strTime = hours + 'h' + minutes;
    return date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear() + ", lúc " + strTime;
}

function formatDate(date, locale) {
    if(locale == 'en') return formatDateUS(date);
    else if(locale == 'vi') return formatDateVN(date);
}

function addSlashDoubleQuote(input) {
	return input.replace(/"/g, '\\"');
}

function replaceNewLineWithBr(input) {
	return input.replace(/(?:\r\n|\r|\n)/g, '<br>');
}

function replaceBrWithNewLine(input) {
    return input.replace(/<br\s*[\/]?>/gi, "\n");
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

